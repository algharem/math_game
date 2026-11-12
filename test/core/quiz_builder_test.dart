import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';

void main() {
  group('QuizBuilderService multiplication', () {
    test('generates the requested count with a fixed table', () {
      const config = ExamConfig(
        section: MathSection.multiplication,
        title: 'جدول ٧',
        questionCount: 12,
        difficulty: Difficulty.easy,
        multiplicationTable: 7,
        multiplicationFormat: MultiplicationFormat.result,
      );
      final questions = QuizBuilderService.generate(config);

      expect(questions, hasLength(12));
      for (final question in questions) {
        expect(question.factKey, startsWith('mul:7:'));
        expect(question.choices, contains(question.correctAnswer));
        expect(question.tokens[0], 7);
        expect(question.correctAnswer,
            (question.tokens[0] as int) * (question.tokens[2] as int));
      }
    });

    test('missing-factor questions use the missing factor as the answer', () {
      const config = ExamConfig(
        section: MathSection.multiplication,
        title: 'العدد الناقص',
        questionCount: 20,
        difficulty: Difficulty.medium,
        multiplicationTable: 6,
        multiplicationFormat: MultiplicationFormat.missing,
      );
      for (final question in QuizBuilderService.generate(config)) {
        expect(question.tokens.where((token) => token == null), hasLength(1));
        expect(
          question.choices,
          contains(question.correctAnswer),
        );
      }
    });
  });

  group('QuizBuilderService division', () {
    test('all division formats produce a valid equation', () {
      const config = ExamConfig(
        section: MathSection.division,
        title: 'القسمة',
        questionCount: 30,
        difficulty: Difficulty.medium,
        divisionFormat: DivisionFormat.mixed,
      );
      final questions = QuizBuilderService.generate(config);
      expect(questions, hasLength(30));

      for (final question in questions) {
        final nullIndex = question.tokens.indexOf(null);
        expect(nullIndex, isNot(-1));
        expect(question.correctAnswer, greaterThan(0));
        expect(question.choices, contains(question.correctAnswer));

        final dividend =
            nullIndex == 0 ? question.correctAnswer : question.tokens[0] as int;
        final divisor =
            nullIndex == 2 ? question.correctAnswer : question.tokens[2] as int;
        final quotient =
            nullIndex == 4 ? question.correctAnswer : question.tokens[4] as int;
        expect(dividend, divisor * quotient);
      }
    });
  });

  group('QuizBuilderService arithmetic', () {
    test('addition answers equal the sum', () {
      const config = ExamConfig(
        section: MathSection.addition,
        title: 'الجمع',
        questionCount: 20,
      );
      for (final question in QuizBuilderService.generate(config)) {
        expect(
          question.correctAnswer,
          (question.tokens[0] as int) + (question.tokens[2] as int),
        );
      }
    });

    test('subtraction answers are non-negative and equal the difference', () {
      const config = ExamConfig(
        section: MathSection.subtraction,
        title: 'الطرح',
        questionCount: 20,
      );
      for (final question in QuizBuilderService.generate(config)) {
        final first = question.tokens[0] as int;
        final second = question.tokens[2] as int;
        expect(first, greaterThanOrEqualTo(second));
        expect(question.correctAnswer, first - second);
      }
    });
  });

  group('QuizBuilderService difficulty progression', () {
    test('level one arithmetic stays within small-number bounds', () {
      const config = ExamConfig(
        section: MathSection.addition,
        title: 'مستوى ١',
        questionCount: 30,
        difficulty: Difficulty.easy,
        levelNumber: 1,
        schoolGrade: 9,
        dailyDateKey: 'level-one',
      );

      for (final question in QuizBuilderService.generate(config)) {
        expect(question.tokens[0] as int, lessThanOrEqualTo(10));
        expect(question.tokens[2] as int, lessThanOrEqualTo(10));
      }
    });

    test('does not repeat the same question inside one exam', () {
      const config = ExamConfig(
        section: MathSection.addition,
        title: 'بلا تكرار',
        questionCount: 20,
        difficulty: Difficulty.easy,
        levelNumber: 21,
        schoolGrade: 5,
        dailyDateKey: 'no-duplicates',
      );
      final questions = QuizBuilderService.generate(config);
      final signatures = questions
          .map((question) => question.tokens.join('|'))
          .toList(growable: false);

      expect(signatures.toSet(), hasLength(signatures.length));
    });

    test('advanced mixed levels include valid two-step expressions', () {
      const config = ExamConfig(
        section: MathSection.mixed,
        title: 'مختلط متقدم',
        questionCount: 30,
        difficulty: Difficulty.hard,
        levelNumber: 91,
        schoolGrade: 9,
        dailyDateKey: 'advanced-mixed',
      );
      final questions = QuizBuilderService.generate(config);
      final twoStep = questions
          .where((question) => question.kind == QuestionKind.mixedExpression)
          .toList(growable: false);

      expect(twoStep, isNotEmpty);
      for (final question in twoStep) {
        final first = question.tokens[1] as int;
        final operator = question.tokens[2] as String;
        final second = question.tokens[3] as int;
        final outer = question.tokens[5] as String;
        final third = question.tokens[6] as int;
        if (operator == '+') {
          expect(outer, '×');
          expect(question.correctAnswer, (first + second) * third);
        } else {
          expect(operator, '×');
          expect(outer, '+');
          expect(question.correctAnswer, first * second + third);
        }
      }
    });

    test('lower mixed levels avoid two-step expressions', () {
      const config = ExamConfig(
        section: MathSection.mixed,
        title: 'مختلط أساسي',
        questionCount: 20,
        difficulty: Difficulty.medium,
        levelNumber: 80,
        schoolGrade: 9,
        dailyDateKey: 'basic-mixed',
      );

      expect(
        QuizBuilderService.generate(config).where(
          (question) => question.kind == QuestionKind.mixedExpression,
        ),
        isEmpty,
      );
    });
  });

  group('QuizBuilderService daily', () {
    test('is deterministic for the same date key', () {
      const config = ExamConfig(
        section: MathSection.daily,
        title: 'تحدي اليوم',
        questionCount: 10,
        source: ExamSource.daily,
        dailyDateKey: '2026-01-15',
      );
      final first = QuizBuilderService.generate(config);
      final second = QuizBuilderService.generate(config);

      expect(
        first.map((question) => question.factKey).toList(),
        second.map((question) => question.factKey).toList(),
      );
      expect(
        first.map((question) => question.correctAnswer).toList(),
        second.map((question) => question.correctAnswer).toList(),
      );
    });
  });
}
