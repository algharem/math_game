import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/shared/models/exam_config.dart';
import 'package:math_heroes/shared/models/exam_models.dart';
import 'package:math_heroes/shared/models/learning_levels.dart';
import 'package:math_heroes/shared/models/question.dart';
import 'package:math_heroes/shared/models/reward_rules.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<LearningLevel> level(int number) async {
    final row = await db.getLearningLevelByNumber(number);
    expect(row, isNotNull, reason: 'المستوى $number غير موجود');
    return row!;
  }

  ExamConfig configFor(LearningLevel level) {
    return LevelCatalog.examConfigFor(
      levelId: level.id,
      levelNumber: level.levelNumber,
      title: level.title,
      section: LevelCatalog.sectionNameFor(level.levelNumber),
      difficulty: level.difficulty,
      questionCount: 1,
      durationSeconds: level.timeLimitSeconds,
    );
  }

  ExamResultData resultFor({
    required String sessionId,
    required Profile profile,
    required ExamConfig config,
    required bool correct,
    required DateTime finishedAt,
    Question? question,
  }) {
    final quizQuestion = question ?? QuizBuilderService.generate(config).first;
    final answer = ExamAnswer(
      question: quizQuestion,
      childAnswer: correct ? quizQuestion.correctAnswer : null,
      isCorrect: correct,
      timeSpentSeconds: 3,
    );
    final correctCount = correct ? 1 : 0;
    return ExamResultData(
      sessionId: sessionId,
      profileId: profile.id,
      config: config,
      total: 1,
      correct: correctCount,
      wrong: correct ? 0 : 1,
      unanswered: correct ? 0 : 1,
      stars: RewardRules.starsFor(correctCount, 1),
      gems: RewardRules.gemsFor(correctCount, 1),
      points: RewardRules.pointsFor(
        correct: correctCount,
        total: 1,
        isDaily: false,
      ),
      durationSeconds: 3,
      startedAt: finishedAt.subtract(const Duration(seconds: 3)),
      finishedAt: finishedAt,
      answers: [answer],
    );
  }

  test('seeds all one hundred levels and a parent account', () async {
    final levels = await db.getActiveLearningLevels();
    final users = await db.getAllUsers();

    expect(levels, hasLength(100));
    expect(levels.first.levelNumber, 1);
    expect(levels.last.levelNumber, 100);
    expect(
      users.where((user) => user.role == 'parent'),
      hasLength(1),
    );
  });

  test('marks attempts when a level is started', () async {
    final profile = await db.insertProfile(name: 'سارة', avatarIndex: 1);
    final firstLevel = await level(1);

    await db.markLevelStarted(profileId: profile.id, levelId: firstLevel.id);
    await db.markLevelStarted(profileId: profile.id, levelId: firstLevel.id);

    final progress = await db.getStudentLevelProgress(
      profile.id,
      firstLevel.id,
    );
    expect(progress, isNotNull);
    expect(progress!.attemptsCount, 2);
    expect(progress.status, 'inProgress');
    expect(progress.bestScore, 0);
  });

  test('saving a passing exam completes a level and advances current level',
      () async {
    final profile = await db.insertProfile(name: 'عمر', avatarIndex: 0);
    final firstLevel = await level(1);
    final config = configFor(firstLevel);

    await db.markLevelStarted(profileId: profile.id, levelId: firstLevel.id);
    final outcome = await db.saveExamResult(
      resultFor(
        sessionId: 'level-1-pass',
        profile: profile,
        config: config,
        correct: true,
        finishedAt: DateTime(2026, 3, 1, 10),
      ),
    );

    expect(outcome.alreadySaved, isFalse);
    final progress = await db.getStudentLevelProgress(
      profile.id,
      firstLevel.id,
    );
    expect(progress, isNotNull);
    expect(progress!.status, 'completed');
    expect(progress.bestScore, 100);
    expect(progress.completedAt, isNotNull);
    expect(progress.attemptsCount, 1);

    final updated = await db.getProfile(profile.id);
    expect(updated?.totalCompletedLevels, 1);
    expect(updated?.currentLevel, 2);
  });

  test('a lower retry never lowers the best score', () async {
    final profile = await db.insertProfile(name: 'ليان', avatarIndex: 2);
    final firstLevel = await level(1);
    final config = configFor(firstLevel);
    final firstQuestion = QuizBuilderService.generate(config).first;

    await db.saveExamResult(
      resultFor(
        sessionId: 'level-1-perfect',
        profile: profile,
        config: config,
        correct: true,
        finishedAt: DateTime(2026, 3, 2, 10),
        question: firstQuestion,
      ),
    );
    await db.saveExamResult(
      resultFor(
        sessionId: 'level-1-retry',
        profile: profile,
        config: config,
        correct: false,
        finishedAt: DateTime(2026, 3, 2, 11),
        question: firstQuestion,
      ),
    );

    final progress = await db.getStudentLevelProgress(
      profile.id,
      firstLevel.id,
    );
    expect(progress!.bestScore, 100);
    expect(progress.status, 'completed');
    final updated = await db.getProfile(profile.id);
    expect(updated?.currentLevel, 2);
    expect(updated?.totalCompletedLevels, 1);

    final history = await db.getExamHistoryForLevel(
      profileId: profile.id,
      levelId: firstLevel.id,
    );
    expect(history, hasLength(2));
    expect(history.every((exam) => exam.status == 'completed'), isTrue);
  });

  test('failed attempts do not complete a level', () async {
    final profile = await db.insertProfile(name: 'ريم', avatarIndex: 3);
    final firstLevel = await level(1);
    final config = configFor(firstLevel);

    await db.saveExamResult(
      resultFor(
        sessionId: 'level-1-fail',
        profile: profile,
        config: config,
        correct: false,
        finishedAt: DateTime(2026, 3, 3, 10),
      ),
    );

    final progress = await db.getStudentLevelProgress(
      profile.id,
      firstLevel.id,
    );
    expect(progress!.status, 'inProgress');
    expect(progress.completedAt, isNull);
    final updated = await db.getProfile(profile.id);
    expect(updated?.currentLevel, 1);
    expect(updated?.totalCompletedLevels, 0);
  });

  test('duplicate session ids are saved once', () async {
    final profile = await db.insertProfile(name: 'نور', avatarIndex: 0);
    final firstLevel = await level(1);
    final config = configFor(firstLevel);
    final result = resultFor(
      sessionId: 'level-1-duplicate',
      profile: profile,
      config: config,
      correct: true,
      finishedAt: DateTime(2026, 3, 4, 10),
    );

    final first = await db.saveExamResult(result);
    final second = await db.saveExamResult(result);

    expect(first.alreadySaved, isFalse);
    expect(second.alreadySaved, isTrue);
    final updated = await db.getProfile(profile.id);
    expect(updated?.totalCompletedLevels, 1);
    final history = await db.getExamHistoryForLevel(
      profileId: profile.id,
      levelId: firstLevel.id,
    );
    expect(history, hasLength(1));
  });
}
