import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dart:convert';

import '../../shared/models/achievements.dart';
import '../../shared/models/cosmetics.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_models.dart';
import '../../shared/models/learning_levels.dart';
import '../../shared/models/level_system.dart';
import '../../shared/models/reward_rules.dart';
import '../../shared/models/stats_models.dart';
import '../curriculum/topic_seed.dart';
import '../security/password_hasher.dart';
import '../utils/date_keys.dart';
import '../utils/id_generator.dart';

part 'app_database.g.dart';

class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  IntColumn get avatarIndex => integer().withDefault(const Constant(0))();
  IntColumn get stars => integer().withDefault(const Constant(0))();
  IntColumn get gems => integer().withDefault(const Constant(0))();
  IntColumn get points => integer().withDefault(const Constant(0))();
  TextColumn get equippedSkinId => text().nullable()();
  TextColumn get equippedBackgroundId => text().nullable()();
  IntColumn get schoolGrade => integer().withDefault(const Constant(1))();
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  IntColumn get totalCompletedLevels =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()
      .nullable()
      .references(Profiles, #id, onDelete: KeyAction.setNull)();
  TextColumn get fullName => text().withLength(min: 1, max: 80)();
  TextColumn get username => text().nullable()();
  TextColumn get passwordHash => text().nullable()();
  TextColumn get role => text()();
  IntColumn get avatarIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {profileId},
      ];
}

class LearningLevels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levelNumber => integer().unique()();
  TextColumn get title => text()();
  TextColumn get difficulty => text()();
  TextColumn get topics => text()();
  TextColumn get objectives => text()();
  IntColumn get questionCount => integer()();
  IntColumn get passingScore => integer()();
  IntColumn get timeLimitSeconds => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class StudentLevelProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get levelId =>
      integer().references(LearningLevels, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().withDefault(const Constant('available'))();
  IntColumn get bestScore => integer().withDefault(const Constant(0))();
  IntColumn get attemptsCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {profileId, levelId},
      ];
}

class ExamRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().unique()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get levelId => integer()
      .nullable()
      .references(LearningLevels, #id, onDelete: KeyAction.setNull)();
  TextColumn get section => text()();
  TextColumn get title => text()();
  TextColumn get difficulty => text()();
  TextColumn get answerMode => text()();
  TextColumn get source => text()();
  IntColumn get total => integer()();
  IntColumn get correct => integer()();
  IntColumn get wrong => integer()();
  IntColumn get unanswered => integer()();
  IntColumn get starsEarned => integer()();
  IntColumn get gemsEarned => integer()();
  IntColumn get pointsEarned => integer()();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  TextColumn get dailyDateKey => text().nullable()();
}

class AnswerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get examId =>
      integer().references(ExamRecords, #id, onDelete: KeyAction.cascade)();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get section => text()();
  TextColumn get questionKind => text()();
  TextColumn get factKey => text().nullable()();
  TextColumn get questionText => text()();
  TextColumn get childAnswer => text().nullable()();
  TextColumn get correctAnswer => text()();
  BoolColumn get isCorrect => boolean()();
  TextColumn get explanation => text()();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();

  /// Curriculum topic id when the question came from a topic exam.
  TextColumn get topicId => text().nullable()();
}

class FactStats extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get section => text()();
  TextColumn get factKey => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSeen => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, section, factKey};
}

class AchievementRecords extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get achievementId => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, achievementId};
}

class DailyChallenges extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get dateKey => text()();
  IntColumn get correct => integer()();
  IntColumn get total => integer()();
  IntColumn get starsEarned => integer()();
  IntColumn get gemsEarned => integer()();
  IntColumn get examId => integer().nullable()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, dateKey};
}

class RewardClaims extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get dateKey => text()();
  IntColumn get dayIndex => integer()();
  IntColumn get stars => integer()();
  IntColumn get gems => integer()();
  DateTimeColumn get claimedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, dateKey};
}

class UnlockedCosmetics extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemId => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, itemId};
}

class CurriculumTopics extends Table {
  /// Topic id, e.g. `g4_p2_t2` (see lib/core/curriculum/topic_seed.dart).
  TextColumn get id => text()();
  IntColumn get grade => integer()();
  IntColumn get part => integer()();
  TextColumn get title => text()();
  TextColumn get unitName => text()();
  IntColumn get pageReference => integer().nullable()();
  BoolColumn get generationReady =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Persisted topic checklist per profile / grade / book part, so the
/// exam setup screen remembers what the family covered in school.
class ExamTopicSelections extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get grade => integer()();
  IntColumn get part => integer()();

  /// JSON-encoded list of selected topic ids.
  TextColumn get topicIds => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, grade, part};
}

enum PurchaseResult {
  purchased,
  alreadyOwned,
  insufficientGems,
  notFound,
  notOwned,
}

@DriftDatabase(
  tables: [
    Profiles,
    Users,
    LearningLevels,
    StudentLevelProgress,
    ExamRecords,
    AnswerRecords,
    CurriculumTopics,
    ExamTopicSelections,
    FactStats,
    AchievementRecords,
    DailyChallenges,
    RewardClaims,
    UnlockedCosmetics,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(profiles, profiles.schoolGrade);
            await m.addColumn(profiles, profiles.currentLevel);
            await m.addColumn(profiles, profiles.totalCompletedLevels);
            await m.createTable(learningLevels);
            await m.createTable(users);
            await m.createTable(studentLevelProgress);
            await m.addColumn(examRecords, examRecords.levelId);
          }
          if (from < 3) {
            await m.addColumn(examRecords, examRecords.startedAt);
            await m.addColumn(examRecords, examRecords.status);
          }
          if (from < 4) {
            // Curriculum platform v1: additive only — new tables plus a
            // nullable column; nothing existing is moved or dropped.
            await m.createTable(curriculumTopics);
            await m.createTable(examTopicSelections);
            if (await _tableExists('answer_records')) {
              await m.addColumn(answerRecords, answerRecords.topicId);
            } else {
              // Very old databases predate answer_records entirely
              // (v1 schema); create it fresh with the column included.
              await m.createTable(answerRecords);
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await _seedDefaultContent();
          await _seedCurriculumTopics();
        },
      );

  Future<void> _seedDefaultContent() async {
    final levelCount = await learningLevels.count().getSingle();
    if (levelCount == 0) {
      await batch((b) {
        for (final seed in LevelCatalog.seedLevels) {
          b.insert(
            learningLevels,
            LearningLevelsCompanion.insert(
              levelNumber: seed.number,
              title: seed.title,
              difficulty: seed.difficulty.name,
              topics: seed.topics.join('، '),
              objectives: seed.objectives,
              questionCount: seed.questionCount,
              passingScore: seed.passingScore,
              timeLimitSeconds: Value(seed.timeLimitSeconds),
              isActive: const Value(true),
            ),
          );
        }
      });
    }

    final parent = await (select(users)
          ..where((table) =>
              table.role.equals('parent') & table.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (parent == null) {
      final now = DateTime.now();
      await into(users).insert(
        UsersCompanion.insert(
          id: IdGenerator.next(),
          fullName: 'ولي الأمر',
          role: 'parent',
          passwordHash: Value(PasswordHasher.hash('123456')),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else if (parent.passwordHash == null || parent.passwordHash!.isEmpty) {
      // Ensure the default parent account is always accessible.
      await (update(users)..where((table) => table.id.equals(parent.id))).write(
        UsersCompanion(
          passwordHash: Value(PasswordHasher.hash('123456')),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    final profilesWithoutAccount = await (select(profiles).join([
      leftOuterJoin(users, users.profileId.equalsExp(profiles.id)),
    ])
          ..where(users.id.isNull()))
        .get();
    var studentOrdinal = await _nextStudentOrdinal();
    for (final row in profilesWithoutAccount) {
      final profile = row.readTable(profiles);
      final now = DateTime.now();
      final password = _studentPasswordForOrdinal(studentOrdinal);
      studentOrdinal++;
      await into(users).insert(
        UsersCompanion.insert(
          id: IdGenerator.next(),
          profileId: Value(profile.id),
          fullName: profile.name,
          role: 'student',
          avatarIndex: Value(profile.avatarIndex),
          passwordHash: Value(PasswordHasher.hash(password)),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  Future<int> _nextStudentOrdinal() async {
    final count = users.id.count();
    final query = selectOnly(users)
      ..addColumns([count])
      ..where(users.role.equals('student'));
    final row = await query.getSingle();
    return (row.read(count) ?? 0) + 1;
  }

  /// Default student password: 111111 for 1st student, 222222 for 2nd, etc.
  static String _studentPasswordForOrdinal(int ordinal) {
    final digit = ((ordinal - 1) % 9) + 1;
    return '$digit$digit$digit$digit$digit$digit';
  }

  /// Mirrors [curriculumTopicSeed] into the DB. Runs on every open and is
  /// idempotent (upsert by topic id), so seed updates ship safely.
  Future<void> _seedCurriculumTopics() async {
    for (final topic in curriculumTopicSeed) {
      await into(curriculumTopics).insertOnConflictUpdate(
        CurriculumTopicsCompanion.insert(
          id: topic.id,
          grade: topic.grade,
          part: topic.part,
          title: topic.title,
          unitName: topic.unitName,
          pageReference: Value(topic.pageReference),
          generationReady: Value(topic.generationReady),
        ),
      );
    }
  }

  Future<List<CurriculumTopic>> getCurriculumTopics({
    required int grade,
    required int part,
  }) {
    return (select(curriculumTopics)
          ..where(
            (table) => table.grade.equals(grade) & table.part.equals(part),
          )
          // Numeric suffix order: t1…t9 before t10…t14 (book order).
          ..orderBy([
            (table) => OrderingTerm.asc(table.id.length),
            (table) => OrderingTerm.asc(table.id),
          ]))
        .get();
  }

  Future<List<String>> getTopicSelection({
    required String profileId,
    required int grade,
    required int part,
  }) async {
    final row = await (select(examTopicSelections)
          ..where(
            (table) =>
                table.profileId.equals(profileId) &
                table.grade.equals(grade) &
                table.part.equals(part),
          ))
        .getSingleOrNull();
    if (row == null) return const [];
    if (row.topicIds.trim().isEmpty) return const [];
    final decoded = jsonDecode(row.topicIds);
    if (decoded is! List) return const [];
    return decoded.whereType<String>().toList(growable: false);
  }

  Future<void> saveTopicSelection({
    required String profileId,
    required int grade,
    required int part,
    required List<String> topicIds,
  }) async {
    await into(examTopicSelections).insertOnConflictUpdate(
      ExamTopicSelectionsCompanion.insert(
        profileId: profileId,
        grade: grade,
        part: part,
        topicIds: jsonEncode(topicIds),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<List<Profile>> getAllProfiles() {
    return (select(profiles)
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .get();
  }

  Future<List<User>> getActiveUsers() {
    return (select(users)
          ..where((table) => table.isActive.equals(true))
          ..orderBy([
            (table) => OrderingTerm.asc(table.role),
            (table) => OrderingTerm.asc(table.createdAt),
          ]))
        .get();
  }

  Future<List<User>> getAllUsers() {
    return (select(users)
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .get();
  }

  Future<User?> getUser(String userId) {
    return (select(users)..where((table) => table.id.equals(userId)))
        .getSingleOrNull();
  }

  Future<User?> getActiveParentUser() {
    return (select(users)
          ..where(
            (table) =>
                table.role.equals('parent') & table.isActive.equals(true),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<User?> findActiveParentByLogin(String login) async {
    final normalized = login.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final parents = await (select(users)
          ..where(
            (table) =>
                table.role.equals('parent') & table.isActive.equals(true),
          ))
        .get();
    for (final parent in parents) {
      final username = parent.username?.trim().toLowerCase();
      if (username == normalized ||
          parent.fullName.trim().toLowerCase() == normalized) {
        return parent;
      }
    }
    return null;
  }

  Future<User?> getUserForProfile(String profileId) {
    return (select(users)
          ..where((table) => table.profileId.equals(profileId))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<User> insertUser({
    String? profileId,
    required String fullName,
    String? username,
    String? passwordHash,
    required String role,
    int avatarIndex = 0,
  }) async {
    final now = DateTime.now();
    final user = User(
      id: IdGenerator.next(),
      profileId: profileId,
      fullName: fullName.trim(),
      username: username?.trim(),
      passwordHash: passwordHash,
      role: role,
      avatarIndex: avatarIndex,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    await into(users).insert(user);
    return user;
  }

  Future<void> updateUser(User user) async {
    await update(users).replace(user.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> setUserPasswordHash(String userId, String passwordHash) async {
    final user = await getUser(userId);
    if (user == null) return;
    await update(users).replace(
      user.copyWith(
        passwordHash: Value(passwordHash),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setUserActive(String userId, bool isActive) async {
    final user = await getUser(userId);
    if (user == null) return;
    await update(users).replace(
      user.copyWith(isActive: isActive, updatedAt: DateTime.now()),
    );
  }

  Future<List<LearningLevel>> getActiveLearningLevels() {
    return (select(learningLevels)
          ..where((table) => table.isActive.equals(true))
          ..orderBy([(table) => OrderingTerm.asc(table.levelNumber)]))
        .get();
  }

  Future<LearningLevel?> getLearningLevel(int levelId) {
    return (select(learningLevels)..where((table) => table.id.equals(levelId)))
        .getSingleOrNull();
  }

  Future<LearningLevel?> getLearningLevelByNumber(int levelNumber) {
    return (select(learningLevels)
          ..where((table) => table.levelNumber.equals(levelNumber)))
        .getSingleOrNull();
  }

  Future<StudentLevelProgressData?> getStudentLevelProgress(
    String profileId,
    int levelId,
  ) {
    return (select(studentLevelProgress)
          ..where(
            (table) =>
                table.profileId.equals(profileId) &
                table.levelId.equals(levelId),
          ))
        .getSingleOrNull();
  }

  Future<List<StudentLevelProgressData>> getStudentLevelProgressFor(
    String profileId,
  ) {
    return (select(studentLevelProgress)
          ..where((table) => table.profileId.equals(profileId))
          ..orderBy([(table) => OrderingTerm.asc(table.levelId)]))
        .get();
  }

  Future<int> getCompletedLevelCount(String profileId) async {
    final count = studentLevelProgress.levelId.count();
    final query = selectOnly(studentLevelProgress)
      ..addColumns([count])
      ..where(
        studentLevelProgress.profileId.equals(profileId) &
            studentLevelProgress.status.equals('completed'),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> markLevelStarted({
    required String profileId,
    required int levelId,
  }) async {
    final now = DateTime.now();
    final progress = await getStudentLevelProgress(profileId, levelId);
    if (progress == null) {
      await into(studentLevelProgress).insert(
        StudentLevelProgressCompanion.insert(
          profileId: profileId,
          levelId: levelId,
          status: const Value('inProgress'),
          attemptsCount: const Value(1),
          updatedAt: now,
        ),
      );
    } else {
      await update(studentLevelProgress).replace(
        progress.copyWith(
          status: progress.status == 'completed' ? 'completed' : 'inProgress',
          attemptsCount: progress.attemptsCount + 1,
          updatedAt: now,
        ),
      );
    }
  }

  Future<Profile?> getProfile(String profileId) {
    return (select(profiles)..where((table) => table.id.equals(profileId)))
        .getSingleOrNull();
  }

  Future<Profile> insertProfile({
    required String name,
    required int avatarIndex,
    int schoolGrade = 1,
    int currentLevel = 1,
  }) async {
    final profile = Profile(
      id: IdGenerator.next(),
      name: name.trim(),
      avatarIndex: avatarIndex,
      stars: 0,
      gems: 0,
      points: 0,
      schoolGrade: schoolGrade,
      currentLevel: currentLevel,
      totalCompletedLevels: 0,
      createdAt: DateTime.now(),
    );
    await into(profiles).insert(profile);
    return profile;
  }

  Future<void> updateProfile(Profile profile) async {
    await update(profiles).replace(profile);
  }

  Future<void> deleteProfile(String profileId) async {
    await (delete(profiles)..where((table) => table.id.equals(profileId))).go();
  }

  Future<void> resetProfileProgress(String profileId) async {
    await transaction(() async {
      await (delete(examRecords)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(answerRecords)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(factStats)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(achievementRecords)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(dailyChallenges)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(rewardClaims)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(unlockedCosmetics)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      await (delete(studentLevelProgress)
            ..where((table) => table.profileId.equals(profileId)))
          .go();
      final profile = await getProfile(profileId);
      if (profile != null) {
        await update(profiles).replace(
          profile.copyWith(
            stars: 0,
            gems: 0,
            points: 0,
            currentLevel: 1,
            totalCompletedLevels: 0,
            equippedSkinId: const Value(null),
            equippedBackgroundId: const Value(null),
          ),
        );
      }
    });
  }

  Future<List<ExamRecord>> getExamHistory(
    String profileId, {
    int? limit,
  }) {
    final query = select(examRecords)
      ..where((table) => table.profileId.equals(profileId))
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<List<ExamRecord>> getExamHistoryForLevel({
    required String profileId,
    required int levelId,
    int limit = 20,
  }) {
    return (select(examRecords)
          ..where(
            (table) =>
                table.profileId.equals(profileId) &
                table.levelId.equals(levelId),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<ExamRecord?> getExamById(int examId) {
    return (select(examRecords)..where((table) => table.id.equals(examId)))
        .getSingleOrNull();
  }

  Future<List<AnswerRecord>> getAnswersForExam(int examId) {
    return (select(answerRecords)
          ..where((table) => table.examId.equals(examId))
          ..orderBy([(table) => OrderingTerm.asc(table.id)]))
        .get();
  }

  Future<ProfileStats> getProfileStats(String profileId) async {
    final profile = await getProfile(profileId);
    if (profile == null) return ProfileStats.empty;
    final exams = await (select(examRecords)
          ..where((table) => table.profileId.equals(profileId)))
        .get();
    final answers = await (select(answerRecords)
          ..where((table) => table.profileId.equals(profileId)))
        .get();

    var totalQuestions = 0;
    var correct = 0;
    var wrong = 0;
    var unanswered = 0;
    var learningSeconds = 0;
    var perfectExams = 0;
    var bestAccuracy = 0.0;
    DateTime? lastExamAt;
    var todaySeconds = 0;
    var todayExams = 0;
    final today = DateKeys.today();

    for (final exam in exams) {
      totalQuestions += exam.total;
      correct += exam.correct;
      wrong += exam.wrong;
      unanswered += exam.unanswered;
      learningSeconds += exam.durationSeconds;
      if (exam.total > 0 && exam.correct == exam.total) perfectExams++;
      final accuracy = exam.total == 0 ? 0.0 : exam.correct / exam.total * 100;
      if (accuracy > bestAccuracy) bestAccuracy = accuracy;
      if (lastExamAt == null || exam.createdAt.isAfter(lastExamAt)) {
        lastExamAt = exam.createdAt;
      }
      if (DateKeys.fromDate(exam.createdAt) == today) {
        todaySeconds += exam.durationSeconds;
        todayExams++;
      }
    }

    final subjectTotals = <MathSection, List<int>>{};
    for (final answer in answers) {
      final section = _parseSection(answer.section);
      if (section == null) continue;
      final values = subjectTotals.putIfAbsent(section, () => [0, 0, 0]);
      values[0] += 1;
      if (answer.isCorrect) {
        values[1] += 1;
      } else if (answer.childAnswer != null) {
        values[2] += 1;
      }
    }
    final subjects = <MathSection, SubjectPerformance>{};
    for (final entry in subjectTotals.entries) {
      subjects[entry.key] = SubjectPerformance(
        section: entry.key,
        answered: entry.value[0],
        correct: entry.value[1],
        wrong: entry.value[2],
      );
    }

    return ProfileStats(
      examsCount: exams.length,
      totalQuestions: totalQuestions,
      correctAnswers: correct,
      wrongAnswers: wrong,
      unanswered: unanswered,
      totalStars: profile.stars,
      gems: profile.gems,
      points: profile.points,
      learningSeconds: learningSeconds,
      todayLearningSeconds: todaySeconds,
      todayExamsCount: todayExams,
      subjects: subjects,
      lastExamAt: lastExamAt,
      bestAccuracy: bestAccuracy,
      perfectExams: perfectExams,
    );
  }

  Future<List<FactMastery>> getFactMastery(
    String profileId, {
    MathSection? section,
  }) async {
    final query = select(factStats)
      ..where((table) => table.profileId.equals(profileId));
    if (section != null) {
      query.where((table) => table.section.equals(section.name));
    }
    final rows = await query.get();
    return rows
        .map(
          (row) => FactMastery(
            section: _parseSection(row.section) ?? MathSection.mixed,
            factKey: row.factKey,
            attempts: row.attempts,
            correct: row.correct,
            lastSeen: row.lastSeen,
          ),
        )
        .toList(growable: false);
  }

  Future<List<TableMastery>> getTableMastery(String profileId) async {
    final facts = await getFactMastery(
      profileId,
      section: MathSection.multiplication,
    );
    final totals = <int, List<int>>{};
    for (final fact in facts) {
      final parts = fact.factKey.split(':');
      if (parts.length != 3 || parts[0] != 'mul') continue;
      final table = int.tryParse(parts[1]);
      if (table == null) continue;
      final values = totals.putIfAbsent(table, () => [0, 0]);
      values[0] += fact.attempts;
      values[1] += fact.correct;
    }
    return List.generate(12, (index) {
      final table = index + 1;
      final values = totals[table] ?? const [0, 0];
      return TableMastery(
          table: table, attempts: values[0], correct: values[1]);
    });
  }

  Future<DailyStatus> getDailyStatus(String profileId) async {
    final today = DateKeys.today();
    final records = await (select(dailyChallenges)
          ..where((table) => table.profileId.equals(profileId)))
        .get();
    final completedDates = records.map((record) => record.dateKey).toSet();
    final todayCompleted = completedDates.contains(today);
    final streak = _calculateStreak(completedDates, today);
    final weekKeys = DateKeys.lastDays(7);
    final weekDays = weekKeys.map(completedDates.contains).toList();
    final claim = await (select(rewardClaims)
          ..where(
            (table) =>
                table.profileId.equals(profileId) & table.dateKey.equals(today),
          ))
        .getSingleOrNull();
    final rewardDay = todayCompleted
        ? SevenDayRewards.rewardDayForStreak(streak)
        : SevenDayRewards.rewardDayForStreak(streak + 1);
    return DailyStatus(
      completedToday: todayCompleted,
      streak: streak,
      weekDays: weekDays,
      rewardClaimedToday: claim != null,
      rewardDayIndex: rewardDay,
      canClaimReward: todayCompleted && claim == null,
    );
  }

  Future<ExamSaveOutcome> saveExamResult(ExamResultData result) async {
    return transaction(() async {
      final existing = await (select(examRecords)
            ..where((table) => table.sessionId.equals(result.sessionId)))
          .getSingleOrNull();
      if (existing != null) {
        return ExamSaveOutcome(
          stars: existing.starsEarned,
          gems: existing.gemsEarned,
          points: existing.pointsEarned,
          alreadySaved: true,
          dailyRewardApplied: false,
          newAchievements: const [],
        );
      }

      final profile = await getProfile(result.profileId);
      if (profile == null) {
        throw StateError('Profile not found: ${result.profileId}');
      }

      var awardedPoints = result.points;
      var dailyRewardApplied = false;
      final dateKey = result.dailyDateKey;
      if (result.isDaily && dateKey != null) {
        final existingDaily = await (select(dailyChallenges)
              ..where(
                (table) =>
                    table.profileId.equals(result.profileId) &
                    table.dateKey.equals(dateKey),
              ))
            .getSingleOrNull();
        if (existingDaily != null) {
          awardedPoints =
              (awardedPoints - RewardRules.dailyBonus).clamp(0, awardedPoints);
        } else {
          dailyRewardApplied = true;
        }
      }

      final examId = await into(examRecords).insert(
        ExamRecordsCompanion.insert(
          sessionId: result.sessionId,
          profileId: result.profileId,
          levelId: Value(result.levelId),
          section: result.section.name,
          title: result.title,
          difficulty: result.difficulty.name,
          answerMode: result.answerMode.name,
          source: result.source.name,
          total: result.total,
          correct: result.correct,
          wrong: result.wrong,
          unanswered: result.unanswered,
          starsEarned: result.stars,
          gemsEarned: result.gems,
          pointsEarned: awardedPoints,
          durationSeconds: result.durationSeconds,
          startedAt: Value(result.startedAt),
          createdAt: result.finishedAt,
          status: const Value('completed'),
          dailyDateKey: Value(dateKey),
        ),
      );

      for (final answer in result.answers) {
        await into(answerRecords).insert(
          AnswerRecordsCompanion.insert(
            examId: examId,
            profileId: result.profileId,
            section: answer.question.section.name,
            questionKind: answer.question.kind.name,
            factKey: Value(answer.question.factKey),
            questionText: answer.question.equationText,
            childAnswer: Value(
              answer.childAnswer == null
                  ? null
                  : answer.question.choiceText(answer.childAnswer),
            ),
            correctAnswer: answer.question.answerText,
            isCorrect: answer.isCorrect,
            explanation: answer.question.explanation,
            timeSpentSeconds: Value(answer.timeSpentSeconds),
            topicId: Value(answer.question.topicId),
          ),
        );
        await _recordFactStat(
          profileId: result.profileId,
          answer: answer,
          now: result.finishedAt,
        );
      }

      if (result.isDaily && dateKey != null && dailyRewardApplied) {
        await into(dailyChallenges).insert(
          DailyChallengesCompanion.insert(
            profileId: result.profileId,
            dateKey: dateKey,
            correct: result.correct,
            total: result.total,
            starsEarned: result.stars,
            gemsEarned: result.gems,
            examId: Value(examId),
            completedAt: result.finishedAt,
          ),
        );
      }

      final updatedProfile = profile.copyWith(
        stars: profile.stars + result.stars,
        gems: profile.gems + result.gems,
        points: profile.points + awardedPoints,
      );
      await update(profiles).replace(updatedProfile);

      if (result.levelId != null) {
        await _applyLevelProgress(result, updatedProfile);
      }

      final newAchievements = await _unlockAchievements(
        updatedProfile,
        result.finishedAt,
      );

      return ExamSaveOutcome(
        stars: result.stars,
        gems: result.gems,
        points: awardedPoints,
        alreadySaved: false,
        dailyRewardApplied: dailyRewardApplied,
        newAchievements: newAchievements,
      );
    });
  }

  Future<SevenDayReward?> claimSevenDayReward(
    String profileId,
    String dateKey,
  ) async {
    return transaction(() async {
      final daily = await (select(dailyChallenges)
            ..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.dateKey.equals(dateKey),
            ))
          .getSingleOrNull();
      if (daily == null) return null;
      final existing = await (select(rewardClaims)
            ..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.dateKey.equals(dateKey),
            ))
          .getSingleOrNull();
      if (existing != null) return null;
      final status = await getDailyStatus(profileId);
      final reward = SevenDayRewards.forDay(status.rewardDayIndex);
      final profile = await getProfile(profileId);
      if (profile == null) return null;
      await into(rewardClaims).insert(
        RewardClaimsCompanion.insert(
          profileId: profileId,
          dateKey: dateKey,
          dayIndex: reward.day,
          stars: reward.stars,
          gems: reward.gems,
          claimedAt: DateTime.now(),
        ),
      );
      await update(profiles).replace(
        profile.copyWith(
          stars: profile.stars + reward.stars,
          gems: profile.gems + reward.gems,
        ),
      );
      return reward;
    });
  }

  Future<List<UnlockedCosmetic>> getUnlockedCosmetics(String profileId) {
    return (select(unlockedCosmetics)
          ..where((table) => table.profileId.equals(profileId)))
        .get();
  }

  Future<PurchaseResult> purchaseCosmetic(
    String profileId,
    String itemId,
  ) async {
    final item = CosmeticCatalog.byId(itemId);
    if (item == null) return PurchaseResult.notFound;
    return transaction(() async {
      final existing = await (select(unlockedCosmetics)
            ..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.itemId.equals(itemId),
            ))
          .getSingleOrNull();
      if (existing != null) return PurchaseResult.alreadyOwned;
      final profile = await getProfile(profileId);
      if (profile == null) return PurchaseResult.notFound;
      if (profile.gems < item.price) return PurchaseResult.insufficientGems;
      await into(unlockedCosmetics).insert(
        UnlockedCosmeticsCompanion.insert(
          profileId: profileId,
          itemId: itemId,
          unlockedAt: DateTime.now(),
        ),
      );
      await update(profiles).replace(
        profile.copyWith(gems: profile.gems - item.price),
      );
      return PurchaseResult.purchased;
    });
  }

  Future<PurchaseResult> equipCosmetic(
    String profileId,
    String itemId,
  ) async {
    final item = CosmeticCatalog.byId(itemId);
    if (item == null) return PurchaseResult.notFound;
    final owned = await (select(unlockedCosmetics)
          ..where(
            (table) =>
                table.profileId.equals(profileId) & table.itemId.equals(itemId),
          ))
        .getSingleOrNull();
    if (owned == null) return PurchaseResult.notOwned;
    final profile = await getProfile(profileId);
    if (profile == null) return PurchaseResult.notFound;
    await update(profiles).replace(
      item.type == CosmeticType.skin
          ? profile.copyWith(equippedSkinId: Value(itemId))
          : profile.copyWith(equippedBackgroundId: Value(itemId)),
    );
    return PurchaseResult.purchased;
  }

  Future<void> unequipCosmetic(
    String profileId,
    CosmeticType type,
  ) async {
    final profile = await getProfile(profileId);
    if (profile == null) return;
    await update(profiles).replace(
      type == CosmeticType.skin
          ? profile.copyWith(equippedSkinId: const Value(null))
          : profile.copyWith(equippedBackgroundId: const Value(null)),
    );
  }

  Future<Map<String, DateTime>> getUnlockedAchievements(
    String profileId,
  ) async {
    final rows = await (select(achievementRecords)
          ..where((table) => table.profileId.equals(profileId)))
        .get();
    return {for (final row in rows) row.achievementId: row.unlockedAt};
  }

  Future<List<AchievementState>> getAchievementStates(
    String profileId,
  ) async {
    final context = await buildAchievementContext(profileId);
    final unlocked = await getUnlockedAchievements(profileId);
    return AchievementEngine.states(context, unlocked);
  }

  Future<AchievementContext> buildAchievementContext(String profileId) async {
    final profile = await getProfile(profileId);
    final stats = await getProfileStats(profileId);
    final tables = await getTableMastery(profileId);
    final daily = await getDailyStatus(profileId);
    final division = stats.performanceFor(MathSection.division);
    return AchievementContext(
      examsCount: stats.examsCount,
      totalCorrect: stats.correctAnswers,
      perfectExams: stats.perfectExams,
      divisionCorrect: division?.correct ?? 0,
      dailyStreak: daily.streak,
      level: LevelSystem.fromPoints(profile?.points ?? 0).level,
      totalStars: profile?.stars ?? 0,
      gems: profile?.gems ?? 0,
      tableMastery: {for (final table in tables) table.table: table},
    );
  }

  Future<List<String>> _unlockAchievements(
    Profile profile,
    DateTime now,
  ) async {
    final stats = await getProfileStats(profile.id);
    final tables = await getTableMastery(profile.id);
    final daily = await getDailyStatus(profile.id);
    final division = stats.performanceFor(MathSection.division);
    final context = AchievementContext(
      examsCount: stats.examsCount,
      totalCorrect: stats.correctAnswers,
      perfectExams: stats.perfectExams,
      divisionCorrect: division?.correct ?? 0,
      dailyStreak: daily.streak,
      level: LevelSystem.fromPoints(profile.points).level,
      totalStars: profile.stars,
      gems: profile.gems,
      tableMastery: {for (final table in tables) table.table: table},
    );
    final unlocked = await getUnlockedAchievements(profile.id);
    final newIds =
        AchievementEngine.newlyUnlocked(context, unlocked.keys.toSet());
    for (final id in newIds) {
      await into(achievementRecords).insert(
        AchievementRecordsCompanion.insert(
          profileId: profile.id,
          achievementId: id,
          unlockedAt: now,
        ),
      );
    }
    return newIds;
  }

  Future<void> _applyLevelProgress(
    ExamResultData result,
    Profile profile,
  ) async {
    final level = await getLearningLevel(result.levelId!);
    if (level == null) return;
    final score = result.total == 0
        ? 0
        : ((result.correct / result.total) * 100).round().clamp(0, 100);
    final passed = score >= level.passingScore;
    final progress = await getStudentLevelProgress(result.profileId, level.id);
    final now = result.finishedAt;

    if (progress == null) {
      await into(studentLevelProgress).insert(
        StudentLevelProgressCompanion.insert(
          profileId: result.profileId,
          levelId: level.id,
          status: Value(passed ? 'completed' : 'inProgress'),
          bestScore: Value(score),
          attemptsCount: const Value(1),
          completedAt: Value(passed ? now : null),
          updatedAt: now,
        ),
      );
    } else {
      final completed = progress.status == 'completed' || passed;
      await update(studentLevelProgress).replace(
        progress.copyWith(
          status: completed ? 'completed' : 'inProgress',
          bestScore: score > progress.bestScore ? score : progress.bestScore,
          completedAt: Value(
            progress.completedAt ?? (passed ? now : null),
          ),
          updatedAt: now,
        ),
      );
    }

    final completedCount = await getCompletedLevelCount(result.profileId);
    final activeLevels = await getActiveLearningLevels();
    final progressRows = await getStudentLevelProgressFor(result.profileId);
    final completedLevelIds = progressRows
        .where((row) => row.status == 'completed')
        .map((row) => row.levelId)
        .toSet();
    final nextLevel = activeLevels
        .where((candidate) => !completedLevelIds.contains(candidate.id))
        .firstOrNull;
    final currentLevel = nextLevel?.levelNumber ??
        (activeLevels.isEmpty
            ? profile.currentLevel
            : activeLevels.last.levelNumber);
    await update(profiles).replace(
      profile.copyWith(
        currentLevel: currentLevel,
        totalCompletedLevels: completedCount,
      ),
    );
  }

  Future<void> _recordFactStat({
    required String profileId,
    required ExamAnswer answer,
    required DateTime now,
  }) async {
    final factKey = answer.question.factKey;
    if (factKey == null) return;
    final section = answer.question.section;
    final existing = await (select(factStats)
          ..where(
            (table) =>
                table.profileId.equals(profileId) &
                table.section.equals(section.name) &
                table.factKey.equals(factKey),
          ))
        .getSingleOrNull();
    if (existing == null) {
      await into(factStats).insert(
        FactStatsCompanion.insert(
          profileId: profileId,
          section: section.name,
          factKey: factKey,
          attempts: const Value(1),
          correct: Value(answer.isCorrect ? 1 : 0),
          lastSeen: now,
        ),
      );
    } else {
      await update(factStats).replace(
        existing.copyWith(
          attempts: existing.attempts + 1,
          correct: existing.correct + (answer.isCorrect ? 1 : 0),
          lastSeen: now,
        ),
      );
    }
  }

  Future<bool> _tableExists(String tableName) async {
    final rows = await customSelect(
      "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
      variables: [Variable.withString(tableName)],
    ).get();
    return rows.isNotEmpty;
  }

  int _calculateStreak(Set<String> completedDates, String today) {
    if (completedDates.isEmpty) return 0;
    var cursor = DateKeys.parse(today);
    var streak = 0;
    if (!completedDates.contains(today)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (completedDates.contains(DateKeys.fromDate(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  MathSection? _parseSection(String value) {
    for (final section in MathSection.values) {
      if (section.name == value) return section;
    }
    return null;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'math_heroes.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
