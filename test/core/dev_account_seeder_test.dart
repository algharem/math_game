import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/services/account_service.dart';
import 'package:math_heroes/core/services/dev_account_seeder.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/shared/models/auth_models.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';

void main() {
  // The persistence test deliberately opens the same file twice in sequence.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late AccountService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = AccountService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('development student accounts', () {
    test('creates exactly nine students with the required grade and type',
        () async {
      final report = await DevAccountSeeder.seed(db);

      expect(report.createdCount, 9);
      expect(report.alreadyPresentCount, 0);
      expect(report.mismatchedCount, 0);
      expect(report.allUsable, isTrue);

      final accounts = await service.getAccounts();
      final students = accounts.where((account) => account.isStudent).toList();
      expect(students, hasLength(9));

      for (final spec in DevAccountSeeder.accounts) {
        final account =
            students.singleWhere((row) => row.user.username == spec.username);
        expect(account.displayName, spec.name, reason: spec.username);
        expect(account.user.role, 'student', reason: spec.username);
        expect(account.user.isActive, isTrue, reason: spec.username);
        expect(account.isDevelopment, isTrue, reason: spec.username);
        expect(account.schoolGrade, spec.grade, reason: spec.username);
        expect(account.currentLevel, 1, reason: spec.username);
        expect(account.profile, isNotNull, reason: spec.username);
        expect(account.needsPassword, isFalse, reason: spec.username);
      }
    });

    test('every account logs in by username with the shared password',
        () async {
      await DevAccountSeeder.seed(db);

      for (final spec in DevAccountSeeder.accounts) {
        final result = await service.loginWithUsername(
          username: spec.username,
          password: DevAccountSeeder.defaultPassword,
        );
        expect(result.isSuccess, isTrue, reason: spec.username);
        expect(result.session?.isStudent, isTrue, reason: spec.username);
        expect(result.session?.isParent, isFalse, reason: spec.username);
        expect(
          result.session?.account.schoolGrade,
          spec.grade,
          reason: spec.username,
        );
        expect(
          result.session?.account.displayName,
          spec.name,
          reason: spec.username,
        );
        expect(
          result.session?.account.profileId,
          isNotNull,
          reason: '${spec.username} must load a student profile',
        );
      }
    });

    test('username login is case-insensitive and rejects bad credentials',
        () async {
      await DevAccountSeeder.seed(db);

      final upper = await service.loginWithUsername(
        username: '  STUDENT5 ',
        password: DevAccountSeeder.defaultPassword,
      );
      expect(upper.isSuccess, isTrue);
      expect(upper.session?.account.schoolGrade, 5);

      final wrong = await service.loginWithUsername(
        username: 'student5',
        password: '000000',
      );
      expect(wrong.isSuccess, isFalse);
      expect(wrong.failure, AuthFailure.wrongPassword);

      final unknown = await service.loginWithUsername(
        username: 'student99',
        password: DevAccountSeeder.defaultPassword,
      );
      expect(unknown.isSuccess, isFalse);
      expect(unknown.failure, AuthFailure.userNotFound);
    });

    test('running the seed twice creates no duplicates or password resets',
        () async {
      await DevAccountSeeder.seed(db);
      final before = {
        for (final account in (await service.getAccounts()).where(
          (row) => row.isStudent,
        ))
          account.user.username: account.user.passwordHash,
      };

      final second = await DevAccountSeeder.seed(db);
      expect(second.createdCount, 0);
      expect(second.alreadyPresentCount, 9);
      expect(second.mismatchedCount, 0);

      final after =
          (await service.getAccounts()).where((row) => row.isStudent).toList();
      expect(after, hasLength(9));
      for (final account in after) {
        expect(
          account.user.passwordHash,
          before[account.user.username],
          reason: 'password hash changed for ${account.user.username}',
        );
      }
    });

    test('existing mismatched username is reported and never overwritten',
        () async {
      final profile = await db.insertProfile(
        name: 'Real Student',
        avatarIndex: 0,
        schoolGrade: 9,
      );
      final existing = await db.insertUser(
        profileId: profile.id,
        fullName: 'Real Student',
        username: 'student1',
        role: 'student',
        accountType: 'standard',
      );
      await service.resetStudentPassword(
        userId: existing.id,
        newPassword: 'custom99',
      );

      final report = await DevAccountSeeder.seed(db);
      expect(report.createdCount, 8);
      expect(report.mismatchedCount, 1);
      final mismatch = report.results.singleWhere(
        (result) => result.spec.username == 'student1',
      );
      expect(mismatch.status, DevAccountSeedStatus.mismatched);
      expect(mismatch.message, contains('grade=9'));

      final reloaded = await db.getUser(existing.id);
      expect(reloaded?.profileId, profile.id);
      expect(reloaded?.role, 'student');
      expect(reloaded?.accountType, 'standard');
      expect((await db.getProfile(profile.id))?.schoolGrade, 9);

      // The original password still works; the shared default does not.
      expect(
        (await service.login(userId: existing.id, password: 'custom99'))
            .isSuccess,
        isTrue,
      );
      expect(
        (await service.loginWithUsername(
          username: 'student1',
          password: DevAccountSeeder.defaultPassword,
        ))
            .failure,
        AuthFailure.wrongPassword,
      );
    });

    test('each seeded grade resolves to its own curriculum and questions',
        () async {
      await DevAccountSeeder.seed(db);
      final accounts = await service.getAccounts();

      for (final spec in DevAccountSeeder.accounts) {
        final account = accounts.singleWhere(
          (row) => row.user.username == spec.username,
        );
        final grade = account.schoolGrade;
        expect(grade, spec.grade);

        final topics = [
          ...await db.getCurriculumTopics(grade: grade, part: 1),
          ...await db.getCurriculumTopics(grade: grade, part: 2),
        ];
        expect(topics, isNotEmpty, reason: 'grade $grade has no topics');
        expect(
          topics.every((topic) => topic.grade == grade),
          isTrue,
          reason: 'grade $grade loaded another grade\'s topics',
        );

        final ready = topics.where((topic) => topic.generationReady).toList();
        expect(ready, isNotEmpty, reason: 'grade $grade has no ready topic');

        final questions = QuizBuilderService.generate(
          ExamConfig(
            section: MathSection.mixed,
            title: 'اختبار الصف $grade',
            questionCount: 3,
            schoolGrade: grade,
            topicIds: [ready.first.id],
            topicDifficultyLevel: 'mixed',
          ),
        );
        expect(questions, hasLength(3), reason: 'grade $grade');
        expect(
          questions.every((question) => question.topicId == ready.first.id),
          isTrue,
          reason: 'grade $grade pulled a question from another topic',
        );
        expect(
          questions.every(
            (question) =>
                question.displayPrompt.trim().isNotEmpty &&
                question.explanation.trim().isNotEmpty &&
                question.choices.isNotEmpty,
          ),
          isTrue,
          reason: 'grade $grade produced an incomplete question',
        );
      }
    });

    test('progress and exam history stay isolated per account', () async {
      await DevAccountSeeder.seed(db);
      final accounts = await service.getAccounts();
      final first = accounts.singleWhere(
        (account) => account.user.username == 'student1',
      );
      final second = accounts.singleWhere(
        (account) => account.user.username == 'student2',
      );

      await db.into(db.examRecords).insert(
            ExamRecordsCompanion.insert(
              sessionId: 'student1-only-session',
              profileId: first.profileId!,
              section: 'addition',
              title: 'اختبار الصف الأول',
              difficulty: 'easy',
              answerMode: 'multipleChoice',
              source: 'exam',
              total: 1,
              correct: 1,
              wrong: 0,
              unanswered: 0,
              starsEarned: 1,
              gemsEarned: 1,
              pointsEarned: 1,
              durationSeconds: 10,
              createdAt: DateTime.now(),
            ),
          );

      expect(await db.getExamHistory(first.profileId!), hasLength(1));
      expect(await db.getExamHistory(second.profileId!), isEmpty);
      final firstStats = await db.getProfileStats(first.profileId!);
      final secondStats = await db.getProfileStats(second.profileId!);
      expect(firstStats.examsCount, 1);
      expect(secondStats.examsCount, 0);
    });

    test('accounts survive a database reopen and still log in', () async {
      final directory = await Directory.systemTemp.createTemp('math-heroes-');
      final file = File('${directory.path}/accounts.sqlite');
      addTearDown(() async {
        if (await directory.exists()) await directory.delete(recursive: true);
      });

      var fileDb = AppDatabase.forTesting(NativeDatabase(file));
      await DevAccountSeeder.seed(fileDb);
      final firstSession = await AccountService(fileDb).loginWithUsername(
        username: 'student7',
        password: DevAccountSeeder.defaultPassword,
      );
      expect(firstSession.isSuccess, isTrue);
      await fileDb.close();

      fileDb = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(fileDb.close);
      final accounts = await AccountService(fileDb).getAccounts();
      final students = accounts.where((account) => account.isStudent).toList();
      expect(students, hasLength(9));
      final reopened = await AccountService(fileDb).loginWithUsername(
        username: 'student7',
        password: DevAccountSeeder.defaultPassword,
      );
      expect(reopened.isSuccess, isTrue);
      expect(reopened.session?.account.schoolGrade, 7);
    });

    test('development accounts are only enabled outside release by default',
        () {
      // Tests run in debug mode, so the convenience seed is active.
      expect(DevAccountSeeder.enabled, isTrue);
      expect(DevAccountSeeder.defaultPassword, '111111');
      expect(DevAccountSeeder.accounts, hasLength(9));
      expect(
        DevAccountSeeder.accounts.map((account) => account.grade).toList(),
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
      );
    });

    test('release builds never seed without an explicit double opt-in', () {
      bool enabled({
        required bool releaseMode,
        required bool seedRequested,
        required bool allowInRelease,
      }) =>
          DevAccountSeeder.isEnabledFor(
            releaseMode: releaseMode,
            seedRequested: seedRequested,
            allowInRelease: allowInRelease,
          );

      // Debug/profile: on unless explicitly disabled.
      expect(
        enabled(releaseMode: false, seedRequested: true, allowInRelease: false),
        isTrue,
      );
      expect(
        enabled(releaseMode: false, seedRequested: false, allowInRelease: true),
        isFalse,
      );

      // Release: off by default, even when the seed flag is left at its
      // default `true`. Both defines are required to opt in.
      expect(
        enabled(releaseMode: true, seedRequested: true, allowInRelease: false),
        isFalse,
        reason: 'release must not seed on the default seed flag alone',
      );
      expect(
        enabled(releaseMode: true, seedRequested: false, allowInRelease: true),
        isFalse,
      );
      expect(
        enabled(releaseMode: true, seedRequested: true, allowInRelease: true),
        isTrue,
      );
    });

    test('seeded users keep the standard account type for normal profiles',
        () async {
      final profile = await db.insertProfile(name: 'طالب عادي', avatarIndex: 0);
      final user = await db.insertUser(
        profileId: profile.id,
        fullName: profile.name,
        role: 'student',
      );
      expect(user.accountType, 'standard');
      expect(
        (await service.getStudentAccount(profile.id))?.isDevelopment,
        isFalse,
      );
    });
  });

  group('database compatibility', () {
    test('legacy users created without an account type default to standard',
        () async {
      // The v1 migration creates the users table with the current schema, so
      // the default must apply to accounts created by earlier code paths.
      final profile = await db.insertProfile(name: 'Legacy', avatarIndex: 0);
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: 'legacy-user',
              profileId: Value(profile.id),
              fullName: 'Legacy',
              role: 'student',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      final user = await db.getUser('legacy-user');
      expect(user?.accountType, 'standard');
    });
  });
}
