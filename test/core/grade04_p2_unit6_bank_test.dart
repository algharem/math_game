import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/grade04_p2_unit6_bank.dart';
import 'package:math_heroes/core/curriculum/topic_seed.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/core/services/topic_question_factory.dart';
import 'package:math_heroes/shared/models/curriculum_topic.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';

Matcher inRange(int min, int max) =>
    allOf(greaterThanOrEqualTo(min), lessThanOrEqualTo(max));

void main() {
  group('Unit 6 question bank structure', () {
    test('all nine lessons exist in textbook order with 12 questions each', () {
      expect(Unit6QuestionBank.lessonIds, hasLength(9));
      expect(
        Unit6QuestionBank.lessonIds.first,
        'g4_p2_t6',
      );
      expect(
        Unit6QuestionBank.lessonIds.map(
          (id) => Unit6QuestionBank.lessonNames[id],
        ),
        [
          'الأجزاء من عشرة',
          'الأجزاء من مائة',
          'الأعداد الكسرية في صورة كسور عشرية',
          'مقارنة وترتيب الكسور العشرية',
          'جمع الكسور العشرية',
          'طرح الكسور العشرية',
          'تدريبات ومسائل على الجمع والطرح',
          'مسائل تطبيقية',
          'اختبار الوحدة',
        ],
      );

      expect(Unit6QuestionBank.questions, hasLength(108));
      expect(
        Unit6QuestionBank.questions.map((question) => question.id).toSet(),
        hasLength(108),
        reason: 'every authored question must have a unique id',
      );
      for (final lessonId in Unit6QuestionBank.lessonIds) {
        final lesson = Unit6QuestionBank.forLesson(lessonId);
        expect(lesson, hasLength(12), reason: lessonId);
        expect(
          lesson.every(
            (question) =>
                question.lessonName == Unit6QuestionBank.lessonNames[lessonId],
          ),
          isTrue,
          reason: 'lesson label mismatch in $lessonId',
        );
      }
      expect(
        Unit6QuestionBank.forLesson('g4_p2_t99'),
        isEmpty,
        reason: 'unknown lessons have no authored questions',
      );
    });

    test('every question carries complete textbook metadata', () {
      for (final question in Unit6QuestionBank.questions) {
        expect(question.id, startsWith('g4p2u6_'));
        expect(Unit6QuestionBank.lessonIds, contains(question.topicId));
        expect(question.lessonName, isNotEmpty);
        expect(question.skill, isNotEmpty);
        expect(question.questionTypeLabel, isNotEmpty);
        expect(question.prompt, isNotEmpty);
        expect(question.choices.length, greaterThanOrEqualTo(2));
        expect(question.correctIndex, inRange(0, question.choices.length - 1));
        expect(
          question.correctAnswer,
          question.choices[question.correctIndex],
          reason: 'correct answer must be a real choice for ${question.id}',
        );
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'duplicate choices in ${question.id}');
        expect(question.explanation.trim(), isNotEmpty);
        expect(question.difficultyRank, inRange(1, 100));
        expect(question.sourcePage, inRange(41, 72));
        expect(question.verificationStatus, Unit6QuestionBank.verifiedStatus);
      }
    });

    test('prompts and choices use RTL-friendly Arabic digits and decimals', () {
      final arabicDigit = RegExp(r'[٠-٩]');
      final decimalSeparator = RegExp(r'[٫٬]');
      var digitsSeen = 0;
      var decimalsSeen = 0;
      for (final question in Unit6QuestionBank.questions) {
        final text = '${question.prompt}${question.choices.join()}'
            '${question.explanation}';
        expect(text, isNot(contains('0.')), reason: question.id);
        expect(text, isNot(matches(RegExp(r'[0-9]'))), reason: question.id);
        digitsSeen += arabicDigit.allMatches(text).length;
        decimalsSeen += decimalSeparator.allMatches(text).length;
      }
      // Conceptual questions need no digits, but the bank as a whole must
      // consistently use Arabic-Indic digits and the Arabic decimal point.
      expect(digitsSeen, greaterThan(100));
      expect(decimalsSeen, greaterThan(100));
    });

    test('question types cover reading, conversion, comparison and problems',
        () {
      final labels =
          Unit6QuestionBank.questions.map((q) => q.questionTypeLabel).toSet();
      for (final expected in const [
        'اختيار متعدد',
        'صح وخطأ',
        'أكمل الناقص',
        'قراءة وكتابة',
        'تحويل',
        'مقارنة وترتيب',
        'عملية حسابية',
        'مسألة لفظية',
      ]) {
        expect(labels, contains(expected));
      }
    });
  });

  group('Difficulty bands', () {
    test('every lesson has four questions in each 1–100 band', () {
      for (final lessonId in Unit6QuestionBank.lessonIds) {
        for (final band in const [
          (1, 30),
          (31, 70),
          (71, 100),
        ]) {
          final questions = Unit6QuestionBank.forLesson(
            lessonId,
            minDifficulty: band.$1,
            maxDifficulty: band.$2,
          );
          expect(questions, hasLength(4), reason: '$lessonId $band');
        }
      }
    });

    test('strength tiers map to the required difficulty bands', () {
      expect(
          Unit6QuestionBank.bandForStrength(easy: true, hard: false), (1, 30));
      expect(Unit6QuestionBank.bandForStrength(easy: false, hard: false),
          (31, 70));
      expect(Unit6QuestionBank.bandForStrength(easy: false, hard: true),
          (71, 100));
    });

    test('deeper questions require multi-step or application thinking', () {
      // Hard questions must do more than name a digit or read a simple
      // fraction: they use word problems, missing values, borrowing,
      // multi-term arithmetic, or reasoning about place value/ordering.
      const deeperSkills = [
        'متعددة',
        'دمج',
        'تحقق',
        'استلاف',
        'قوسين',
        'القراءة بالكلمات',
        'القيمة المنزلية',
        'ترتيب مبني',
        'أصفار نهاية',
        'جمع عدد صحيح',
        'ترتيب أربعة',
      ];
      for (final lessonId in Unit6QuestionBank.lessonIds) {
        final deep = Unit6QuestionBank.forLesson(
          lessonId,
          minDifficulty: 71,
        );
        expect(deep, hasLength(4), reason: lessonId);
        expect(
          deep.every(
            (q) =>
                q.questionTypeLabel == 'مسألة لفظية' ||
                q.questionTypeLabel == 'أكمل الناقص' ||
                deeperSkills.any(q.skill.contains),
          ),
          isTrue,
          reason: 'hard questions must demand more than recognition: '
              '$lessonId',
        );
      }
    });
  });

  group('Math and explanation correctness', () {
    // Hand-verified arithmetic answers, independent of the bank's own
    // correctIndex field. These cover every pure-arithmetic question.
    const expectedArithmetic = <String, String>{
      'g4p2u6_t10_b01': '٠٫٧', // ٠٫٣ + ٠٫٤
      'g4p2u6_t10_b02': '٣٫٧', // ١٫٢ + ٢٫٥
      'g4p2u6_t10_b03': '٠٫٠٨', // ٠٫٠٥ + ٠٫٠٣
      'g4p2u6_t10_m01': '٣٫٧٦', // ١٫٤٦ + ٢٫٣
      'g4p2u6_t10_m02': '١٫٥', // ٠٫٨ + ٠٫٧
      'g4p2u6_t10_m04': '٤٫٨٧', // ٣٫٠٧ + ١٫٨
      'g4p2u6_t10_h04': '٨٫١٥', // ٥ + ٠٫٧٥ + ٢٫٤
      'g4p2u6_t11_b01': '٠٫٥', // ٠٫٩ - ٠٫٤
      'g4p2u6_t11_b02': '١٫٥', // ٢٫٨ - ١٫٣
      'g4p2u6_t11_b03': '٠٫٠٦', // ٠٫٠٩ - ٠٫٠٣
      'g4p2u6_t11_m01': '١٫٨', // ٣٫٥ - ١٫٧
      'g4p2u6_t11_m02': '٢٫٧٦', // ٥٫٠٦ - ٢٫٣
      'g4p2u6_t11_m04': '٦٫٦', // ١٠ - ٣٫٤
      'g4p2u6_t12_b01': '٣٫٠', // ٢٫٥ + ١٫٢ - ٠٫٧
      'g4p2u6_t12_b03': '٤٫٥', // ٦٫٨ - ٢٫٣
      'g4p2u6_t12_m01': '٥٫٠', // ٣٫٧٥ + ٢٫٤ - ١٫١٥
      'g4p2u6_t12_m04': '٤٫٤', // ١٠٫٥ - (٣٫٢ + ٢٫٩)
      'g4p2u6_t14_m03': '٦٫١٥', // ٣٫٧٥ + ٢٫٤
      'g4p2u6_t14_m04': '٤٫٥٥', // ٨٫٢ - ٣٫٦٥
    };

    // Hand-verified answers for representative word problems and missing
    // values across all nine lessons (two or more per lesson).
    const expectedApplications = <String, String>{
      'g4p2u6_t6_b03': '٠٫٣', // ثلاثة من عشرة
      'g4p2u6_t6_h02': '٦', // ٠٫٦ = ٦ من عشرة
      'g4p2u6_t7_b02': '٠٫٠١', // ١/١٠٠
      'g4p2u6_t7_h01': '٠٫٣٥', // ٣٥ سنتيمتراً من المتر
      'g4p2u6_t8_b01': '١٫٣', // واحد صحيح وثلاثة من عشرة
      'g4p2u6_t8_h01': '١٫٢٤', // ١ متر و٢٤ سنتيمتراً
      'g4p2u6_t9_h02': '٦', // أصغر رقم يجعل ٠٫٤◻ > ٠٫٤٥
      'g4p2u6_t9_h04': '٠٫٩، ٠٫٩٠، ٠٫٨٩، ٠٫٨٨',
      'g4p2u6_t10_h02': '٠٫٦', // ١٫٢ - ٠٫٦
      'g4p2u6_t10_h03': '١٠٫٥ كيلو جرام', // ٣٫٥ + ٤٫٢٥ + ٢٫٧٥
      'g4p2u6_t11_h01': '٥٫٩ كيلو جرام', // ٤٥٫٧ - ٣٩٫٨
      'g4p2u6_t11_h02': '٤٫٥', // ٨٫٤ - ٣٫٩
      'g4p2u6_t12_b04': 'خطأ', // ٥٫٠ - ١٫٥ = ٣٫٥ لا ٤٫٥
      'g4p2u6_t12_m02': '١٫٥٥ متر', // ٤٫٢٥ - (١٫٨ + ٠٫٩)
      'g4p2u6_t13_m01': '٢٫٥ متر', // ١١٫١ - (٤٫٧٥ + ٣٫٨٥)
      'g4p2u6_t13_h03': '٧٫٢٥ كيلو جرام', // ٥٠٫٥ - ٣٠٫٧٥ - ١٢٫٥
      'g4p2u6_t14_b01': '١٨٫٧', // ثمانية عشر صحيح وسبعة من عشرة
      'g4p2u6_t14_m04': '٤٫٥٥', // ٨٫٢ - ٣٫٦٥
      'g4p2u6_t14_h01': '١١٫٢٥ كيلو جرام', // ٢٥ - ١٣٫٧٥
      'g4p2u6_t14_h04': '١٫٢٥ والفرق ٠٫٧٥', // ١ + ٠٫٢٥، ٢ - ١٫٢٥
    };

    test('arithmetic answers match independently computed values', () {
      final byId = {
        for (final question in Unit6QuestionBank.questions)
          question.id: question
      };
      expect(expectedArithmetic.keys.every(byId.containsKey), isTrue);
      for (final entry in expectedArithmetic.entries) {
        expect(
          byId[entry.key]!.correctAnswer,
          entry.value,
          reason: 'wrong arithmetic answer for ${entry.key}',
        );
      }
      final arithmeticIds = Unit6QuestionBank.questions
          .where((q) => q.questionTypeLabel == 'عملية حسابية')
          .map((q) => q.id)
          .toSet();
      expect(arithmeticIds, expectedArithmetic.keys.toSet());
    });

    test('applications, reading and comparison answers are correct', () {
      final byId = {
        for (final question in Unit6QuestionBank.questions)
          question.id: question
      };
      expect(expectedApplications.keys.every(byId.containsKey), isTrue);
      for (final entry in expectedApplications.entries) {
        expect(
          byId[entry.key]!.correctAnswer,
          entry.value,
          reason: 'wrong answer for ${entry.key}',
        );
      }
    });

    test('worked explanations contain no self-correcting fragments', () {
      for (final question in Unit6QuestionBank.questions) {
        expect(question.explanation, isNot(contains('؟')),
            reason: 'unresolved fragment in ${question.id}');
        expect(question.explanation, isNot(contains('الحساب الصحيح')),
            reason: 'self-correcting text in ${question.id}');
      }
    });
  });

  group('Integration with the existing exam pipeline', () {
    test('factory routes each Unit 6 topic to the authored bank', () {
      final topics = {for (final topic in curriculumTopicSeed) topic.id: topic};
      final random = Random(3);
      for (final lessonId in Unit6QuestionBank.lessonIds) {
        for (var i = 0; i < 12; i++) {
          final question = TopicQuestionFactory.question(
            topic: topics[lessonId]!,
            strength: TopicStrength.values[i % 3],
            random: random,
            index: i,
          );
          expect(question.isAuthoredBankQuestion, isTrue);
          expect(question.id, startsWith('g4p2u6_'));
          expect(question.topicId, lessonId);
          expect(question.lessonName, Unit6QuestionBank.lessonNames[lessonId]);
          expect(question.sourcePage, inRange(41, 72));
          expect(
            question.verificationStatus,
            Unit6QuestionBank.verifiedStatus,
          );
          expect(question.answerText, question.correctAnswerText);
          expect(question.displayPrompt, question.promptText);
          expect(
            question.choiceText(question.correctAnswer),
            question.correctAnswerText,
          );
        }
      }
    });

    test('topic-filtered exams use only Unit 6 authored questions', () {
      const topics = ['g4_p2_t6', 'g4_p2_t8', 'g4_p2_t11'];
      final config = ExamConfig(
        section: MathSection.mixed,
        title: 'اختبار الوحدة السادسة',
        questionCount: 12,
        topicIds: topics,
        topicDifficultyLevel: 'mixed',
      );
      final questions = QuizBuilderService.generate(config);
      expect(questions, hasLength(12));
      expect(questions.every((q) => q.isAuthoredBankQuestion), isTrue);
      expect(
        questions.every((q) => topics.contains(q.topicId)),
        isTrue,
      );
      expect(
        questions.every((q) => q.choices.length >= 2),
        isTrue,
      );
    });

    test('pre-existing topics still use the original generator', () {
      final topics = {for (final topic in curriculumTopicSeed) topic.id: topic};
      final question = TopicQuestionFactory.question(
        topic: topics['g4_p2_t2']!,
        strength: TopicStrength.medium,
        random: Random(1),
        index: 0,
      );
      expect(question.isAuthoredBankQuestion, isFalse);
      expect(question.promptText, isNull);
      expect(question.correctAnswerText, isNull);
      expect(question.choiceTexts, isNull);
      expect(question.explanation, isNotEmpty);
    });
  });

  group('Graceful degradation on missing or empty bank data', () {
    test('unknown / Unit-6-shaped ids fall back without touching the bank', () {
      const fakeTopic = CurriculumTopic(
        id: 'g4_p2_t99',
        grade: 4,
        part: 2,
        title: 'غير معروف',
        unitName: 'الوحدة السادسة: الكسور العشرية',
        generationReady: true,
      );
      final question = TopicQuestionFactory.question(
        topic: fakeTopic,
        strength: TopicStrength.medium,
        random: Random(3),
      );
      // No authored match → original generator path, always a valid answer.
      expect(question.isAuthoredBankQuestion, isFalse);
      expect(question.correctAnswer, isIn(question.choices));
      expect(question.explanation, isNotEmpty);
    });

    test('difficulty filters with no matches return empty, never throw', () {
      expect(
        Unit6QuestionBank.forLesson('g4_p2_t6', minDifficulty: 101),
        isEmpty,
      );
      expect(
        Unit6QuestionBank.forLesson('g4_p2_t6', maxDifficulty: 0),
        isEmpty,
      );
      expect(
        Unit6QuestionBank.forLesson(
          'g4_p2_t6',
          minDifficulty: 50,
          maxDifficulty: 40,
        ),
        isEmpty,
      );
    });

    test('every authored question converts to a self-consistent Question', () {
      for (final authored in Unit6QuestionBank.questions) {
        final question = authored.toQuestion();
        expect(question.choices.length, authored.choices.length);
        expect(question.choiceTexts, authored.choices);
        expect(question.correctAnswer, isIn(question.choices));
        expect(
          question.choiceText(question.correctAnswer),
          authored.correctAnswer,
          reason: 'answer index/text mismatch for ${authored.id}',
        );
        expect(question.answerText, authored.correctAnswer);
        expect(question.displayPrompt, authored.prompt);
      }
    });
  });
}
