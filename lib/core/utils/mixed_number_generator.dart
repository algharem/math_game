import 'dart:math';

import 'arabic_numbers.dart';

/// A grade-4 friendly mixed number: a whole part plus a proper fraction.
class MixedNumber {
  const MixedNumber(this.whole, this.numerator, this.denominator)
      : assert(whole >= 0),
        assert(numerator >= 0),
        assert(denominator > 0);

  final int whole;
  final int numerator;
  final int denominator;

  /// Converts to an improper fraction's numerator while keeping
  /// [denominator] unchanged.
  int toImproperNumerator() => (whole * denominator) + numerator;

  /// Builds a mixed number from an improper fraction and reduces the
  /// fractional part when possible.
  static MixedNumber fromImproper(int improperNum, int denominator) {
    if (denominator <= 0) {
      throw ArgumentError.value(denominator, 'denominator', 'must be > 0');
    }
    final whole = improperNum ~/ denominator;
    final remainder = improperNum % denominator;
    if (remainder == 0) return MixedNumber(whole, 0, 1);
    final divisor = _gcd(remainder, denominator);
    return MixedNumber(whole, remainder ~/ divisor, denominator ~/ divisor);
  }

  String toArabicString() {
    final wholeText = ArabicNumbers.formatInt(whole);
    final numeratorText = ArabicNumbers.formatInt(numerator);
    final denominatorText = ArabicNumbers.formatInt(denominator);
    if (numerator == 0) return wholeText;
    if (whole == 0) return '$numeratorText/$denominatorText';
    return '$wholeText و$numeratorText/$denominatorText';
  }

  String toSpokenString() {
    final wholeText = ArabicNumbers.formatInt(whole);
    final numeratorText = ArabicNumbers.formatInt(numerator);
    final denominatorText = ArabicNumbers.formatInt(denominator);
    if (numerator == 0) return wholeText;
    if (whole == 0) return '$numeratorText على $denominatorText';
    return '$wholeText و$numeratorText على $denominatorText';
  }

  String get key => '$whole:$numerator:$denominator';

  @override
  String toString() => toArabicString();

  @override
  bool operator ==(Object other) =>
      other is MixedNumber &&
      other.whole == whole &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => Object.hash(whole, numerator, denominator);

  static int _gcd(int a, int b) {
    var first = a.abs();
    var second = b.abs();
    while (second > 0) {
      final remainder = first % second;
      first = second;
      second = remainder;
    }
    return first == 0 ? 1 : first;
  }
}

/// One generated mixed-number addition/subtraction exercise, including the
/// four shuffled MCQ choices and the index of the correct one.
class MixedNumberQuestion {
  MixedNumberQuestion({
    required this.num1,
    required this.num2,
    required this.operation,
    required this.choices,
    required this.correctIndex,
    required this.questionText,
    required this.explanation,
    required this.spokenText,
  })  : assert(choices.length >= 2),
        assert(correctIndex >= 0 && correctIndex < choices.length);

  final MixedNumber num1;
  final MixedNumber num2;

  /// `+` or `-`.
  final String operation;

  final List<MixedNumber> choices;
  final int correctIndex;
  final String questionText;
  final String explanation;
  final String spokenText;

  MixedNumber get correctAnswer => choices[correctIndex];

  bool isCorrect(MixedNumber value) => value == correctAnswer;

  bool isCorrectChoice(int choiceIndex) => choiceIndex == correctIndex;
}

/// Generates grade-4 mixed-number addition/subtraction questions with
/// like denominators and no negative results.
class MixedNumberGenerator {
  MixedNumberGenerator({
    Random? random,
    this.minDenominator = 3,
    this.maxDenominator = 10,
    this.maxWhole = 3,
  })  : assert(minDenominator >= 2),
        assert(maxDenominator > minDenominator),
        assert(maxWhole >= 1),
        _random = random ?? Random();

  final Random _random;
  final int minDenominator;
  final int maxDenominator;
  final int maxWhole;

  /// Used by the quiz screen so answer validation comes from the generated
  /// question object rather than a hard-coded widget value.
  static bool validateChoice(
    MixedNumberQuestion question,
    int choiceIndex,
  ) {
    return question.isCorrectChoice(choiceIndex);
  }

  MixedNumberQuestion generateQuestion() {
    final denominator =
        _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;

    var first = MixedNumber(
      _random.nextInt(maxWhole + 1),
      _random.nextInt(denominator - 1) + 1,
      denominator,
    );
    var second = MixedNumber(
      _random.nextInt(maxWhole + 1),
      _random.nextInt(denominator - 1) + 1,
      denominator,
    );

    final operation = _random.nextBool() ? '+' : '-';

    // Keep subtraction non-negative by swapping the operands when needed.
    if (operation == '-' &&
        first.toImproperNumerator() < second.toImproperNumerator()) {
      final temporary = first;
      first = second;
      second = temporary;
    }

    final resultTotal = operation == '+'
        ? first.toImproperNumerator() + second.toImproperNumerator()
        : first.toImproperNumerator() - second.toImproperNumerator();
    final answer = MixedNumber.fromImproper(resultTotal, denominator);
    final choices = _buildChoices(answer, first, second, operation);
    final correctIndex = choices.indexOf(answer);
    final operatorSymbol = operation == '+' ? '+' : '−';

    return MixedNumberQuestion(
      num1: first,
      num2: second,
      operation: operation,
      choices: choices,
      correctIndex: correctIndex,
      questionText:
          'أوجد ناتج: ${first.toArabicString()} $operatorSymbol ${second.toArabicString()} = ؟',
      explanation: _buildExplanation(first, second, answer, operation),
      spokenText: 'أوجد ناتج: ${first.toSpokenString()} '
          '${operation == '+' ? 'زائد' : 'ناقص'} ${second.toSpokenString()}',
    );
  }

  List<MixedNumber> _buildChoices(
    MixedNumber correct,
    MixedNumber first,
    MixedNumber second,
    String operation,
  ) {
    final pool = <MixedNumber>[correct];
    final keys = <String>{correct.key};

    void add(MixedNumber candidate) {
      if (candidate.whole < 0 ||
          candidate.numerator < 0 ||
          candidate.denominator <= 0 ||
          candidate.numerator >= candidate.denominator) {
        return;
      }
      if (keys.add(candidate.key)) pool.add(candidate);
    }

    // A common mistake: applying the operation to the denominators too.
    final wrongDenominator = first.denominator + second.denominator;
    final firstImproper = first.toImproperNumerator();
    final secondImproper = second.toImproperNumerator();
    final wrongTotal = operation == '+'
        ? firstImproper + secondImproper
        : (firstImproper - secondImproper).abs();
    add(MixedNumber.fromImproper(wrongTotal, wrongDenominator));

    // Nearby mixed numbers make plausible distractors.
    for (final delta in const [1, -1, 2, -2, 3]) {
      if (correct.whole + delta >= 0) {
        add(MixedNumber(
          correct.whole + delta,
          correct.numerator,
          correct.denominator,
        ));
      }
      final numerator = correct.numerator + delta;
      if (numerator >= 0 && numerator < correct.denominator) {
        add(MixedNumber(
          correct.whole,
          numerator,
          correct.denominator,
        ));
      }
    }

    var guard = 0;
    while (pool.length < 4 && guard < 200) {
      add(MixedNumber(
        _random.nextInt(5),
        _random.nextInt(correct.denominator),
        correct.denominator,
      ));
      guard++;
    }
    while (pool.length < 4 && guard < 400) {
      final denominator = _random.nextInt(8) + 2;
      add(MixedNumber.fromImproper(
        _random.nextInt(denominator * 4),
        denominator,
      ));
      guard++;
    }

    final distractors = pool.sublist(1)..shuffle(_random);
    final choices = <MixedNumber>[correct, ...distractors.take(3)];
    choices.shuffle(_random);
    return choices;
  }

  String _buildExplanation(
    MixedNumber first,
    MixedNumber second,
    MixedNumber answer,
    String operation,
  ) {
    final firstWhole = ArabicNumbers.formatInt(first.whole);
    final secondWhole = ArabicNumbers.formatInt(second.whole);
    final totalWhole = ArabicNumbers.formatInt(first.whole + second.whole);
    final firstNumerator = ArabicNumbers.formatInt(first.numerator);
    final secondNumerator = ArabicNumbers.formatInt(second.numerator);
    final denominator = ArabicNumbers.formatInt(first.denominator);
    final fractionSum = ArabicNumbers.formatInt(
      first.numerator + second.numerator,
    );
    final firstImproper = ArabicNumbers.formatInt(first.toImproperNumerator());
    final secondImproper =
        ArabicNumbers.formatInt(second.toImproperNumerator());
    final difference = ArabicNumbers.formatInt(
      first.toImproperNumerator() - second.toImproperNumerator(),
    );

    if (operation == '+') {
      return 'نجمع الأجزاء الصحيحة: $firstWhole + $secondWhole = $totalWhole، '
          'ونجمع الكسور: $firstNumerator/$denominator + '
          '$secondNumerator/$denominator = $fractionSum/$denominator، '
          'ثم نبسّط الناتج ليكون ${answer.toArabicString()}.';
    }
    return 'نحوّل العددين إلى كسرين غير حقيقيين: '
        '$firstImproper/$denominator و $secondImproper/$denominator، '
        'ثم نطرح البسطين: $firstImproper − $secondImproper = $difference، '
        'والناتج ${answer.toArabicString()}.';
  }
}
