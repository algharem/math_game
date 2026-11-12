import 'dart:async';

import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../services/settings_service.dart';
import 'lan_connection.dart';
import 'lan_network.dart';
import 'parent_lan_server.dart';

class ParentLanController extends ChangeNotifier {
  ParentLanController({
    required AppDatabase database,
    required SettingsService settings,
  })  : _database = database,
        _settings = settings {
    _port = _settings.lanServerPort;
  }

  final AppDatabase _database;
  final SettingsService _settings;

  bool _initialized = false;
  bool _initializing = false;
  bool _starting = false;
  bool _stopping = false;
  int _port = 8080;
  String? _ipAddress;
  String? _error;
  String? _parentLoginName;
  String? _parentDeviceName;
  bool _parentNeedsPassword = true;
  ParentLanServer? _server;

  bool get initialized => _initialized;

  bool get isRunning => _server?.isRunning == true;

  bool get isStarting => _starting;

  bool get isStopping => _stopping;

  int get port => _port;

  String? get ipAddress => _ipAddress;

  String? get error => _error;

  String? get parentLoginName => _parentLoginName;

  String? get parentDeviceName => _parentDeviceName;

  bool get parentNeedsPassword => _parentNeedsPassword;

  DateTime? get lastParentSeen => _server?.lastParentSeen;

  String? get lastParentAddress => _server?.lastParentAddress;

  int get activeSessionCount => _server?.activeSessionCount ?? 0;

  LanConnectionInfo? get connectionInfo {
    final ip = _ipAddress;
    final server = _server;
    if (ip == null || server == null || !server.isRunning) return null;
    return LanConnectionInfo(
      baseUrl: 'http://$ip:${server.boundPort}',
      deviceName: _parentDeviceName,
      loginName: _parentLoginName,
    );
  }

  Future<void> initialize() async {
    if (_initialized || _initializing) return;
    _initializing = true;
    try {
      _port = _normalizePort(_settings.lanServerPort);
      await refreshParentInfo();
      await refreshNetwork();
      if (_settings.lanServerEnabled) {
        await start(persist: false);
      }
      _initialized = true;
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> refreshParentInfo() async {
    final parent = await _database.getActiveParentUser();
    _parentLoginName = parent?.username?.trim().isNotEmpty == true
        ? parent!.username!.trim()
        : parent?.fullName;
    _parentDeviceName = parent?.fullName ?? 'هاتف الأبناء';
    _parentNeedsPassword =
        parent?.passwordHash == null || parent!.passwordHash!.trim().isEmpty;
    notifyListeners();
  }

  Future<void> refreshNetwork() async {
    _ipAddress = await LanNetwork.preferredLocalIPv4();
    notifyListeners();
  }

  Future<void> setPort(int port) async {
    final normalized = _normalizePort(port);
    _port = normalized;
    await _settings.setLanServerPort(normalized);
    notifyListeners();
  }

  Future<void> start({bool persist = true}) async {
    if (_starting) return;
    _starting = true;
    _error = null;
    notifyListeners();
    try {
      await refreshParentInfo();
      await refreshNetwork();
      if (_ipAddress == null) {
        throw StateError(
          'تعذر تحديد عنوان IP المحلي. تأكد أن الجهاز متصل بشبكة Wi-Fi.',
        );
      }
      if (_parentNeedsPassword) {
        throw StateError(
          'عيّن كلمة مرور لحساب ولي الأمر أولاً من شاشة الدخول أو الإعدادات.',
        );
      }
      if (_server?.isRunning == true) {
        if (persist) await _settings.setLanServerEnabled(true);
        return;
      }
      final server = ParentLanServer(
        database: _database,
        port: _port,
        onChanged: notifyListeners,
      );
      await server.start();
      _server = server;
      _port = server.boundPort;
      await _settings.setLanServerPort(_port);
      if (persist) await _settings.setLanServerEnabled(true);
    } catch (error) {
      _error = error is StateError ? error.message : error.toString();
      await _server?.stop();
      _server = null;
      rethrow;
    } finally {
      _starting = false;
      notifyListeners();
    }
  }

  Future<void> stop({bool persist = true}) async {
    if (_stopping) return;
    _stopping = true;
    _error = null;
    notifyListeners();
    try {
      await _server?.stop();
      _server = null;
      if (persist) await _settings.setLanServerEnabled(false);
    } finally {
      _stopping = false;
      notifyListeners();
    }
  }

  int _normalizePort(int port) {
    if (port < 1024) return 8080;
    if (port > 65535) return 8080;
    return port;
  }

  @override
  void dispose() {
    unawaited(_server?.stop() ?? Future<void>.value());
    super.dispose();
  }
}
