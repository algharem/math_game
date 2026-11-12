import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/network/parent_lan_controller.dart';
import '../core/services/account_service.dart';
import '../core/services/audio_service.dart';
import '../core/services/biometric_service.dart';
import '../core/services/settings_service.dart';
import '../core/services/tts_service.dart';
import '../shared/models/achievements.dart';
import '../shared/models/auth_models.dart';
import '../shared/models/level_overview.dart';
import '../shared/models/stats_models.dart';
import 'controllers/auth_controller.dart';
import 'controllers/profiles_controller.dart';
import 'controllers/settings_controller.dart';

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => throw UnimplementedError('SettingsService must be overridden'),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final accountServiceProvider = Provider<AccountService>(
  (ref) => AccountService(ref.watch(databaseProvider)),
);

final accountsProvider =
    AsyncNotifierProvider<AccountsController, List<AccountSummary>>(
  AccountsController.new,
);

final authProvider = NotifierProvider<AuthController, AuthSession?>(
  AuthController.new,
);

final parentSelectedProfileIdProvider = StateProvider<String?>((ref) => null);

final selectedParentStudentProvider = Provider<AccountSummary?>((ref) {
  final profileId = ref.watch(parentSelectedProfileIdProvider);
  if (profileId == null) return null;
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  for (final account in accounts) {
    if (account.isStudent && account.profileId == profileId) return account;
  }
  return null;
});

final studentLevelOverviewProvider = FutureProvider.autoDispose
    .family<StudentLevelOverview, String>((ref, profileId) async {
  final database = ref.watch(databaseProvider);
  final profile = await database.getProfile(profileId);
  if (profile == null) {
    throw StateError('Profile not found: $profileId');
  }
  final levels = await database.getActiveLearningLevels();
  final progress = await database.getStudentLevelProgressFor(profileId);
  return StudentLevelOverview(
    profile: profile,
    levels: levels,
    progressByLevelId: {for (final row in progress) row.levelId: row},
  );
});

final parentLanControllerProvider =
    ChangeNotifierProvider<ParentLanController>((ref) {
  final controller = ParentLanController(
    database: ref.watch(databaseProvider),
    settings: ref.watch(settingsServiceProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.dispose);
  return service;
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

final settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

final profilesProvider =
    AsyncNotifierProvider<ProfilesController, List<Profile>>(
  ProfilesController.new,
);

final activeProfileProvider =
    NotifierProvider<ActiveProfileController, Profile?>(
  ActiveProfileController.new,
);

final parentUnlockedProvider = StateProvider<bool>((ref) => false);

final profileStatsProvider =
    FutureProvider.autoDispose<ProfileStats>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return ProfileStats.empty;
  return ref.watch(databaseProvider).getProfileStats(profile.id);
});

final dailyStatusProvider =
    FutureProvider.autoDispose<DailyStatus>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return DailyStatus.empty;
  return ref.watch(databaseProvider).getDailyStatus(profile.id);
});

final tableMasteryProvider =
    FutureProvider.autoDispose<List<TableMastery>>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return const [];
  return ref.watch(databaseProvider).getTableMastery(profile.id);
});

final achievementsProvider =
    FutureProvider.autoDispose<List<AchievementState>>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return const [];
  return ref.watch(databaseProvider).getAchievementStates(profile.id);
});

final examHistoryProvider =
    FutureProvider.autoDispose<List<ExamRecord>>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return const [];
  return ref.watch(databaseProvider).getExamHistory(profile.id);
});

final factMasteryProvider =
    FutureProvider.autoDispose<List<FactMastery>>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return const [];
  return ref.watch(databaseProvider).getFactMastery(profile.id);
});

final unlockedCosmeticsProvider =
    FutureProvider.autoDispose<List<UnlockedCosmetic>>((ref) async {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null) return const [];
  return ref.watch(databaseProvider).getUnlockedCosmetics(profile.id);
});
