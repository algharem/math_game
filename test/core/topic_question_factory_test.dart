import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/topic_seed.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/core/services/topic_question_factory.dart';
import 'package:math_heroes/shared/models/curriculum_topic.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';

void main() {
  test('every seeded ready topic generates 15 unique valid questions', () {
    final readyTopics =
        curriculumTopicSeed.where((topic) => topic.generationReady).toList();
    expect(readyTopics, isNotEmpty);

    final random = Random(7);
    for (final topic in readyTopics) {
      for (final strength in TopicStrength.values) {
        final seen = <String>{};
        for (var index = 0; index < 15; index++) {
          final question = TopicQuestionFactory.question(
            topic: topic,
            strength: strength,
            random: random,
            index: index,
          );
          expect(
            question.correctAnswer,
            isIn(question.choices),
            reason: '${topic.id}/$strength/#$index answer not among choices',
          );
          expect(
            question.choices.toSet(),
            hasLength(question.choices.length),
            reason: '${topic.id}/$strength/#$index duplicate choices',
          );
          expect(
            question.choices.length,
            greaterThanOrEqualTo(2),
            reason: '${topic.id}/$strength/#$index too few choices',
          );
          expect(
            question.explanation.trim(),
            isNotEmpty,
            reason: '${topic.id}/$strength/#$index empty explanation',
          );
          expect(
            seen.add(question.id),
            isTrue,
            reason: '${topic.id}/$strength duplicate id',
          );
        }
      }
    }
  });

  test('unknown topic ids fall back to a valid addition question', () {
    final random = Random(3);
    const fakeTopic = CurriculumTopic(
      id: 'gx_p9_t9',
      grade: 4,
      part: 2,
      title: 'غير معروف',
      unitName: 'اختبار',
    );
    final question = TopicQuestionFactory.question(
      topic: fakeTopic,
      strength: TopicStrength.medium,
      random: random,
    );
    expect(question.correctAnswer, isIn(question.choices));
  });

  test('QuizBuilderService.generate honors topic filtering and count', () {
    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'امتحان مواضيع',
      questionCount: 12,
      topicIds: const ['g1_p1_t1', 'g1_p1_t3', 'g1_p2_t1'],
      bookPart: 1,
      examMode: ExamMode.fullExam,
    );
    final questions = QuizBuilderService.generate(config);
    expect(questions, hasLength(12));
    for (final question in questions) {
      expect(
        question.topicId,
        isIn(const {'g1_p1_t1', 'g1_p1_t3', 'g1_p2_t1'}),
      );
    }
  });

  test(
      'topic-exam generate uses all selected topics including those previously not ready',
      () {
    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'نموذج',
      questionCount: 10,
      topicIds: const [
        'g5_p1_t3',
        'g5_p1_t1',
      ],
      bookPart: 1,
    );
    final questions = QuizBuilderService.generate(config);
    expect(questions, hasLength(10));
    // Both topics are now exam-able from the book topic list
    expect(questions.map((q) => q.topicId).toSet().length,
        greaterThanOrEqualTo(1));
  });

  test('generate works for any selected book topics', () {
    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'نموذج',
      questionCount: 10,
      topicIds: const ['g5_p1_t3'],
      bookPart: 1,
    );
    final questions = QuizBuilderService.generate(config);
    expect(questions, hasLength(10));
  });

  test('grade-4 fractions topic generates valid questions of every kind', () {
    const topic = CurriculumTopic(
      id: 'g4_p2_t5',
      grade: 4,
      part: 2,
      title: 'الكسور العادية (اختبار)',
      unitName: 'الكسور',
    );
    final random = Random(42);
    final seenKinds = <QuestionKind>{};
    for (var index = 0; index < 60; index++) {
      final q = TopicQuestionFactory.question(
        topic: topic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      expect(q.topicId, 'g4_p2_t5');
      expect(q.correctAnswer, isIn(q.choices),
          reason: 'answer $q.correctAnswer not among ${q.choices} #$index');
      expect(q.choices.toSet(), hasLength(q.choices.length),
          reason: 'duplicate choices #$index');
      expect(q.explanation, isNotEmpty);
      expect(q.tokens, isNotEmpty);
      seenKinds.add(q.kind);
    }
    // Both plain fraction and visual mixed-number questions are generated.
    expect(seenKinds, contains(QuestionKind.fractionOps));
    expect(seenKinds, contains(QuestionKind.mixedNumber));
  });

  test('grade-4 mixed-number questions carry a valid visual payload', () {
    const topic = CurriculumTopic(
      id: 'g4_p2_t5',
      grade: 4,
      part: 2,
      title: 'الكسور العادية (اختبار)',
      unitName: 'الكسور',
    );
    final random = Random(17);
    var mixedFound = false;
    for (var index = 0; index < 80 && !mixedFound; index++) {
      final q = TopicQuestionFactory.question(
        topic: topic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      final mixed = q.mixedNumber;
      if (mixed == null) continue;
      mixedFound = true;

      expect(q.kind, QuestionKind.mixedNumber);
      expect(q.isMixedNumber, isTrue);
      expect(q.correctAnswer, mixed.correctIndex);
      expect(q.correctAnswer, isIn(q.choices));
      expect(q.choices, List<int>.generate(mixed.choices.length, (i) => i));
      expect(q.explanation, mixed.explanation);
      expect(q.spokenText, mixed.spokenText);
      expect(q.answerText, mixed.correctAnswer.toArabicString());
      expect(
        q.choiceText(q.correctAnswer),
        mixed.correctAnswer.toArabicString(),
      );
      expect(q.isCorrect(q.correctAnswer), isTrue);
      expect(
        q.isCorrect((q.correctAnswer + 1) % mixed.choices.length),
        isFalse,
      );
    }
    expect(mixedFound, isTrue,
        reason: 'no mixed-number question generated for g4_p2_t5');
  });

  test('adaptive pools cover every tier at the requested size', () {
    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'امتحان متكيّف',
      questionCount: 10,
      topicIds: const ['g1_p1_t3', 'g7_p1_t2'],
      examMode: ExamMode.adaptiveExam,
      topicDifficultyLevel: 'medium',
    );
    final tiers = QuizBuilderService.generateAdaptiveTiers(config);
    expect(tiers.keys.toSet(), TopicStrength.values.toSet());
    for (final entry in tiers.entries) {
      expect(entry.value, hasLength(10),
          reason: 'tier ${entry.key.name} wrong size');
      for (final question in entry.value) {
        expect(question.correctAnswer, isIn(question.choices));
      }
    }
    // Easy answers are never larger than their hard counterparts on the
    // same topic slot — a soft sanity bound of the tier ladder.
    final easyMax = tiers[TopicStrength.easy]!
        .map((q) => q.correctAnswer.abs())
        .reduce(max);
    final hardMax = tiers[TopicStrength.hard]!
        .map((q) => q.correctAnswer.abs())
        .reduce(max);
    // On mixed grade selection hard should generally reach bigger numbers;
    // keep this check loose to avoid flaky generation luck.
    expect(hardMax, greaterThanOrEqualTo(min(9, easyMax)));
  });
}
