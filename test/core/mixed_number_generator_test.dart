import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';

void main() {
  test('generateQuestion produces valid, solvable mixed-number MCQs', () {
    final random = Random(2026);
    final generator = MixedNumberGenerator(random: random);
    for (var i = 0; i < 300; i++) {
      final q = generator.generateQuestion();

      // Four unique choices with a valid correct index.
      expect(q.choices, hasLength(4), reason: 'question $i');
      expect(q.choices.map((c) => c.key).toSet(), hasLength(4),
          reason: 'duplicate choices in question $i');
      expect(q.correctIndex, inInclusiveRange(0, 3));
      expect(MixedNumberGenerator.validateChoice(q, q.correctIndex), isTrue,
          reason: 'correct index rejected in question $i');
      for (var c = 0; c < q.choices.length; c++) {
        expect(MixedNumberGenerator.validateChoice(q, c), c == q.correctIndex,
            reason: 'choice $c mismatch in question $i');
      }

      // Like denominators; proper fractions only.
      expect(q.num1.denominator, q.num2.denominator);
      expect(q.num1.numerator, lessThan(q.num1.denominator));
      expect(q.num2.numerator, lessThan(q.num2.denominator));
      for (final choice in q.choices) {
        expect(choice.numerator, lessThan(choice.denominator),
            reason: 'improper choice ${choice.key} in question $i');
        // A denominator of 1 means a whole-number choice (e.g. 1/4 + 3/4).
        expect(choice.denominator, greaterThanOrEqualTo(1));
      }

      // Subtraction never goes negative.
      final first = q.num1.toImproperNumerator();
      final second = q.num2.toImproperNumerator();
      if (q.operation == '-') {
        expect(first, greaterThanOrEqualTo(second),
            reason: 'negative subtraction in question $i');
      }

      // Text fields are populated.
      expect(q.questionText, contains('؟'));
      expect(q.explanation, isNotEmpty);
      expect(q.spokenText, isNotEmpty);
      expect(q.correctAnswer.key, isNotEmpty);
    }
  });

  test('fromImproper reduces fractions and keeps mixed form', () {
    expect(MixedNumber.fromImproper(7, 4), const MixedNumber(1, 3, 4));
    expect(MixedNumber.fromImproper(8, 4), const MixedNumber(2, 0, 1));
    expect(MixedNumber.fromImproper(6, 4), const MixedNumber(1, 1, 2));
    expect(MixedNumber.fromImproper(3, 4), const MixedNumber(0, 3, 4));
  });

  test('toArabicString renders whole and fractional forms', () {
    expect(const MixedNumber(2, 0, 1).toArabicString(), '٢');
    expect(const MixedNumber(0, 3, 4).toArabicString(), '٣/٤');
    expect(const MixedNumber(1, 1, 2).toArabicString(), '١ و١/٢');
  });

  test('generateLikeFractionQuestion keeps proper fractions and valid choices',
      () {
    for (final add in [true, false]) {
      final random = Random(add ? 31 : 32);
      final generator = MixedNumberGenerator(random: random);
      for (var i = 0; i < 300; i++) {
        final q = generator.generateLikeFractionQuestion(add: add);

        // Plain fractions: no whole part on operands, choices, or answer.
        expect(q.num1.whole, 0, reason: '${add ? 'add' : 'sub'} #$i');
        expect(q.num2.whole, 0, reason: '${add ? 'add' : 'sub'} #$i');
        expect(q.num1.denominator, q.num2.denominator);
        expect(q.operation, add ? '+' : '-');

        if (add) {
          expect(
            q.num1.toImproperNumerator() + q.num2.toImproperNumerator(),
            lessThan(q.num1.denominator),
          );
        } else {
          expect(
            q.num1.toImproperNumerator(),
            greaterThan(q.num2.toImproperNumerator()),
          );
        }

        expect(q.choices, hasLength(4));
        expect(
          q.choices.map((choice) => choice.key).toSet(),
          hasLength(4),
          reason: 'duplicate choices on ${add ? 'add' : 'sub'} #$i',
        );
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.correctAnswer, q.choices[q.correctIndex]);

        for (final choice in q.choices) {
          expect(choice.whole, 0, reason: 'mixed choice in plain question');
          expect(choice.numerator, greaterThan(0));
          expect(choice.numerator, lessThan(choice.denominator));
        }

        final expected = add
            ? q.num1.toImproperNumerator() + q.num2.toImproperNumerator()
            : q.num1.toImproperNumerator() - q.num2.toImproperNumerator();
        final answer = q.correctAnswer;
        expect(
          answer.toImproperNumerator() * q.num1.denominator,
          expected * answer.denominator,
          reason: 'answer $answer incorrect on ${add ? 'add' : 'sub'} #$i',
        );

        expect(q.questionText, contains('؟'));
        expect(q.explanation, isNotEmpty);
        expect(q.spokenText, isNotEmpty);
      }
    }
  });
}
