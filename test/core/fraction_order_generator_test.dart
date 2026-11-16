import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/fraction_order_generator.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';

void main() {
  group('FractionOrderQuestion', () {
    test('sorts fractions ascending by value and ranks the target', () {
      const question = FractionOrderQuestion(
        fractions: [
          MixedNumber(0, 3, 7),
          MixedNumber(0, 1, 7),
          MixedNumber(0, 4, 7),
          MixedNumber(0, 2, 7),
        ],
        targetIndex: 0,
        questionText: '',
        explanation: '',
        spokenText: '',
      );

      expect(question.target, const MixedNumber(0, 3, 7));
      expect(
        question.ascending.map((fraction) => fraction.numerator),
        [1, 2, 3, 4],
      );
      expect(question.correctRank, 3);
      expect(question.isCorrectRank(3), isTrue);
      expect(question.isCorrectRank(2), isFalse);
      expect(question.isCorrectRank(null), isFalse);
      expect(question.ascendingText, '١/٧ < ٢/٧ < ٣/٧ < ٤/٧');
    });

    test('compares fractions with different denominators correctly', () {
      const question = FractionOrderQuestion(
        fractions: [
          MixedNumber(0, 2, 3),
          MixedNumber(0, 1, 2),
          MixedNumber(0, 3, 4),
        ],
        targetIndex: 0,
        questionText: '',
        explanation: '',
        spokenText: '',
      );

      // 1/2 < 2/3 < 3/4.
      expect(
        question.ascending.map((fraction) => fraction.toArabicString()),
        ['١/٢', '٢/٣', '٣/٤'],
      );
      expect(question.correctRank, 2);
    });
  });

  group('FractionOrderGenerator', () {
    test('builds four distinct like-denominator proper fractions', () {
      final generator = FractionOrderGenerator(random: Random(5));
      for (var i = 0; i < 300; i++) {
        final question = generator.generate();
        expect(question.fractions, hasLength(4), reason: 'iteration $i');
        expect(
          question.fractions.map((fraction) => fraction.key).toSet(),
          hasLength(4),
          reason: 'duplicate fractions on iteration $i',
        );
        final denominator = question.fractions.first.denominator;
        expect(denominator, inInclusiveRange(5, 10));
        for (final fraction in question.fractions) {
          expect(fraction.whole, 0);
          expect(fraction.denominator, denominator);
          expect(fraction.numerator, inInclusiveRange(1, denominator - 1));
        }
        expect(question.targetIndex, inInclusiveRange(0, 3));
        expect(question.correctRank, inInclusiveRange(1, 4));
        expect(question.questionText, isNotEmpty);
        expect(question.explanation, contains('تصاعديًا'));
        expect(question.spokenText, isNotEmpty);
      }
    });

    test('target rank matches the ascending chain', () {
      final generator = FractionOrderGenerator(random: Random(11));
      for (var i = 0; i < 200; i++) {
        final question = generator.generate();
        final ascending = question.ascending;
        for (var rank = 0; rank < ascending.length; rank++) {
          if (ascending[rank].key != question.target.key) continue;
          expect(question.correctRank, rank + 1, reason: 'iteration $i');
        }
      }
    });
  });
}
