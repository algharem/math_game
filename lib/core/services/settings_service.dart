import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/enums.dart';

class AppSettings {
  const AppSettings({
    required this.soundEnabled,
    required this.ttsEnabled,
    required this.speechRate,
    required this.largeText,
    required this.highContrast,
    required this.timersEnabled,
    required this.dailyGoalMinutes,
    required this.selectedProfileId,
    required this.parentPinHash,
    required this.defaultDifficulty,
  });

  final bool soundEnabled;
  final bool ttsEnabled;
  final double speechRate;
  final bool largeText;
  final bool highContrast;
  final bool timersEnabled;
  final int dailyGoalMinutes;
  final String? selectedProfileId;
  final String parentPinHash;
  final Difficulty defaultDifficulty;

  static const String defaultPin = '1234';

  static String hashPin(String pin) =>
      sha256.convert(utf8.encode(pin.trim())).toString();

  static AppSettings defaults() => AppSettings(
        soundEnabled: true,
        ttsEnabled: true,
        speechRate: 0.45,
        largeText: false,
        highContrast: false,
        timersEnabled: true,
        dailyGoalMinutes: 15,
        selectedProfileId: null,
        parentPinHash: hashPin(defaultPin),
        defaultDifficulty: Difficulty.easy,
      );

  bool verifyPin(String pin) => hashPin(pin) == parentPinHash;

  bool get usesDefaultPin => parentPinHash == hashPin(defaultPin);

  AppSettings copyWith({
    bool? soundEnabled,
    bool? ttsEnabled,
    double? speechRate,
    bool? largeText,
    bool? highContrast,
    bool? timersEnabled,
    int? dailyGoalMinutes,
    String? selectedProfileId,
    bool clearSelectedProfile = false,
    String? parentPinHash,
    Difficulty? defaultDifficulty,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      speechRate: speechRate ?? this.speechRate,
      largeText: largeText ?? this.largeText,
      highContrast: highContrast ?? this.highContrast,
      timersEnabled: timersEnabled ?? this.timersEnabled,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      selectedProfileId: clearSelectedProfile
          ? null
          : (selectedProfileId ?? this.selectedProfileId),
      parentPinHash: parentPinHash ?? this.parentPinHash,
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
    );
  }
}

class SettingsService {
  SettingsService(this._prefs);

  final SharedPreferences _prefs;

  static const _soundKey = 'settings.sound';
  static const _ttsKey = 'settings.tts';
  static const _speechRateKey = 'settings.speech_rate';
  static const _largeTextKey = 'settings.large_text';
  static const _highContrastKey = 'settings.high_contrast';
  static const _timersKey = 'settings.timers';
  static const _dailyGoalKey = 'settings.daily_goal';
  static const _selectedProfileKey = 'settings.selected_profile';
  static const _parentPinKey = 'settings.parent_pin_hash';
  static const _difficultyKey = 'settings.default_difficulty';
  static const _lanServerEnabledKey = 'lan.server_enabled';
  static const _lanServerPortKey = 'lan.server_port';
  static const _remoteParentUrlKey = 'lan.remote_url';
  static const _remoteParentLoginKey = 'lan.remote_login';
  static const _remoteParentDeviceKey = 'lan.remote_device';
  static const _remoteParentLastSyncKey = 'lan.remote_last_sync';

  AppSettings load() {
    final defaults = AppSettings.defaults();
    return AppSettings(
      soundEnabled: _prefs.getBool(_soundKey) ?? defaults.soundEnabled,
      ttsEnabled: _prefs.getBool(_ttsKey) ?? defaults.ttsEnabled,
      speechRate: _prefs.getDouble(_speechRateKey) ?? defaults.speechRate,
      largeText: _prefs.getBool(_largeTextKey) ?? defaults.largeText,
      highContrast: _prefs.getBool(_highContrastKey) ?? defaults.highContrast,
      timersEnabled: _prefs.getBool(_timersKey) ?? defaults.timersEnabled,
      dailyGoalMinutes:
          _prefs.getInt(_dailyGoalKey) ?? defaults.dailyGoalMinutes,
      selectedProfileId: _prefs.getString(_selectedProfileKey),
      parentPinHash: _prefs.getString(_parentPinKey) ?? defaults.parentPinHash,
      defaultDifficulty: _difficultyFromName(
        _prefs.getString(_difficultyKey),
      ),
    );
  }

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setBool(_soundKey, settings.soundEnabled),
      _prefs.setBool(_ttsKey, settings.ttsEnabled),
      _prefs.setDouble(_speechRateKey, settings.speechRate),
      _prefs.setBool(_largeTextKey, settings.largeText),
      _prefs.setBool(_highContrastKey, settings.highContrast),
      _prefs.setBool(_timersKey, settings.timersEnabled),
      _prefs.setInt(_dailyGoalKey, settings.dailyGoalMinutes),
      _prefs.setString(_parentPinKey, settings.parentPinHash),
      _prefs.setString(_difficultyKey, settings.defaultDifficulty.name),
      if (settings.selectedProfileId != null)
        _prefs.setString(_selectedProfileKey, settings.selectedProfileId!)
      else
        _prefs.remove(_selectedProfileKey),
    ]);
  }

  bool get lanServerEnabled => _prefs.getBool(_lanServerEnabledKey) ?? false;

  int get lanServerPort => _prefs.getInt(_lanServerPortKey) ?? 8080;

  Future<void> setLanServerEnabled(bool enabled) async {
    await _prefs.setBool(_lanServerEnabledKey, enabled);
  }

  Future<void> setLanServerPort(int port) async {
    await _prefs.setInt(_lanServerPortKey, port);
  }

  String? get remoteParentUrl => _prefs.getString(_remoteParentUrlKey);

  String? get remoteParentLoginName => _prefs.getString(_remoteParentLoginKey);

  String? get remoteParentDeviceName =>
      _prefs.getString(_remoteParentDeviceKey);

  DateTime? get remoteParentLastSync {
    final value = _prefs.getString(_remoteParentLastSyncKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> saveRemoteParentConnection({
    required String url,
    String? loginName,
    String? deviceName,
    DateTime? lastSync,
  }) async {
    await Future.wait([
      _prefs.setString(_remoteParentUrlKey, url),
      if (loginName == null || loginName.trim().isEmpty)
        _prefs.remove(_remoteParentLoginKey)
      else
        _prefs.setString(_remoteParentLoginKey, loginName.trim()),
      if (deviceName == null || deviceName.trim().isEmpty)
        _prefs.remove(_remoteParentDeviceKey)
      else
        _prefs.setString(_remoteParentDeviceKey, deviceName.trim()),
      if (lastSync == null)
        _prefs.remove(_remoteParentLastSyncKey)
      else
        _prefs.setString(_remoteParentLastSyncKey, lastSync.toIso8601String()),
    ]);
  }

  Future<void> clearRemoteParentConnection() async {
    await Future.wait([
      _prefs.remove(_remoteParentUrlKey),
      _prefs.remove(_remoteParentLoginKey),
      _prefs.remove(_remoteParentDeviceKey),
      _prefs.remove(_remoteParentLastSyncKey),
    ]);
  }

  Difficulty _difficultyFromName(String? value) {
    for (final difficulty in Difficulty.values) {
      if (difficulty.name == value) return difficulty;
    }
    return Difficulty.easy;
  }
}
