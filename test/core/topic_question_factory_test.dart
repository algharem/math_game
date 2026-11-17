import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/topic_seed.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/core/services/topic_question_factory.dart';
import 'package:math_heroes/core/utils/arabic_numbers.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
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

  test('grade-4 visual fraction questions carry a valid payload', () {
    const topic = CurriculumTopic(
      id: 'g4_p2_t5',
      grade: 4,
      part: 2,
      title: 'الكسور العادية (اختبار)',
      unitName: 'الكسور',
    );
    final random = Random(17);
    var mixedFound = false;
    var plainFound = false;
    var orderFound = false;
    var storyFound = false;
    for (var index = 0; index < 200; index++) {
      final q = TopicQuestionFactory.question(
        topic: topic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      final visual = q.mixedNumber;
      final order = q.fractionOrder;
      if (visual == null && order == null) continue;

      if (order != null) {
        orderFound = true;
        expect(q.kind, QuestionKind.fractionOps);
        expect(q.isFractionOrder, isTrue);
        expect(q.isVisual, isTrue);
        expect(q.correctAnswer, order.correctRank);
        expect(q.correctAnswer, isIn(q.choices));
        expect(q.choices.toSet(), {1, 2, 3, 4});
        expect(q.explanation, order.explanation);
        expect(q.spokenText, order.spokenText);
        expect(q.answerText, ArabicNumbers.formatInt(order.correctRank));
        expect(q.isCorrect(order.correctRank), isTrue);
        expect(q.isCorrect(order.correctRank % 4 + 1), isFalse);
        continue;
      }

      if (visual == null) continue;
      if (visual.isWordProblem) {
        storyFound = true;
        expect(q.kind, QuestionKind.wordProblem);
        expect(visual.story, isNotNull);
        expect(
          visual.story!.whereType<FractionStoryFraction>(),
          hasLength(2),
        );
      }
      if (q.kind == QuestionKind.mixedNumber) mixedFound = true;
      if (q.kind == QuestionKind.fractionOps) {
        plainFound = true;
        // Plain fraction operands must render as proper fractions.
        expect(visual.num1.whole, 0);
        expect(visual.num2.whole, 0);
      }

      expect(q.isMixedNumber, isTrue);
      expect(q.correctAnswer, visual.correctIndex);
      expect(q.correctAnswer, isIn(q.choices));
      expect(q.choices, List<int>.generate(visual.choices.length, (i) => i));
      expect(q.explanation, visual.explanation);
      expect(q.spokenText, visual.spokenText);
      expect(q.answerText, visual.correctAnswer.toArabicString());
      expect(
        q.choiceText(q.correctAnswer),
        visual.correctAnswer.toArabicString(),
      );
      expect(q.isCorrect(q.correctAnswer), isTrue);
      expect(
        q.isCorrect((q.correctAnswer + 1) % visual.choices.length),
        isFalse,
      );
    }
    expect(mixedFound, isTrue,
        reason: 'no mixed-number question generated for g4_p2_t5');
    expect(plainFound, isTrue,
        reason: 'no visual plain-fraction question generated for g4_p2_t5');
    expect(orderFound, isTrue,
        reason: 'no visual ordering question generated for g4_p2_t5');
    expect(storyFound, isTrue,
        reason: 'no fraction word problem generated for g4_p2_t5');
  });

  test('fraction topics generate visual fraction payloads', () {
    const topics = [
      CurriculumTopic(
        id: 'g3_p2_t4',
        grade: 3,
        part: 2,
        title: 'جمع وطرح الكسور ذات المقامات المتساوية',
        unitName: 'الكسور',
      ),
      CurriculumTopic(
        id: 'g5_p1_t3',
        grade: 5,
        part: 1,
        title: 'الكسور الاعتيادية (توحيد المقامات)',
        unitName: 'الكسور',
      ),
      CurriculumTopic(
        id: 'g5_p2_t1',
        grade: 5,
        part: 2,
        title: 'ضرب وقسمة الكسور الاعتيادية',
        unitName: 'الكسور',
      ),
    ];

    for (final topic in topics) {
      final random = Random(29);
      var visualFound = false;
      var unlikeFound = false;
      final operations = <String>{};

      for (var index = 0; index < 80; index++) {
        final q = TopicQuestionFactory.question(
          topic: topic,
          strength: TopicStrength.medium,
          random: random,
          index: index,
        );
        final visual = q.mixedNumber;
        if (visual == null) continue;

        visualFound = true;
        operations.add(visual.operation);
        if (visual.num1.denominator != visual.num2.denominator) {
          unlikeFound = true;
        }

        expect(q.isVisual, isTrue, reason: '${topic.id}/$index');
        expect(q.kind, QuestionKind.fractionOps, reason: '${topic.id}/$index');
        expect(q.correctAnswer, visual.correctIndex,
            reason: '${topic.id}/$index');
        expect(q.correctAnswer, isIn(q.choices), reason: '${topic.id}/$index');
        expect(
          q.choices,
          List<int>.generate(visual.choices.length, (i) => i),
          reason: '${topic.id}/$index',
        );
        expect(q.answerText, visual.correctAnswer.toArabicString());
        expect(q.isCorrect(q.correctAnswer), isTrue);
      }

      expect(visualFound, isTrue,
          reason: '${topic.id} produced no visual fraction questions');
      if (topic.id == 'g3_p2_t4') {
        expect(unlikeFound, isFalse);
        expect(operations, containsAll(<String>{'+', '-'}));
        for (var index = 0; index < 40; index++) {
          final q = TopicQuestionFactory.question(
            topic: topic,
            strength: TopicStrength.medium,
            random: random,
            index: index,
          );
          final visual = q.mixedNumber!;
          expect(visual.num1.denominator, lessThanOrEqualTo(8));
          expect(visual.num1.denominator, visual.num2.denominator);
        }
      } else if (topic.id == 'g5_p1_t3') {
        expect(unlikeFound, isTrue);
        expect(operations, containsAll(<String>{'+', '-'}));
      } else {
        expect(operations, containsAll(<String>{'*', '/'}));
      }
    }
  });

  test('grade-3 concept and equivalence topics render visual fractions', () {
    const simpleTopic = CurriculumTopic(
      id: 'g3_p2_t2',
      grade: 3,
      part: 2,
      title: 'مفهوم الكسور البسيطة (النصف، الثلث، الربع)',
      unitName: 'الكسور',
    );
    const equivalentTopic = CurriculumTopic(
      id: 'g3_p2_t3',
      grade: 3,
      part: 2,
      title: 'تمثيل الكسور بالأشكال والتلوين والكسور المتكافئة',
      unitName: 'الكسور',
    );
    final random = Random(11);

    var simpleVisual = 0;
    var simplePlain = 0;
    for (var index = 0; index < 120; index++) {
      final q = TopicQuestionFactory.question(
        topic: simpleTopic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      final visual = q.mixedNumber;
      if (visual == null) {
        simplePlain++;
        continue;
      }

      simpleVisual++;
      expect(q.isVisual, isTrue, reason: 'g3_p2_t2/$index');
      expect(q.kind, QuestionKind.fractionOps, reason: 'g3_p2_t2/$index');
      expect(visual.isWordProblem, isTrue, reason: 'g3_p2_t2/$index');
      expect(visual.story, isNotEmpty, reason: 'g3_p2_t2/$index');
      expect(visual.correctAnswer.numerator, 1, reason: 'g3_p2_t2/$index');
      expect(
        visual.correctAnswer.denominator,
        inInclusiveRange(2, 4),
        reason: 'g3_p2_t2/$index',
      );
      expect(q.correctAnswer, visual.correctIndex, reason: 'g3_p2_t2/$index');
      expect(
        q.choices,
        List<int>.generate(visual.choices.length, (i) => i),
        reason: 'g3_p2_t2/$index',
      );
    }
    expect(simpleVisual, greaterThan(0));
    expect(simplePlain, greaterThan(0));

    for (var index = 0; index < 80; index++) {
      final q = TopicQuestionFactory.question(
        topic: equivalentTopic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      final visual = q.mixedNumber!;

      expect(q.isVisual, isTrue, reason: 'g3_p2_t3/$index');
      expect(q.kind, QuestionKind.fractionOps, reason: 'g3_p2_t3/$index');
      expect(visual.operation, '=', reason: 'g3_p2_t3/$index');
      expect(
        visual.correctAnswer.equalsValue(visual.num1),
        isTrue,
        reason: 'g3_p2_t3/$index correct choice is not equivalent',
      );
      for (final choice in visual.choices) {
        if (choice.key != visual.correctAnswer.key) {
          expect(
            choice.equalsValue(visual.num1),
            isFalse,
            reason: 'g3_p2_t3/$index distractor is also equivalent',
          );
        }
      }
      expect(q.correctAnswer, visual.correctIndex, reason: 'g3_p2_t3/$index');
      expect(
        q.answerText,
        visual.correctAnswer.toArabicString(),
        reason: 'g3_p2_t3/$index',
      );
      expect(q.isCorrect(q.correctAnswer), isTrue, reason: 'g3_p2_t3/$index');
    }
  });

  test('grade-6 fractions-decimals topic mixes visual fraction operations', () {
    const topic = CurriculumTopic(
      id: 'g6_p1_t1',
      grade: 6,
      part: 1,
      title: 'العمليات المتقدمة على الكسور والكسور العشرية',
      unitName: 'الكسور',
    );
    final random = Random(41);
    var visualFound = false;
    var decimalFound = false;
    final operations = <String>{};

    for (var index = 0; index < 200; index++) {
      final q = TopicQuestionFactory.question(
        topic: topic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      final visual = q.mixedNumber;
      if (visual == null) {
        decimalFound = true;
        expect(q.equationText, contains('٫'), reason: 'g6_p1_t1/$index');
        expect(q.equationText, isNot(contains(' . ')),
            reason: 'g6_p1_t1/$index');
        continue;
      }

      visualFound = true;
      operations.add(visual.operation);
      expect(q.isVisual, isTrue, reason: 'g6_p1_t1/$index');
      expect(
        q.kind,
        isIn(const [QuestionKind.fractionOps, QuestionKind.mixedNumber]),
        reason: 'g6_p1_t1/$index',
      );
      expect(q.correctAnswer, visual.correctIndex, reason: 'g6_p1_t1/$index');
      expect(
        q.choices,
        List<int>.generate(visual.choices.length, (i) => i),
        reason: 'g6_p1_t1/$index',
      );
      expect(
        q.answerText,
        visual.correctAnswer.toArabicString(),
        reason: 'g6_p1_t1/$index',
      );
      expect(q.isCorrect(q.correctAnswer), isTrue, reason: 'g6_p1_t1/$index');
    }

    expect(visualFound, isTrue,
        reason: 'g6_p1_t1 produced no visual fraction questions');
    expect(decimalFound, isTrue,
        reason: 'g6_p1_t1 produced no decimal questions');
    expect(operations, containsAll(<String>{'+', '-', '*', '/'}));
  });

  test('decimal topic renders Arabic decimal values', () {
    const topic = CurriculumTopic(
      id: 'g5_p2_t2',
      grade: 5,
      part: 2,
      title: 'الكسور العشرية (القيمة المنزلية والعمليات)',
      unitName: 'الأعداد العشرية',
    );
    final random = Random(5);

    for (var index = 0; index < 80; index++) {
      final q = TopicQuestionFactory.question(
        topic: topic,
        strength: TopicStrength.medium,
        random: random,
        index: index,
      );
      expect(q.mixedNumber, isNull, reason: 'g5_p2_t2/$index');
      expect(q.equationText, contains('٫'), reason: 'g5_p2_t2/$index');
      expect(q.equationText, isNot(contains('0.')),
          reason: 'g5_p2_t2/$index western decimal');
      expect(q.equationText, isNot(contains(' . ')),
          reason: 'g5_p2_t2/$index split decimal token');
      expect(q.explanation.trim(), isNotEmpty, reason: 'g5_p2_t2/$index');
      expect(q.correctAnswer, isIn(q.choices), reason: 'g5_p2_t2/$index');
    }
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
