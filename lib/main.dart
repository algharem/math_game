import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/database/app_database.dart';
import 'core/services/audio_service.dart';
import 'core/services/data_backup_service.dart';
import 'core/services/dev_account_seeder.dart';
import 'core/services/settings_service.dart';
import 'core/services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }
  await DataBackupService.applyPendingRestoreIfAny();
  final restoreError = await DataBackupService.takeLastRestoreError();
  await _seedDevelopmentAccounts();

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
        pendingRestoreErrorProvider.overrideWithValue(restoreError),
      ],
      child: const MathHeroesApp(),
    ),
  );
}

/// Creates the nine shared testing students once. Idempotent: existing
/// accounts (and their passwords/progress) are never modified. Disabled in
/// release builds unless explicitly enabled with `--dart-define`.
Future<void> _seedDevelopmentAccounts() async {
  if (!DevAccountSeeder.enabled) return;
  final database = AppDatabase();
  try {
    final report = await DevAccountSeeder.seed(database);
    if (report.createdCount > 0) {
      debugPrint(
        'Seeded ${report.createdCount} development student account(s).',
      );
    }
    if (report.mismatchedCount > 0) {
      debugPrint(
        '${report.mismatchedCount} development username(s) already exist '
        'with different data and were left untouched.',
      );
    }
  } catch (error) {
    // Never block app startup because a development convenience failed.
    debugPrint('Development account seeding skipped: $error');
  } finally {
    await database.close();
  }
}
