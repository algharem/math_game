import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../shared/models/remote_parent_models.dart';
import '../security/password_hasher.dart';
import 'lan_connection.dart';

class LanApiException implements Exception {
  const LanApiException(
    this.message, {
    this.code,
    this.statusCode,
  });

  final String message;
  final String? code;
  final int? statusCode;

  bool get unauthorized => statusCode == HttpStatus.unauthorized;

  bool get notFound => statusCode == HttpStatus.notFound;

  @override
  String toString() => message;
}

class ParentLanClient {
  ParentLanClient(
    this.connection, {
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final LanConnectionInfo connection;
  final http.Client _http;

  String? _token;
  String? _username;
  String? _password;

  bool get hasCredentials => _username != null && _password != null;

  String? get username => _username;

  String? get token => _token;

  static Future<Map<String, dynamic>> probe(String baseUrl) async {
    final connection = LanConnectionInfo.tryCreate(baseUrl);
    if (connection == null) {
      throw const LanApiException(
        'عنوان الاتصال غير صحيح. استخدم عنوان IP والمنفذ من هاتف الأبناء.',
      );
    }
    final client = ParentLanClient(connection);
    try {
      return await client.health();
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> health() {
    return _get('/health', authorized: false);
  }

  Future<void> authenticate(String username, String password) async {
    final challenge = await _post(
      '/auth/challenge',
      {'username': username},
      authorized: false,
    );
    final material = PasswordHashMaterial(
      salt: base64Decode(challenge['salt'] as String),
      iterations: (challenge['iterations'] as num).toInt(),
      key: PasswordHasher.deriveKey(
        password,
        salt: base64Decode(challenge['salt'] as String),
        iterations: (challenge['iterations'] as num).toInt(),
        keyLength: (challenge['keyLength'] as num).toInt(),
      ),
    );
    final proof = PasswordHasher.proofForNonce(
      key: material.key,
      nonce: challenge['nonce'] as String,
    );
    final result = await _post(
      '/auth/login',
      {
        'challengeId': challenge['challengeId'],
        'proof': proof,
      },
      authorized: false,
    );
    _token = result['token']?.toString();
    _username = username.trim();
    _password = password;
    if (_token == null || _token!.isEmpty) {
      throw const LanApiException('تعذر الحصول على جلسة دخول.');
    }
  }

  Future<void> reauthenticate() async {
    final username = _username;
    final password = _password;
    if (username == null || password == null) {
      throw const LanApiException(
        'انتهت الجلسة. أعد تسجيل الدخول.',
        code: 'unauthorized',
        statusCode: HttpStatus.unauthorized,
      );
    }
    _token = null;
    await authenticate(username, password);
  }

  Future<List<RemoteStudentSummary>> fetchStudents() async {
    final json = await _get('/parent/students', retryAuth: true);
    final items = (json['students'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((item) => RemoteStudentSummary.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  Future<RemoteStudentDetail> fetchStudentDetail(String profileId) async {
    final encoded = Uri.encodeComponent(profileId);
    final json = await _get('/parent/students/$encoded', retryAuth: true);
    return RemoteStudentDetail.fromJson(json);
  }

  Future<void> logout() async {
    if (_token == null) return;
    try {
      await _post('/auth/logout', const {}, retryAuth: false);
    } catch (_) {
      // Best-effort logout.
    } finally {
      _token = null;
    }
  }

  void close() {
    _token = null;
    _http.close();
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    bool authorized = true,
    bool retryAuth = false,
  }) async {
    try {
      return await _request('GET', path, authorized: authorized);
    } on LanApiException catch (error) {
      if (retryAuth && error.unauthorized && hasCredentials) {
        await reauthenticate();
        return _request('GET', path, authorized: authorized);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Object body, {
    bool authorized = true,
    bool retryAuth = false,
  }) async {
    try {
      return await _request('POST', path, body: body, authorized: authorized);
    } on LanApiException catch (error) {
      if (retryAuth && error.unauthorized && hasCredentials) {
        await reauthenticate();
        return _request('POST', path, body: body, authorized: authorized);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Object? body,
    required bool authorized,
  }) async {
    final uri = Uri.parse('${connection.baseUrl}/api/v1$path');
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
    };
    if (body != null) {
      headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=utf-8';
    }
    if (authorized) {
      final token = _token;
      if (token == null || token.isEmpty) {
        throw const LanApiException(
          'انتهت الجلسة. أعد تسجيل الدخول.',
          code: 'unauthorized',
          statusCode: HttpStatus.unauthorized,
        );
      }
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    try {
      final request = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      final streamed = await _http.send(request).timeout(
            const Duration(seconds: 10),
          );
      final responseBody = await streamed.stream.bytesToString();
      final decoded = _decode(responseBody);
      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return decoded ?? const {};
      }
      throw LanApiException(
        (decoded?['message'] as String?) ??
            _defaultMessage(streamed.statusCode),
        code: decoded?['error']?.toString(),
        statusCode: streamed.statusCode,
      );
    } on TimeoutException {
      throw const LanApiException(
        'انتهت مهلة الاتصال بهاتف الأبناء. تأكد أن الهاتفين على نفس شبكة Wi-Fi.',
      );
    } on SocketException {
      throw const LanApiException(
        'تعذر الاتصال بهاتف الأبناء. تأكد أن الخادم يعمل وأن الهاتفين على نفس شبكة Wi-Fi.',
      );
    } on http.ClientException {
      throw const LanApiException(
        'تعذر الاتصال بهاتف الأبناء. تأكد من عنوان IP والمنفذ.',
      );
    } on FormatException {
      throw const LanApiException('وصلت بيانات غير متوقعة من هاتف الأبناء.');
    }
  }

  Map<String, dynamic>? _decode(String body) {
    if (body.trim().isEmpty) return null;
    final decoded = jsonDecode(body);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
    return null;
  }

  String _defaultMessage(int statusCode) {
    if (statusCode == HttpStatus.unauthorized) {
      return 'انتهت الجلسة أو بيانات الدخول غير صحيحة.';
    }
    if (statusCode == HttpStatus.forbidden) {
      return 'الاتصال متاح داخل الشبكة المحلية فقط.';
    }
    if (statusCode == HttpStatus.tooManyRequests) {
      return 'محاولات كثيرة. انتظر قليلاً ثم حاول مجدداً.';
    }
    return 'تعذر إكمال الطلب من هاتف الأبناء.';
  }
}

class RemoteParentSession {
  RemoteParentSession(this.connection, this.client);

  final LanConnectionInfo connection;
  final ParentLanClient client;
}
