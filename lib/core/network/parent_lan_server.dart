import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../shared/models/enums.dart';
import '../../shared/models/learning_levels.dart';
import '../../shared/models/stats_models.dart';
import '../database/app_database.dart';
import '../security/password_hasher.dart';
import '../utils/arabic_numbers.dart';

typedef VoidCallback = void Function();

class ParentLanServer {
  ParentLanServer({
    required this.database,
    InternetAddress? address,
    this.port = 8080,
    this.onChanged,
  }) : address = address ?? InternetAddress.anyIPv4;

  final AppDatabase database;
  final InternetAddress address;
  final int port;
  final VoidCallback? onChanged;

  static const protocolVersion = 1;
  static const _sessionLifetime = Duration(hours: 12);
  static const _challengeLifetime = Duration(minutes: 2);
  static const _maxBodyBytes = 16 * 1024;

  HttpServer? _server;
  StreamSubscription<HttpRequest>? _subscription;
  final _random = Random.secure();
  final _challenges = <String, _AuthChallenge>{};
  final _sessions = <String, _ParentSession>{};
  final _loginAttempts = <String, List<DateTime>>{};

  DateTime? _lastParentSeen;
  String? _lastParentAddress;
  String? _lastError;

  bool get isRunning => _server != null;

  int get boundPort => _server?.port ?? port;

  int get activeSessionCount {
    _pruneSessions();
    return _sessions.length;
  }

  DateTime? get lastParentSeen => _lastParentSeen;

  String? get lastParentAddress => _lastParentAddress;

  String? get lastError => _lastError;

  Future<void> start() async {
    if (_server != null) return;
    try {
      final server = await HttpServer.bind(address, port, shared: false);
      _server = server;
      _lastError = null;
      _subscription = server.listen(
        (request) {
          unawaited(_handle(request));
        },
        onError: (Object error) {
          _lastError = error.toString();
          onChanged?.call();
        },
      );
      onChanged?.call();
    } catch (error) {
      _lastError = error.toString();
      onChanged?.call();
      rethrow;
    }
  }

  Future<void> stop() async {
    final subscription = _subscription;
    final server = _server;
    _subscription = null;
    _server = null;
    _challenges.clear();
    _sessions.clear();
    _loginAttempts.clear();
    _lastParentSeen = null;
    _lastParentAddress = null;
    await subscription?.cancel();
    await server?.close(force: true);
    onChanged?.call();
  }

  Future<void> _handle(HttpRequest request) async {
    _applySecurityHeaders(request.response);
    final remoteAddress = request.connectionInfo?.remoteAddress;
    if (remoteAddress == null || !_isPrivateAddress(remoteAddress)) {
      await _sendError(
        request,
        HttpStatus.forbidden,
        'lan_only',
        'هذا الخادم متاح داخل الشبكة المحلية فقط.',
      );
      return;
    }

    try {
      final path = request.uri.path;
      if (request.method == 'GET' && path == '/api/v1/health') {
        await _handleHealth(request);
        return;
      }
      if (request.method == 'POST' && path == '/api/v1/auth/challenge') {
        await _handleChallenge(request, remoteAddress.address);
        return;
      }
      if (request.method == 'POST' && path == '/api/v1/auth/login') {
        await _handleLogin(request, remoteAddress.address);
        return;
      }
      if (request.method == 'POST' && path == '/api/v1/auth/logout') {
        await _handleLogout(request);
        return;
      }
      if (request.method == 'GET' && path == '/api/v1/parent/students') {
        await _handleStudents(request);
        return;
      }
      final detailMatch =
          RegExp(r'^/api/v1/parent/students/([^/]+)$').firstMatch(path);
      if (request.method == 'GET' && detailMatch != null) {
        await _handleStudentDetail(request, detailMatch.group(1)!);
        return;
      }
      await _sendError(
        request,
        HttpStatus.notFound,
        'not_found',
        'المسار غير موجود.',
      );
    } catch (error) {
      _lastError = error.toString();
      onChanged?.call();
      try {
        await _sendError(
          request,
          HttpStatus.internalServerError,
          'server_error',
          'تعذر تنفيذ الطلب.',
        );
      } catch (_) {}
    }
  }

  Future<void> _handleHealth(HttpRequest request) async {
    final parent = await database.getActiveParentUser();
    await _sendJson(request, HttpStatus.ok, {
      'service': 'math_heroes_parent',
      'protocolVersion': protocolVersion,
      'requiresAuth': true,
      'serverTime': DateTime.now().toUtc().toIso8601String(),
      'deviceName': parent?.fullName ?? 'هاتف الأبناء',
      'loginName': parent?.username ?? parent?.fullName,
    });
  }

  Future<void> _handleChallenge(
    HttpRequest request,
    String remoteAddress,
  ) async {
    if (!_allowLoginAttempt(remoteAddress)) {
      await _sendError(
        request,
        HttpStatus.tooManyRequests,
        'too_many_attempts',
        'محاولات كثيرة. انتظر قليلاً ثم حاول مجدداً.',
      );
      return;
    }
    final body = await _readJson(request);
    if (body == null) return;
    final login = body['username']?.toString() ?? '';
    final parent = await database.findActiveParentByLogin(login);
    final storedMaterial = parent?.passwordHash == null
        ? null
        : PasswordHasher.materialFrom(parent!.passwordHash!);
    final material = storedMaterial ?? _fakeMaterial();
    final challengeId = _randomToken();
    final nonce = _randomToken();
    _challenges[challengeId] = _AuthChallenge(
      userId: storedMaterial == null ? null : parent!.id,
      key: material.key,
      nonce: nonce,
      expiresAt: DateTime.now().add(_challengeLifetime),
    );
    _pruneChallenges();
    await _sendJson(request, HttpStatus.ok, {
      'challengeId': challengeId,
      'nonce': nonce,
      'salt': base64Encode(material.salt),
      'iterations': material.iterations,
      'keyLength': material.key.length,
    });
  }

  Future<void> _handleLogin(
    HttpRequest request,
    String remoteAddress,
  ) async {
    if (!_allowLoginAttempt(remoteAddress)) {
      await _sendError(
        request,
        HttpStatus.tooManyRequests,
        'too_many_attempts',
        'محاولات كثيرة. انتظر قليلاً ثم حاول مجدداً.',
      );
      return;
    }
    final body = await _readJson(request);
    if (body == null) return;
    final challengeId = body['challengeId']?.toString() ?? '';
    final proof = body['proof']?.toString() ?? '';
    final challenge = _challenges.remove(challengeId);
    if (challenge == null || challenge.expiresAt.isBefore(DateTime.now())) {
      await _sendError(
        request,
        HttpStatus.unauthorized,
        'invalid_challenge',
        'انتهت صلاحية طلب الدخول. أعد المحاولة.',
      );
      return;
    }
    if (challenge.userId == null ||
        !PasswordHasher.verifyProof(
          key: challenge.key,
          nonce: challenge.nonce,
          proof: proof,
        )) {
      await _sendError(
        request,
        HttpStatus.unauthorized,
        'invalid_credentials',
        'اسم المستخدم أو كلمة المرور غير صحيحة.',
      );
      return;
    }
    final parent = await database.getUser(challenge.userId!);
    if (parent == null || !parent.isActive || parent.role != 'parent') {
      await _sendError(
        request,
        HttpStatus.unauthorized,
        'invalid_credentials',
        'حساب ولي الأمر غير متاح.',
      );
      return;
    }
    final token = _randomToken();
    final tokenHash = _hashToken(token);
    _sessions[tokenHash] = _ParentSession(
      userId: parent.id,
      displayName: parent.fullName,
      expiresAt: DateTime.now().add(_sessionLifetime),
      lastSeenAt: DateTime.now(),
    );
    _pruneSessions();
    _lastParentSeen = DateTime.now();
    _lastParentAddress = remoteAddress;
    onChanged?.call();
    await _sendJson(request, HttpStatus.ok, {
      'token': token,
      'expiresInSeconds': _sessionLifetime.inSeconds,
      'parent': {
        'userId': parent.id,
        'displayName': parent.fullName,
      },
    });
  }

  Future<void> _handleLogout(HttpRequest request) async {
    final session = _authorize(request);
    if (session == null) {
      await _sendUnauthorized(request);
      return;
    }
    final token = _bearerToken(request);
    if (token != null) _sessions.remove(_hashToken(token));
    _lastParentSeen = DateTime.now();
    onChanged?.call();
    await _sendJson(request, HttpStatus.ok, {'ok': true});
  }

  Future<void> _handleStudents(HttpRequest request) async {
    final session = _authorize(request);
    if (session == null) {
      await _sendUnauthorized(request);
      return;
    }
    _markSeen(session, request);
    final students = await _loadStudents();
    await _sendJson(request, HttpStatus.ok, {'students': students});
  }

  Future<void> _handleStudentDetail(
    HttpRequest request,
    String encodedProfileId,
  ) async {
    final session = _authorize(request);
    if (session == null) {
      await _sendUnauthorized(request);
      return;
    }
    _markSeen(session, request);
    final profileId = Uri.decodeComponent(encodedProfileId);
    final student = await _loadStudentDetail(profileId);
    if (student == null) {
      await _sendError(
        request,
        HttpStatus.notFound,
        'student_not_found',
        'لم يتم العثور على حساب الطالب.',
      );
      return;
    }
    await _sendJson(request, HttpStatus.ok, student);
  }

  _ParentSession? _authorize(HttpRequest request) {
    final token = _bearerToken(request);
    if (token == null || token.isEmpty) return null;
    final hash = _hashToken(token);
    final session = _sessions[hash];
    if (session == null) return null;
    if (session.expiresAt.isBefore(DateTime.now())) {
      _sessions.remove(hash);
      return null;
    }
    _sessions[hash] = session.copyWith(lastSeenAt: DateTime.now());
    return session;
  }

  void _markSeen(_ParentSession session, HttpRequest request) {
    _lastParentSeen = DateTime.now();
    _lastParentAddress = request.connectionInfo?.remoteAddress.address;
    onChanged?.call();
  }

  String? _bearerToken(HttpRequest request) {
    final header = request.headers.value(HttpHeaders.authorizationHeader);
    if (header == null) return null;
    const prefix = 'Bearer ';
    if (!header.startsWith(prefix)) return null;
    return header.substring(prefix.length).trim();
  }

  Future<List<Map<String, dynamic>>> _loadStudents() async {
    final users = await database.getActiveUsers();
    final profiles = await database.getAllProfiles();
    final profilesById = {for (final profile in profiles) profile.id: profile};
    final students = <Map<String, dynamic>>[];
    for (final user in users) {
      if (user.role != 'student' || user.profileId == null) continue;
      final profile = profilesById[user.profileId!];
      if (profile == null) continue;
      students.add(_studentJson(user: user, profile: profile));
    }
    students.sort(
      (a, b) => (a['name'] as String).compareTo(b['name'] as String),
    );
    return students;
  }

  Future<Map<String, dynamic>?> _loadStudentDetail(String profileId) async {
    final profile = await database.getProfile(profileId);
    final user = await database.getUserForProfile(profileId);
    if (profile == null ||
        user == null ||
        !user.isActive ||
        user.role != 'student') {
      return null;
    }
    final stats = await database.getProfileStats(profileId);
    final daily = await database.getDailyStatus(profileId);
    final exams = await database.getExamHistory(profileId);
    final facts = await database.getFactMastery(profileId);
    final tables = await database.getTableMastery(profileId);
    final levels = await database.getActiveLearningLevels();
    final progress = await database.getStudentLevelProgressFor(profileId);
    final progressByLevel = {
      for (final item in progress) item.levelId: item,
    };
    final levelsById = {for (final level in levels) level.id: level};

    Map<String, dynamic>? currentLevel;
    for (final level in levels) {
      if (level.levelNumber != profile.currentLevel) continue;
      currentLevel = _levelJson(
        level: level,
        progress: progressByLevel[level.id],
        status: _levelStatus(
          level: level,
          progress: progressByLevel[level.id],
          currentLevel: profile.currentLevel,
        ),
      );
      break;
    }

    final completed = <Map<String, dynamic>>[];
    for (final item in progress) {
      if (item.status != 'completed') continue;
      final level = levelsById[item.levelId];
      if (level == null) continue;
      completed.add(
        _levelJson(level: level, progress: item, status: 'completed'),
      );
    }
    completed.sort((a, b) {
      final aDate = a['completedAt'] as String?;
      final bDate = b['completedAt'] as String?;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });

    final weakFacts = facts.where((fact) => fact.isWeak).toList()
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    final masteredTables =
        tables.where((table) => table.mastered).toList(growable: false);
    final strengths = <String>[
      for (final table in masteredTables)
        'جدول الضرب ${ArabicNumbers.formatInt(table.table)}',
    ];
    final bestSubjects = stats.sortedSubjects
        .where((subject) => subject.answered >= 5 && subject.accuracy >= 80)
        .take(3)
        .map((subject) => subject.section.shortLabel)
        .toList(growable: false);
    for (final subject in bestSubjects) {
      if (!strengths.contains(subject)) strengths.add(subject);
    }
    final improvements =
        weakFacts.take(8).map((fact) => fact.label).toList(growable: false);

    return {
      'student': _studentJson(user: user, profile: profile),
      'stats': _statsJson(stats),
      'daily': {
        'completedToday': daily.completedToday,
        'streak': daily.streak,
        'rewardClaimedToday': daily.rewardClaimedToday,
        'canClaimReward': daily.canClaimReward,
      },
      'exams': [for (final exam in exams) _examJson(exam)],
      'mastery': {
        'tables': [
          for (final table in tables)
            {
              'table': table.table,
              'attempts': table.attempts,
              'correct': table.correct,
              'accuracy': table.accuracy,
              'mastered': table.mastered,
            },
        ],
        'weakFacts': [
          for (final fact in weakFacts.take(12))
            {
              'section': fact.section.name,
              'factKey': fact.factKey,
              'label': fact.label,
              'attempts': fact.attempts,
              'correct': fact.correct,
              'accuracy': fact.accuracy,
              'isWeak': fact.isWeak,
            },
        ],
        'strengths': strengths.take(8).toList(growable: false),
        'improvements': improvements,
      },
      'levels': {
        'completedCount': profile.totalCompletedLevels,
        'totalLevels': levels.length,
        'current': currentLevel,
        'recentCompleted': completed.take(10).toList(growable: false),
      },
    };
  }

  Map<String, dynamic> _studentJson({
    required User user,
    required Profile profile,
  }) {
    return {
      'userId': user.id,
      'profileId': profile.id,
      'name': user.fullName,
      'avatarIndex': profile.avatarIndex,
      'schoolGrade': profile.schoolGrade,
      'currentLevel': profile.currentLevel,
      'completedLevels': profile.totalCompletedLevels,
      'stars': profile.stars,
      'gems': profile.gems,
      'points': profile.points,
    };
  }

  Map<String, dynamic> _statsJson(ProfileStats stats) {
    return {
      'examsCount': stats.examsCount,
      'totalQuestions': stats.totalQuestions,
      'correctAnswers': stats.correctAnswers,
      'wrongAnswers': stats.wrongAnswers,
      'unanswered': stats.unanswered,
      'accuracy': stats.accuracy,
      'bestAccuracy': stats.bestAccuracy,
      'perfectExams': stats.perfectExams,
      'totalStars': stats.totalStars,
      'gems': stats.gems,
      'points': stats.points,
      'learningSeconds': stats.learningSeconds,
      'todayLearningSeconds': stats.todayLearningSeconds,
      'todayExamsCount': stats.todayExamsCount,
      'lastExamAt': stats.lastExamAt?.toIso8601String(),
      'subjects': [
        for (final subject in stats.sortedSubjects)
          {
            'section': subject.section.name,
            'label': subject.section.shortLabel,
            'answered': subject.answered,
            'correct': subject.correct,
            'wrong': subject.wrong,
            'accuracy': subject.accuracy,
          },
      ],
    };
  }

  Map<String, dynamic> _examJson(ExamRecord exam) {
    return {
      'id': exam.id,
      'title': exam.title,
      'section': exam.section,
      'sectionLabel': _sectionFromName(exam.section).shortLabel,
      'difficulty': exam.difficulty,
      'difficultyLabel': LevelCatalog.difficultyLabelFor(exam.difficulty),
      'source': exam.source,
      'dailyDateKey': exam.dailyDateKey,
      'total': exam.total,
      'correct': exam.correct,
      'wrong': exam.wrong,
      'unanswered': exam.unanswered,
      'starsEarned': exam.starsEarned,
      'gemsEarned': exam.gemsEarned,
      'pointsEarned': exam.pointsEarned,
      'durationSeconds': exam.durationSeconds,
      'startedAt': exam.startedAt?.toIso8601String(),
      'createdAt': exam.createdAt.toIso8601String(),
      'status': exam.status,
    };
  }

  Map<String, dynamic> _levelJson({
    required LearningLevel level,
    required StudentLevelProgressData? progress,
    required String status,
  }) {
    return {
      'levelNumber': level.levelNumber,
      'title': level.title,
      'section': _levelSection(level.levelNumber).name,
      'sectionLabel': _levelSection(level.levelNumber).shortLabel,
      'difficulty': level.difficulty,
      'difficultyLabel': LevelCatalog.difficultyLabelFor(level.difficulty),
      'topics': level.topics
          .split('،')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      'objectives': level.objectives,
      'questionCount': level.questionCount,
      'passingScore': level.passingScore,
      'status': status,
      'bestScore': progress?.bestScore ?? 0,
      'attemptsCount': progress?.attemptsCount ?? 0,
      'completedAt': progress?.completedAt?.toIso8601String(),
    };
  }

  String _levelStatus({
    required LearningLevel level,
    required StudentLevelProgressData? progress,
    required int currentLevel,
  }) {
    if (progress?.status == 'completed') return 'completed';
    if (level.levelNumber == currentLevel) return 'current';
    return 'available';
  }

  MathSection _levelSection(int levelNumber) {
    return switch (levelNumber) {
      <= 10 => MathSection.addition,
      <= 20 => MathSection.subtraction,
      <= 30 =>
        levelNumber.isEven ? MathSection.subtraction : MathSection.addition,
      <= 60 => MathSection.multiplication,
      <= 80 => MathSection.division,
      _ => MathSection.mixed,
    };
  }

  MathSection _sectionFromName(String value) {
    for (final section in MathSection.values) {
      if (section.name == value) return section;
    }
    return MathSection.mixed;
  }

  Future<Map<String, dynamic>?> _readJson(HttpRequest request) async {
    final contentLength = request.contentLength;
    if (contentLength > _maxBodyBytes) {
      await _sendError(
        request,
        HttpStatus.requestEntityTooLarge,
        'body_too_large',
        'حجم الطلب كبير جداً.',
      );
      return null;
    }
    final contentType = request.headers.contentType;
    if (contentType != null &&
        contentType.mimeType != 'application/json' &&
        contentType.mimeType != 'text/plain') {
      await _sendError(
        request,
        HttpStatus.unsupportedMediaType,
        'invalid_content_type',
        'نوع المحتوى غير مدعوم.',
      );
      return null;
    }
    try {
      final body = await utf8.decoder.bind(request).join();
      if (body.length > _maxBodyBytes) {
        await _sendError(
          request,
          HttpStatus.requestEntityTooLarge,
          'body_too_large',
          'حجم الطلب كبير جداً.',
        );
        return null;
      }
      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        await _sendError(
          request,
          HttpStatus.badRequest,
          'invalid_body',
          'صيغة الطلب غير صحيحة.',
        );
        return null;
      }
      return Map<String, dynamic>.from(decoded);
    } on FormatException {
      await _sendError(
        request,
        HttpStatus.badRequest,
        'invalid_body',
        'صيغة الطلب غير صحيحة.',
      );
      return null;
    }
  }

  Future<void> _sendUnauthorized(HttpRequest request) {
    _lastError = 'unauthorized';
    onChanged?.call();
    return _sendError(
      request,
      HttpStatus.unauthorized,
      'unauthorized',
      'يجب تسجيل الدخول بحساب ولي الأمر.',
    );
  }

  Future<void> _sendError(
    HttpRequest request,
    int status,
    String code,
    String message,
  ) {
    return _sendJson(request, status, {
      'error': code,
      'message': message,
    });
  }

  Future<void> _sendJson(
    HttpRequest request,
    int status,
    Map<String, dynamic> payload,
  ) async {
    final response = request.response;
    response.statusCode = status;
    response.headers.contentType = ContentType(
      'application',
      'json',
      charset: 'utf-8',
    );
    response.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
    response.write(jsonEncode(payload));
    await response.close();
  }

  void _applySecurityHeaders(HttpResponse response) {
    response.headers.set('X-Content-Type-Options', 'nosniff');
    response.headers.set('X-Frame-Options', 'DENY');
    response.headers.set(
      'Referrer-Policy',
      'no-referrer',
    );
  }

  bool _allowLoginAttempt(String remoteAddress) {
    final now = DateTime.now();
    final attempts = _loginAttempts.putIfAbsent(remoteAddress, () => []);
    attempts.removeWhere(
      (time) => now.difference(time) > const Duration(minutes: 5),
    );
    if (attempts.length >= 25) return false;
    attempts.add(now);
    return true;
  }

  void _pruneChallenges() {
    final now = DateTime.now();
    _challenges.removeWhere(
      (key, challenge) => challenge.expiresAt.isBefore(now),
    );
    while (_challenges.length > 128) {
      _challenges.remove(_challenges.keys.first);
    }
  }

  void _pruneSessions() {
    final now = DateTime.now();
    _sessions.removeWhere(
      (key, session) => session.expiresAt.isBefore(now),
    );
    while (_sessions.length > 16) {
      _sessions.remove(_sessions.keys.first);
    }
  }

  PasswordHashMaterial _fakeMaterial() {
    final salt = List<int>.generate(16, (_) => _random.nextInt(256));
    return PasswordHashMaterial(
      salt: Uint8List.fromList(salt),
      iterations: PasswordHasher.defaultIterations,
      key: Uint8List.fromList(
        List<int>.generate(
          PasswordHasher.defaultKeyLength,
          (_) => _random.nextInt(256),
        ),
      ),
    );
  }

  String _randomToken() {
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  String _hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  bool _isPrivateAddress(InternetAddress address) {
    if (address.isLoopback) return true;
    final bytes = address.rawAddress;
    if (address.type == InternetAddressType.IPv4 && bytes.length == 4) {
      if (bytes[0] == 10) return true;
      if (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) return true;
      if (bytes[0] == 192 && bytes[1] == 168) return true;
      if (bytes[0] == 169 && bytes[1] == 254) return true;
      return false;
    }
    if (address.type == InternetAddressType.IPv6 && bytes.length == 16) {
      if (bytes[0] == 0xfe && (bytes[1] & 0xc0) == 0x80) return true;
      if ((bytes[0] & 0xfe) == 0xfc) return true;
    }
    return false;
  }
}

class _AuthChallenge {
  const _AuthChallenge({
    required this.userId,
    required this.key,
    required this.nonce,
    required this.expiresAt,
  });

  final String? userId;
  final List<int> key;
  final String nonce;
  final DateTime expiresAt;
}

class _ParentSession {
  const _ParentSession({
    required this.userId,
    required this.displayName,
    required this.expiresAt,
    required this.lastSeenAt,
  });

  final String userId;
  final String displayName;
  final DateTime expiresAt;
  final DateTime lastSeenAt;

  _ParentSession copyWith({DateTime? lastSeenAt}) {
    return _ParentSession(
      userId: userId,
      displayName: displayName,
      expiresAt: expiresAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
