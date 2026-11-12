import 'enums.dart';

class RemoteStudentSummary {
  const RemoteStudentSummary({
    required this.userId,
    required this.profileId,
    required this.name,
    required this.avatarIndex,
    required this.schoolGrade,
    required this.currentLevel,
    required this.completedLevels,
    required this.stars,
    required this.gems,
    required this.points,
  });

  final String userId;
  final String profileId;
  final String name;
  final int avatarIndex;
  final int schoolGrade;
  final int currentLevel;
  final int completedLevels;
  final int stars;
  final int gems;
  final int points;

  factory RemoteStudentSummary.fromJson(Map<String, dynamic> json) {
    return RemoteStudentSummary(
      userId: _string(json['userId']),
      profileId: _string(json['profileId']),
      name: _string(json['name']),
      avatarIndex: _int(json['avatarIndex']),
      schoolGrade: _int(json['schoolGrade'], fallback: 1),
      currentLevel: _int(json['currentLevel'], fallback: 1),
      completedLevels: _int(json['completedLevels']),
      stars: _int(json['stars']),
      gems: _int(json['gems']),
      points: _int(json['points']),
    );
  }
}

class RemoteSubjectPerformance {
  const RemoteSubjectPerformance({
    required this.section,
    required this.label,
    required this.answered,
    required this.correct,
    required this.wrong,
    required this.accuracy,
  });

  final MathSection section;
  final String label;
  final int answered;
  final int correct;
  final int wrong;
  final double accuracy;

  factory RemoteSubjectPerformance.fromJson(Map<String, dynamic> json) {
    return RemoteSubjectPerformance(
      section: _section(json['section']),
      label: _string(json['label']),
      answered: _int(json['answered']),
      correct: _int(json['correct']),
      wrong: _int(json['wrong']),
      accuracy: _double(json['accuracy']),
    );
  }
}

class RemoteProfileStats {
  const RemoteProfileStats({
    required this.examsCount,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unanswered,
    required this.accuracy,
    required this.bestAccuracy,
    required this.perfectExams,
    required this.totalStars,
    required this.gems,
    required this.points,
    required this.learningSeconds,
    required this.todayLearningSeconds,
    required this.todayExamsCount,
    required this.lastExamAt,
    required this.subjects,
  });

  final int examsCount;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int unanswered;
  final double accuracy;
  final double bestAccuracy;
  final int perfectExams;
  final int totalStars;
  final int gems;
  final int points;
  final int learningSeconds;
  final int todayLearningSeconds;
  final int todayExamsCount;
  final DateTime? lastExamAt;
  final List<RemoteSubjectPerformance> subjects;

  static const empty = RemoteProfileStats(
    examsCount: 0,
    totalQuestions: 0,
    correctAnswers: 0,
    wrongAnswers: 0,
    unanswered: 0,
    accuracy: 0,
    bestAccuracy: 0,
    perfectExams: 0,
    totalStars: 0,
    gems: 0,
    points: 0,
    learningSeconds: 0,
    todayLearningSeconds: 0,
    todayExamsCount: 0,
    lastExamAt: null,
    subjects: [],
  );

  factory RemoteProfileStats.fromJson(Map<String, dynamic> json) {
    final subjects = (json['subjects'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((item) => RemoteSubjectPerformance.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
    return RemoteProfileStats(
      examsCount: _int(json['examsCount']),
      totalQuestions: _int(json['totalQuestions']),
      correctAnswers: _int(json['correctAnswers']),
      wrongAnswers: _int(json['wrongAnswers']),
      unanswered: _int(json['unanswered']),
      accuracy: _double(json['accuracy']),
      bestAccuracy: _double(json['bestAccuracy']),
      perfectExams: _int(json['perfectExams']),
      totalStars: _int(json['totalStars']),
      gems: _int(json['gems']),
      points: _int(json['points']),
      learningSeconds: _int(json['learningSeconds']),
      todayLearningSeconds: _int(json['todayLearningSeconds']),
      todayExamsCount: _int(json['todayExamsCount']),
      lastExamAt: _date(json['lastExamAt']),
      subjects: subjects,
    );
  }
}

class RemoteDailyStatus {
  const RemoteDailyStatus({
    required this.completedToday,
    required this.streak,
    required this.rewardClaimedToday,
    required this.canClaimReward,
  });

  final bool completedToday;
  final int streak;
  final bool rewardClaimedToday;
  final bool canClaimReward;

  factory RemoteDailyStatus.fromJson(Map<String, dynamic> json) {
    return RemoteDailyStatus(
      completedToday: json['completedToday'] == true,
      streak: _int(json['streak']),
      rewardClaimedToday: json['rewardClaimedToday'] == true,
      canClaimReward: json['canClaimReward'] == true,
    );
  }
}

class RemoteExamRecord {
  const RemoteExamRecord({
    required this.id,
    required this.title,
    required this.section,
    required this.sectionLabel,
    required this.difficulty,
    required this.difficultyLabel,
    required this.source,
    required this.dailyDateKey,
    required this.total,
    required this.correct,
    required this.wrong,
    required this.unanswered,
    required this.starsEarned,
    required this.gemsEarned,
    required this.pointsEarned,
    required this.durationSeconds,
    required this.startedAt,
    required this.createdAt,
    required this.status,
  });

  final int id;
  final String title;
  final MathSection section;
  final String sectionLabel;
  final String difficulty;
  final String difficultyLabel;
  final String source;
  final String? dailyDateKey;
  final int total;
  final int correct;
  final int wrong;
  final int unanswered;
  final int starsEarned;
  final int gemsEarned;
  final int pointsEarned;
  final int durationSeconds;
  final DateTime? startedAt;
  final DateTime createdAt;
  final String status;

  double get accuracy => total == 0 ? 0 : correct / total * 100;

  factory RemoteExamRecord.fromJson(Map<String, dynamic> json) {
    return RemoteExamRecord(
      id: _int(json['id']),
      title: _string(json['title']),
      section: _section(json['section']),
      sectionLabel: _string(json['sectionLabel']),
      difficulty: _string(json['difficulty']),
      difficultyLabel: _string(json['difficultyLabel']),
      source: _string(json['source']),
      dailyDateKey: json['dailyDateKey']?.toString(),
      total: _int(json['total']),
      correct: _int(json['correct']),
      wrong: _int(json['wrong']),
      unanswered: _int(json['unanswered']),
      starsEarned: _int(json['starsEarned']),
      gemsEarned: _int(json['gemsEarned']),
      pointsEarned: _int(json['pointsEarned']),
      durationSeconds: _int(json['durationSeconds']),
      startedAt: _date(json['startedAt']),
      createdAt: _date(json['createdAt']) ?? DateTime.now(),
      status: _string(json['status'], fallback: 'completed'),
    );
  }
}

class RemoteFactMastery {
  const RemoteFactMastery({
    required this.section,
    required this.factKey,
    required this.label,
    required this.attempts,
    required this.correct,
    required this.accuracy,
    required this.isWeak,
  });

  final MathSection section;
  final String factKey;
  final String label;
  final int attempts;
  final int correct;
  final double accuracy;
  final bool isWeak;

  factory RemoteFactMastery.fromJson(Map<String, dynamic> json) {
    return RemoteFactMastery(
      section: _section(json['section']),
      factKey: _string(json['factKey']),
      label: _string(json['label']),
      attempts: _int(json['attempts']),
      correct: _int(json['correct']),
      accuracy: _double(json['accuracy']),
      isWeak: json['isWeak'] == true,
    );
  }
}

class RemoteTableMastery {
  const RemoteTableMastery({
    required this.table,
    required this.attempts,
    required this.correct,
    required this.accuracy,
    required this.mastered,
  });

  final int table;
  final int attempts;
  final int correct;
  final double accuracy;
  final bool mastered;

  factory RemoteTableMastery.fromJson(Map<String, dynamic> json) {
    return RemoteTableMastery(
      table: _int(json['table']),
      attempts: _int(json['attempts']),
      correct: _int(json['correct']),
      accuracy: _double(json['accuracy']),
      mastered: json['mastered'] == true,
    );
  }
}

class RemoteLevelProgress {
  const RemoteLevelProgress({
    required this.levelNumber,
    required this.title,
    required this.section,
    required this.sectionLabel,
    required this.difficulty,
    required this.difficultyLabel,
    required this.topics,
    required this.objectives,
    required this.questionCount,
    required this.passingScore,
    required this.status,
    required this.bestScore,
    required this.attemptsCount,
    required this.completedAt,
  });

  final int levelNumber;
  final String title;
  final MathSection section;
  final String sectionLabel;
  final String difficulty;
  final String difficultyLabel;
  final List<String> topics;
  final String objectives;
  final int questionCount;
  final int passingScore;
  final String status;
  final int bestScore;
  final int attemptsCount;
  final DateTime? completedAt;

  bool get completed => status == 'completed';

  factory RemoteLevelProgress.fromJson(Map<String, dynamic> json) {
    final topics = (json['topics'] as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .toList(growable: false);
    return RemoteLevelProgress(
      levelNumber: _int(json['levelNumber']),
      title: _string(json['title']),
      section: _section(json['section']),
      sectionLabel: _string(json['sectionLabel']),
      difficulty: _string(json['difficulty']),
      difficultyLabel: _string(json['difficultyLabel']),
      topics: topics,
      objectives: _string(json['objectives']),
      questionCount: _int(json['questionCount']),
      passingScore: _int(json['passingScore']),
      status: _string(json['status'], fallback: 'available'),
      bestScore: _int(json['bestScore']),
      attemptsCount: _int(json['attemptsCount']),
      completedAt: _date(json['completedAt']),
    );
  }
}

class RemoteLevelOverview {
  const RemoteLevelOverview({
    required this.completedCount,
    required this.totalLevels,
    required this.current,
    required this.recentCompleted,
  });

  final int completedCount;
  final int totalLevels;
  final RemoteLevelProgress? current;
  final List<RemoteLevelProgress> recentCompleted;

  double get completionRatio =>
      totalLevels == 0 ? 0 : completedCount / totalLevels;

  factory RemoteLevelOverview.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'];
    final current = currentJson is Map
        ? RemoteLevelProgress.fromJson(
            Map<String, dynamic>.from(currentJson),
          )
        : null;
    final recent = (json['recentCompleted'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((item) => RemoteLevelProgress.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
    return RemoteLevelOverview(
      completedCount: _int(json['completedCount']),
      totalLevels: _int(json['totalLevels']),
      current: current,
      recentCompleted: recent,
    );
  }
}

class RemoteMasteryOverview {
  const RemoteMasteryOverview({
    required this.tables,
    required this.weakFacts,
    required this.strengths,
    required this.improvements,
  });

  final List<RemoteTableMastery> tables;
  final List<RemoteFactMastery> weakFacts;
  final List<String> strengths;
  final List<String> improvements;

  factory RemoteMasteryOverview.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(
      dynamic value,
      T Function(Map<String, dynamic>) parser,
    ) {
      return (value as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    }

    return RemoteMasteryOverview(
      tables: parseList(json['tables'], RemoteTableMastery.fromJson),
      weakFacts: parseList(json['weakFacts'], RemoteFactMastery.fromJson),
      strengths: (json['strengths'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      improvements: (json['improvements'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
    );
  }
}

class RemoteStudentDetail {
  const RemoteStudentDetail({
    required this.student,
    required this.stats,
    required this.daily,
    required this.exams,
    required this.mastery,
    required this.levels,
  });

  final RemoteStudentSummary student;
  final RemoteProfileStats stats;
  final RemoteDailyStatus daily;
  final List<RemoteExamRecord> exams;
  final RemoteMasteryOverview mastery;
  final RemoteLevelOverview levels;

  factory RemoteStudentDetail.fromJson(Map<String, dynamic> json) {
    return RemoteStudentDetail(
      student: RemoteStudentSummary.fromJson(
        Map<String, dynamic>.from(json['student'] as Map? ?? const {}),
      ),
      stats: RemoteProfileStats.fromJson(
        Map<String, dynamic>.from(json['stats'] as Map? ?? const {}),
      ),
      daily: RemoteDailyStatus.fromJson(
        Map<String, dynamic>.from(json['daily'] as Map? ?? const {}),
      ),
      exams: (json['exams'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => RemoteExamRecord.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(growable: false),
      mastery: RemoteMasteryOverview.fromJson(
        Map<String, dynamic>.from(json['mastery'] as Map? ?? const {}),
      ),
      levels: RemoteLevelOverview.fromJson(
        Map<String, dynamic>.from(json['levels'] as Map? ?? const {}),
      ),
    );
  }
}

String _string(dynamic value, {String fallback = ''}) {
  return value == null ? fallback : value.toString();
}

int _int(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _double(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

MathSection _section(dynamic value) {
  final name = value?.toString();
  for (final section in MathSection.values) {
    if (section.name == name) return section;
  }
  return MathSection.mixed;
}
