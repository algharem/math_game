import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';

void main() {
  test('upgrades a version 1 database without losing existing data', () async {
    final executor = NativeDatabase.memory(
      setup: (database) async {
        database.execute('''
          CREATE TABLE profiles (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            avatar_index INTEGER NOT NULL DEFAULT 0,
            stars INTEGER NOT NULL DEFAULT 0,
            gems INTEGER NOT NULL DEFAULT 0,
            points INTEGER NOT NULL DEFAULT 0,
            equipped_skin_id TEXT,
            equipped_background_id TEXT,
            created_at INTEGER NOT NULL
          )
        ''');
        database.execute('''
          CREATE TABLE exam_records (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL UNIQUE,
            profile_id TEXT NOT NULL,
            section TEXT NOT NULL,
            title TEXT NOT NULL,
            difficulty TEXT NOT NULL,
            answer_mode TEXT NOT NULL,
            source TEXT NOT NULL,
            total INTEGER NOT NULL,
            correct INTEGER NOT NULL,
            wrong INTEGER NOT NULL,
            unanswered INTEGER NOT NULL,
            stars_earned INTEGER NOT NULL,
            gems_earned INTEGER NOT NULL,
            points_earned INTEGER NOT NULL,
            duration_seconds INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            daily_date_key TEXT
          )
        ''');
        database.execute('''
          INSERT INTO profiles (
            id, name, avatar_index, stars, gems, points, created_at
          ) VALUES (
            'legacy-profile', 'طالب قديم', 1, 12, 3, 450, 1735689600000
          )
        ''');
        database.execute('''
          INSERT INTO exam_records (
            session_id, profile_id, section, title, difficulty, answer_mode,
            source, total, correct, wrong, unanswered, stars_earned,
            gems_earned, points_earned, duration_seconds, created_at
          ) VALUES (
            'legacy-session', 'legacy-profile', 'addition', 'تمرين قديم',
            'easy', 'multipleChoice', 'exam', 5, 4, 1, 0, 2, 3, 40, 30,
            1735689600000
          )
        ''');
        database.execute('PRAGMA user_version = 1');
      },
    );
    final db = AppDatabase.forTesting(executor);
    addTearDown(db.close);

    final profile = await db.getProfile('legacy-profile');
    expect(profile, isNotNull);
    expect(profile!.name, 'طالب قديم');
    expect(profile.points, 450);
    expect(profile.schoolGrade, 1);
    expect(profile.currentLevel, 1);
    expect(profile.totalCompletedLevels, 0);

    final exam = await db.getExamHistory('legacy-profile');
    expect(exam, hasLength(1));
    expect(exam.single.sessionId, 'legacy-session');
    expect(exam.single.levelId, isNull);
    expect(exam.single.startedAt, isNull);
    expect(exam.single.status, 'completed');

    expect(await db.getActiveLearningLevels(), hasLength(100));
    final users = await db.getAllUsers();
    expect(users.where((user) => user.role == 'parent'), hasLength(1));
    expect(
      users.where(
        (user) => user.role == 'student' && user.profileId == 'legacy-profile',
      ),
      hasLength(1),
    );
    // Schema v5 adds the account-type marker with a safe `standard` default.
    expect(
      users
          .where((user) => user.profileId == 'legacy-profile')
          .single
          .accountType,
      'standard',
    );
  });
}
