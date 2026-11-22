import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../security/password_hasher.dart';

/// One shared development/testing student account.
class DevTestAccount {
  const DevTestAccount({
    required this.username,
    required this.name,
    required this.grade,
  });

  final String username;
  final String name;
  final int grade;
}

/// Outcome of inspecting or creating one seeded account.
enum DevAccountSeedStatus {
  /// The account did not exist and was created by this run.
  created,

  /// The account already existed and matched every requirement.
  alreadyPresent,

  /// The username already existed but role/grade/status/type did not match.
  /// Nothing was changed.
  mismatched,
}

class DevAccountSeedResult {
  const DevAccountSeedResult({
    required this.spec,
    required this.status,
    this.user,
    this.profile,
    this.message,
  });

  final DevTestAccount spec;
  final DevAccountSeedStatus status;
  final User? user;
  final Profile? profile;
  final String? message;

  bool get isUsable =>
      status == DevAccountSeedStatus.created ||
      status == DevAccountSeedStatus.alreadyPresent;
}

class DevAccountSeedReport {
  const DevAccountSeedReport(this.results);

  final List<DevAccountSeedResult> results;

  int get createdCount => results
      .where((result) => result.status == DevAccountSeedStatus.created)
      .length;

  int get alreadyPresentCount => results
      .where((result) => result.status == DevAccountSeedStatus.alreadyPresent)
      .length;

  int get mismatchedCount => results
      .where((result) => result.status == DevAccountSeedStatus.mismatched)
      .length;

  bool get allUsable => results.every((result) => result.isUsable);
}

/// Idempotent seed for the nine shared testing students (`student1`…`student9`).
///
/// Safety rules:
/// * never overwrites an existing user, profile, password or progress;
/// * never deletes anything;
/// * reports mismatched usernames instead of repairing them silently.
///
/// Enabled automatically in debug/profile builds. Production builds must opt
/// in explicitly with `--dart-define=SEED_DEV_ACCOUNTS=true
/// --dart-define=ALLOW_DEV_ACCOUNTS_IN_RELEASE=true`, and can always disable
/// the seed with `--dart-define=SEED_DEV_ACCOUNTS=false`.
class DevAccountSeeder {
  DevAccountSeeder._();

  /// Shared password for the nine controlled testing accounts.
  static const String defaultPassword = '111111';

  static const String developmentAccountType = 'development';

  static const List<DevTestAccount> accounts = [
    DevTestAccount(username: 'student1', name: 'Student 1', grade: 1),
    DevTestAccount(username: 'student2', name: 'Student 2', grade: 2),
    DevTestAccount(username: 'student3', name: 'Student 3', grade: 3),
    DevTestAccount(username: 'student4', name: 'Student 4', grade: 4),
    DevTestAccount(username: 'student5', name: 'Student 5', grade: 5),
    DevTestAccount(username: 'student6', name: 'Student 6', grade: 6),
    DevTestAccount(username: 'student7', name: 'Student 7', grade: 7),
    DevTestAccount(username: 'student8', name: 'Student 8', grade: 8),
    DevTestAccount(username: 'student9', name: 'Student 9', grade: 9),
  ];

  static const bool _seedRequested = bool.fromEnvironment(
    'SEED_DEV_ACCOUNTS',
    defaultValue: true,
  );

  static const bool _allowInRelease = bool.fromEnvironment(
    'ALLOW_DEV_ACCOUNTS_IN_RELEASE',
    defaultValue: false,
  );

  /// Whether [main] should run the seed. Debug/profile builds default on;
  /// release builds default off.
  static bool get enabled => isEnabledFor(
        releaseMode: kReleaseMode,
        seedRequested: _seedRequested,
        allowInRelease: _allowInRelease,
      );

  /// Pure form of [enabled] so every build-mode combination can be tested.
  ///
  /// A release build seeds only when both `SEED_DEV_ACCOUNTS` and
  /// `ALLOW_DEV_ACCOUNTS_IN_RELEASE` are explicitly true.
  @visibleForTesting
  static bool isEnabledFor({
    required bool releaseMode,
    required bool seedRequested,
    required bool allowInRelease,
  }) {
    if (!seedRequested) return false;
    return !releaseMode || allowInRelease;
  }

  /// Runs the seed once during app startup.
  ///
  /// Returns `null` when the seed is disabled, when the database cannot be
  /// opened, or when seeding throws. Startup must never fail because a
  /// development convenience did, and the connection is always closed.
  ///
  /// [openDatabase] and [isEnabled] exist so tests can exercise this contract
  /// without the real file-backed database or the real build flags.
  static Future<DevAccountSeedReport?> seedAtStartup({
    AppDatabase Function()? openDatabase,
    bool Function()? isEnabled,
  }) async {
    if (!(isEnabled?.call() ?? enabled)) return null;

    AppDatabase? database;
    try {
      database = (openDatabase ?? AppDatabase.new)();
      final report = await seed(database);
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
      return report;
    } catch (error) {
      debugPrint('Development account seeding skipped: $error');
      return null;
    } finally {
      await database?.close();
    }
  }

  /// Creates any missing testing accounts. Safe to call on every launch.
  static Future<DevAccountSeedReport> seed(AppDatabase database) async {
    final results = <DevAccountSeedResult>[];
    for (final spec in accounts) {
      results.add(await _seedOne(database, spec));
    }
    return DevAccountSeedReport(List.unmodifiable(results));
  }

  static Future<DevAccountSeedResult> _seedOne(
    AppDatabase database,
    DevTestAccount spec,
  ) async {
    final existing = await database.findUserByUsername(spec.username);
    if (existing != null) {
      final profile = existing.profileId == null
          ? null
          : await database.getProfile(existing.profileId!);
      final problems = <String>[];
      if (existing.role != 'student') problems.add('role=${existing.role}');
      if (!existing.isActive) problems.add('inactive');
      if (existing.accountType != developmentAccountType) {
        problems.add('accountType=${existing.accountType}');
      }
      if (profile == null) {
        problems.add('profileMissing');
      } else if (profile.schoolGrade != spec.grade) {
        problems.add('grade=${profile.schoolGrade}');
      }
      // Only presence is checked here. Re-verifying the shared password would
      // cost one PBKDF2 run (120k iterations) per account on every launch, so
      // a deliberately changed password is left as-is and reported as present.
      if (existing.passwordHash == null ||
          existing.passwordHash!.trim().isEmpty) {
        problems.add('passwordNotSet');
      }
      return DevAccountSeedResult(
        spec: spec,
        status: problems.isEmpty
            ? DevAccountSeedStatus.alreadyPresent
            : DevAccountSeedStatus.mismatched,
        user: existing,
        profile: profile,
        message: problems.isEmpty
            ? 'الحساب موجود ومطابق للمواصفات.'
            : 'الحساب موجود لكنه لا يطابق المواصفات (${problems.join(', ')}). '
                'لم يتم تعديله.',
      );
    }

    final created = await database.transaction(() async {
      final profile = await database.insertProfile(
        name: spec.name,
        avatarIndex: (spec.grade - 1) % 8,
        schoolGrade: spec.grade,
        currentLevel: 1,
      );
      final user = await database.insertUser(
        profileId: profile.id,
        fullName: spec.name,
        username: spec.username,
        passwordHash: PasswordHasher.hash(defaultPassword),
        role: 'student',
        avatarIndex: profile.avatarIndex,
        accountType: developmentAccountType,
      );
      return (profile: profile, user: user);
    });

    return DevAccountSeedResult(
      spec: spec,
      status: DevAccountSeedStatus.created,
      user: created.user,
      profile: created.profile,
      message: 'تم إنشاء الحساب التجريبي.',
    );
  }
}
