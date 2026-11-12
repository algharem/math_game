import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/services/audio_service.dart';
import 'core/services/data_backup_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }
  await DataBackupService.applyPendingRestoreIfAny();

  final preferences = await SharedPreferences.getInstance();
  final settingsService = SettingsService(preferences);
  final settings = settingsService.load();
  final audio = AudioService()..enabled = settings.soundEnabled;
  final tts = TtsService()..enabled = settings.ttsEnabled;

  unawaited(audio.initialize());
  unawaited(tts.initialize(speechRate: settings.speechRate));

  runApp(
    ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(settingsService),
        audioServiceProvider.overrideWithValue(audio),
        ttsServiceProvider.overrideWithValue(tts),
      ],
      child: const MathHeroesApp(),
    ),
  );
}
