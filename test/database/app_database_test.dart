import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';
import 'package:math_heroes/shared/models/exam_models.dart';
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

  ExamResultData buildResult({
    required String sessionId,
    required String profileId,
    required ExamConfig config,
    required DateTime finishedAt,
    bool answerCorrectly = true,
    Question? question,
  }) {
    final quizQuestion = question ?? QuizBuilderService.generate(config).first;
    final answer = ExamAnswer(
      question: quizQuestion,
      childAnswer: answerCorrectly ? quizQuestion.correctAnswer : null,
      isCorrect: answerCorrectly,
      timeSpentSeconds: 4,
    );
    final correct = answerCorrectly ? 1 : 0;
    return ExamResultData(
      sessionId: sessionId,
      profileId: profileId,
      config: config,
      total: 1,
      correct: correct,
      wrong: answerCorrectly ? 0 : 1,
      unanswered: answerCorrectly ? 0 : 1,
      stars: RewardRules.starsFor(correct, 1),
      gems: RewardRules.gemsFor(correct, 1),
      points: RewardRules.pointsFor(
        correct: correct,
        total: 1,
        isDaily: config.isDaily,
      ),
      durationSeconds: 4,
      startedAt: finishedAt.subtract(const Duration(seconds: 4)),
      finishedAt: finishedAt,
      answers: [answer],
    );
  }

  test('saves an exam once and updates stats', () async {
    final profile = await db.insertProfile(name: 'سارة', avatarIndex: 1);
    const config = ExamConfig(
      section: MathSection.multiplication,
      title: 'تمرين الضرب',
      questionCount: 1,
      multiplicationTable: 3,
      multiplicationFormat: MultiplicationFormat.result,
    );
    final result = buildResult(
      sessionId: 'session-1',
      profileId: profile.id,
      config: config,
      finishedAt: DateTime(2026, 1, 1, 10),
    );

    final first = await db.saveExamResult(result);
    expect(first.alreadySaved, isFalse);
    expect(first.points, result.points);

    final second = await db.saveExamResult(result);
    expect(second.alreadySaved, isTrue);
    expect(second.points, result.points);

    final stats = await db.getProfileStats(profile.id);
    expect(stats.examsCount, 1);
    expect(stats.totalQuestions, 1);
    expect(stats.correctAnswers, 1);
    expect(stats.accuracy, 100);

    final facts = await db.getFactMastery(profile.id);
    expect(facts, hasLength(1));
    expect(facts.single.attempts, 1);
    expect(facts.single.correct, 1);

    final updated = await db.getProfile(profile.id);
    expect(updated?.points, result.points);
    expect(updated?.stars, result.stars);
    expect(updated?.gems, result.gems);
  });

  test('keeps unlimited same-day attempts and reports today count', () async {
    final profile = await db.insertProfile(name: 'مريم', avatarIndex: 1);
    const config = ExamConfig(
      section: MathSection.multiplication,
      title: 'تمرين الضرب',
      questionCount: 1,
      multiplicationTable: 5,
      multiplicationFormat: MultiplicationFormat.result,
    );
    final now = DateTime.now();
    for (var index = 0; index < 3; index++) {
      await db.saveExamResult(
        buildResult(
          sessionId: 'same-day-$index',
          profileId: profile.id,
          config: config,
          finishedAt: now.subtract(Duration(minutes: 3 - index)),
        ),
      );
    }

    final history = await db.getExamHistory(profile.id);
    expect(history, hasLength(3));
    expect(history.every((exam) => exam.sessionId.isNotEmpty), isTrue);
    expect(history.every((exam) => exam.startedAt != null), isTrue);
    expect(history.every((exam) => exam.status == 'completed'), isTrue);

    final stats = await db.getProfileStats(profile.id);
    expect(stats.examsCount, 3);
    expect(stats.todayExamsCount, 3);
  });

  test('records a wrong answer and weak fact', () async {
    final profile = await db.insertProfile(name: 'عمر', avatarIndex: 0);
    const config = ExamConfig(
      section: MathSection.multiplication,
      title: 'تمرين الضرب',
      questionCount: 1,
      multiplicationTable: 4,
      multiplicationFormat: MultiplicationFormat.result,
    );
    final result = buildResult(
      sessionId: 'session-wrong',
      profileId: profile.id,
      config: config,
      finishedAt: DateTime(2026, 1, 2, 10),
      answerCorrectly: false,
    );

    await db.saveExamResult(result);
    final stats = await db.getProfileStats(profile.id);
    expect(stats.wrongAnswers, 1);
    expect(stats.accuracy, 0);

    final facts = await db.getFactMastery(profile.id);
    expect(facts.single.attempts, 1);
    expect(facts.single.correct, 0);
    expect(facts.single.isWeak, isFalse);

    final second = buildResult(
      sessionId: 'session-wrong-2',
      profileId: profile.id,
      config: config,
      finishedAt: DateTime(2026, 1, 3, 10),
      answerCorrectly: false,
      question: result.answers.first.question,
    );
    await db.saveExamResult(second);
    final updatedFacts = await db.getFactMastery(profile.id);
    expect(updatedFacts.single.attempts, 2);
    expect(updatedFacts.single.isWeak, isTrue);
  });

  test('does not apply the daily bonus twice for the same date', () async {
    final profile = await db.insertProfile(name: 'ليان', avatarIndex: 2);
    const config = ExamConfig(
      section: MathSection.daily,
      title: 'تحدي اليوم',
      questionCount: 1,
      source: ExamSource.daily,
      dailyDateKey: '2026-02-01',
    );
    final first = buildResult(
      sessionId: 'daily-1',
      profileId: profile.id,
      config: config,
      finishedAt: DateTime(2026, 2, 1, 10),
    );
    final second = buildResult(
      sessionId: 'daily-2',
      profileId: profile.id,
      config: config,
      finishedAt: DateTime(2026, 2, 1, 11),
    );

    final firstOutcome = await db.saveExamResult(first);
    final secondOutcome = await db.saveExamResult(second);

    expect(firstOutcome.dailyRewardApplied, isTrue);
    expect(secondOutcome.dailyRewardApplied, isFalse);
    expect(secondOutcome.points, first.points - RewardRules.dailyBonus);

    final dailyRows = await db.select(db.dailyChallenges).get();
    expect(dailyRows, hasLength(1));
    expect(dailyRows.single.dateKey, '2026-02-01');

    final history = await db.getExamHistory(profile.id);
    expect(history, hasLength(2));
    expect(history.every((exam) => exam.status == 'completed'), isTrue);
    expect(history.every((exam) => exam.startedAt != null), isTrue);
  });
}
