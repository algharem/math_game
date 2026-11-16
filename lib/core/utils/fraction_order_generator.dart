import 'dart:math';

import 'arabic_numbers.dart';
import 'mixed_number_generator.dart';

/// A grade-4 friendly "order these fractions" question with like
/// denominators. The student is asked for the ascending position (1-based
/// rank) of one highlighted fraction.
class FractionOrderQuestion {
  const FractionOrderQuestion({
    required this.fractions,
    required this.targetIndex,
    required this.questionText,
    required this.explanation,
    required this.spokenText,
  });

  /// Fractions in the order they are displayed to the student.
  final List<MixedNumber> fractions;

  /// Index (into [fractions]) of the fraction whose rank is asked about.
  final int targetIndex;

  final String questionText;
  final String explanation;
  final String spokenText;

  MixedNumber get target => fractions[targetIndex];

  /// The same fractions sorted ascending by numeric value.
  List<MixedNumber> get ascending {
    final sorted = List<MixedNumber>.of(fractions);
    sorted.sort((a, b) {
      final left = a.toImproperNumerator() * b.denominator;
      final right = b.toImproperNumerator() * a.denominator;
      if (left != right) return left.compareTo(right);
      return a.denominator.compareTo(b.denominator);
    });
    return sorted;
  }

  /// 1-based ascending rank of [target].
  int get correctRank {
    final key = target.key;
    return ascending.indexWhere((fraction) => fraction.key == key) + 1;
  }

  bool isCorrectRank(int? rank) => rank != null && rank == correctRank;

  /// e.g. «١/٧ < ٢/٧ < ٣/٧ < ٤/٧».
  String get ascendingText =>
      ascending.map((fraction) => fraction.toArabicString()).join(' < ');
}

/// Builds [FractionOrderQuestion]s with four distinct proper fractions that
/// share one denominator, so ordering reduces to comparing numerators.
class FractionOrderGenerator {
  FractionOrderGenerator({Random? random}) : _random = random ?? Random();

  static const int minDenominator = 5;
  static const int maxDenominator = 10;

  final Random _random;

  FractionOrderQuestion generate() {
    final denominator =
        _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;

    // Four distinct numerators in 1..denominator-1 (denominator >= 5, so
    // there are always at least four candidates).
    final numerators = <int>{};
    while (numerators.length < 4) {
      numerators.add(_random.nextInt(denominator - 1) + 1);
    }

    final orderedNumerators = numerators.toList()..sort();
    final shuffled = numerators.toList(growable: false)..shuffle(_random);
    final fractions = [
      for (final numerator in shuffled) MixedNumber(0, numerator, denominator),
    ];
    final targetIndex = _random.nextInt(fractions.length);
    final target = fractions[targetIndex];

    final denominatorText = ArabicNumbers.formatInt(denominator);
    final targetText = target.toArabicString();
    final rank =
        orderedNumerators.indexOf(target.numerator) + 1; // ascending rank
    final ascendingText = orderedNumerators
        .map((numerator) =>
            MixedNumber(0, numerator, denominator).toArabicString())
        .join(' < ');
    final listText =
        fractions.map((fraction) => fraction.toArabicString()).join('، ');

    return FractionOrderQuestion(
      fractions: fractions,
      targetIndex: targetIndex,
      questionText: 'رتّب الكسور تصاعديًا: $listText — ما ترتيب $targetText؟',
      explanation: 'المقامات متساوية ($denominatorText)، فنرتّب حسب البسوط: '
          '$ascendingText. '
          'إذن ترتيب $targetText تصاعديًا هو: ${ArabicNumbers.formatInt(rank)}.',
      spokenText: 'رتّب الكسور $listText تصاعديًا، '
          'ثم حدّد ترتيب $targetText.',
    );
  }
}
