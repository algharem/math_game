import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/services/quiz_builder_service.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';

QuestionKind _kind(ExamConfig config, int seed) {
  return QuizBuilderService.generate(config).first.kind;
}

void main() {
  ExamConfig configFor(int grade, {int? level, MathSection? section}) {
    return ExamConfig(
      section: section ?? MathSection.mixed,
      title: 'اختبار',
      questionCount: 10,
      levelNumber: level,
      schoolGrade: grade,
    );
  }

  test('grade 5 mixed exams include curriculum number-sense kinds', () {
    final kinds = <QuestionKind>{};
    for (var seed = 0; seed < 60; seed++) {
      kinds.add(_kind(configFor(5, level: 70), seed));
    }
    expect(
      kinds.any((kind) {
        return kind == QuestionKind.numberWords ||
            kind == QuestionKind.expandedForm ||
            kind == QuestionKind.compareNumbers ||
            kind == QuestionKind.rounding;
      }),
      isTrue,
      reason: 'expected at least one curriculum kind over 60 draws',
    );
  });

  test('grade 3 (no curriculum) never produces curriculum kinds', () {
    for (var seed = 0; seed < 40; seed++) {
      final kind = _kind(configFor(3, level: 70), seed);
      expect(
        kind,
        isNot(anyOf(
          QuestionKind.numberWords,
          QuestionKind.expandedForm,
          QuestionKind.compareNumbers,
          QuestionKind.rounding,
        )),
      );
    }
  });

  test('grade 5 curriculum questions stay in book bounds', () {
    for (var seed = 0; seed < 120; seed++) {
      final questions = QuizBuilderService.generate(
        ExamConfig(
          section: MathSection.mixed,
          title: 'اختبار',
          questionCount: 10,
          levelNumber: 90,
          schoolGrade: 5,
        ),
      );
      for (final question in questions) {
        expect(question.choices, contains(question.correctAnswer));
        expect(question.choices, hasLength(4));
        expect(question.choices.toSet(), question.choices, reason: 'unique');
        switch (question.kind) {
          case QuestionKind.numberWords:
            expect(question.correctAnswer, inInclusiveRange(10, 99999999));
          case QuestionKind.expandedForm:
            expect(question.correctAnswer, inInclusiveRange(10, 999999));
          case QuestionKind.compareNumbers:
            expect(question.correctAnswer, inInclusiveRange(1, 9999999));
          case QuestionKind.rounding:
            expect(
              question.correctAnswer % 10,
              isZero,
              reason: 'rounding answer: ${question.correctAnswer}',
            );
          default:
            break;
        }
      }
    }
  });

  test('grade 5 pool keeps legacy arithmetic working (addition)', () {
    for (var seed = 0; seed < 40; seed++) {
      final config = ExamConfig(
        section: MathSection.addition,
        title: 'جمع',
        questionCount: 6,
        levelNumber: 95,
        schoolGrade: 5,
      );
      final questions = QuizBuilderService.generate(config);
      expect(questions, hasLength(6));
      for (final question in questions) {
        expect(question.kind, QuestionKind.addition);
        // Late-year book cap: sums within 999999 (+ second operand).
        expect(question.correctAnswer, lessThanOrEqualTo(999999 * 2));
      }
    }
  });

  test('daily exams with grade 5 produce answerable choices', () {
    final config = ExamConfig(
      section: MathSection.daily,
      title: 'تحدٍ يومي',
      questionCount: 10,
      dailyDateKey: '2026-11-08',
      schoolGrade: 5,
    );
    final questions = QuizBuilderService.generate(config);
    expect(questions, hasLength(10));
    for (final question in questions) {
      expect(question.choices, contains(question.correctAnswer));
      expect(question.topicLabel, isNotNull);
    }
  });
}
