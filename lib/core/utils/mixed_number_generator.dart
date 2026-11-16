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

/// One piece of a fraction word-problem story: plain Arabic text or a
/// fraction that the UI renders as a visual fraction.
sealed class FractionStorySegment {
  const FractionStorySegment();
}

class FractionStoryText extends FractionStorySegment {
  const FractionStoryText(this.text);

  final String text;
}

class FractionStoryFraction extends FractionStorySegment {
  const FractionStoryFraction(this.value);

  final MixedNumber value;
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
    this.story,
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

  /// When non-null the question is a fraction word problem; the UI renders
  /// this story (with inline visual fractions) instead of the bare
  /// expression `num1 ± num2 = ?`.
  final List<FractionStorySegment>? story;

  bool get isWordProblem => story != null;

  /// The printed symbol for [operation], e.g. `×` for multiplication.
  String get operationSymbol {
    switch (operation) {
      case '*':
        return '×';
      case '/':
        return '÷';
      case '-':
        return '−';
      default:
        return operation;
    }
  }

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

  /// Generates a plain `a/d ± b/d` question with like denominators. The
  /// operands use `whole == 0`, so the same visual widgets render them as
  /// proper fractions instead of mixed numbers.
  MixedNumberQuestion generateLikeFractionQuestion({required bool add}) {
    final denominator =
        _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;

    final int firstNumerator;
    final int secondNumerator;
    if (add) {
      // Keep the sum strictly below the denominator so the answer stays a
      // proper fraction (no whole part).
      firstNumerator = _random.nextInt(denominator - 2) + 1;
      secondNumerator = _random.nextInt(denominator - firstNumerator - 1) + 1;
    } else {
      // firstNumerator > secondNumerator keeps the result non-negative.
      firstNumerator = _random.nextInt(denominator - 2) + 2;
      secondNumerator = _random.nextInt(firstNumerator - 1) + 1;
    }

    final first = MixedNumber(0, firstNumerator, denominator);
    final second = MixedNumber(0, secondNumerator, denominator);
    final operation = add ? '+' : '-';
    final resultTotal = add
        ? firstNumerator + secondNumerator
        : firstNumerator - secondNumerator;
    final answer = MixedNumber.fromImproper(resultTotal, denominator);
    final choices = _buildChoices(
      answer,
      first,
      second,
      operation,
      properOnly: true,
    );
    final correctIndex = choices.indexOf(answer);
    final operatorSymbol = add ? '+' : '−';

    final firstText = ArabicNumbers.formatInt(firstNumerator);
    final secondText = ArabicNumbers.formatInt(secondNumerator);
    final denominatorText = ArabicNumbers.formatInt(denominator);
    final totalText = ArabicNumbers.formatInt(resultTotal);
    final answerText = answer.toArabicString();

    final explanation = add
        ? 'المقامان متساويان ($denominatorText)، فنجمع البسطين: '
            '$firstText + $secondText = $totalText، والناتج $answerText.'
        : 'المقامان متساويان ($denominatorText)، ونطرح البسطين: '
            '$firstText − $secondText = $totalText، والناتج $answerText.';

    return MixedNumberQuestion(
      num1: first,
      num2: second,
      operation: operation,
      choices: choices,
      correctIndex: correctIndex,
      questionText:
          'أوجد ناتج: ${first.toArabicString()} $operatorSymbol ${second.toArabicString()} = ؟',
      explanation: explanation,
      spokenText: add
          ? 'اجمع الكسرين: $firstText على $denominatorText زائد $secondText على $denominatorText'
          : 'اطرح الكسرين: $firstText على $denominatorText ناقص $secondText على $denominatorText',
    );
  }

  static const List<String> _storyNames = [
    'أحمد',
    'خالد',
    'يوسف',
    'عمر',
    'سامي',
    'طارق',
  ];

  /// Generates a like-denominator fraction word problem. The story keeps the
  /// fractions as [FractionStoryFraction] segments so the UI can draw them
  /// with real fraction bars, and the answer choices are proper fractions.
  MixedNumberQuestion generateWordProblem() {
    final denominator =
        _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;
    final add = _random.nextBool();

    final int firstNumerator;
    final int secondNumerator;
    if (add) {
      firstNumerator = _random.nextInt(denominator - 2) + 1;
      secondNumerator = _random.nextInt(denominator - firstNumerator - 1) + 1;
    } else {
      firstNumerator = _random.nextInt(denominator - 2) + 2;
      secondNumerator = _random.nextInt(firstNumerator - 1) + 1;
    }

    final first = MixedNumber(0, firstNumerator, denominator);
    final second = MixedNumber(0, secondNumerator, denominator);
    final operation = add ? '+' : '-';
    final resultTotal = add
        ? firstNumerator + secondNumerator
        : firstNumerator - secondNumerator;
    final answer = MixedNumber.fromImproper(resultTotal, denominator);
    final choices = _buildChoices(
      answer,
      first,
      second,
      operation,
      properOnly: true,
    );
    final correctIndex = choices.indexOf(answer);

    final name = _storyNames[_random.nextInt(_storyNames.length)];
    final firstText = ArabicNumbers.formatInt(firstNumerator);
    final secondText = ArabicNumbers.formatInt(secondNumerator);
    final denominatorText = ArabicNumbers.formatInt(denominator);
    final totalText = ArabicNumbers.formatInt(resultTotal);
    final answerText = answer.toArabicString();

    final story = add
        ? <FractionStorySegment>[
            FractionStoryText('أكل $name '),
            FractionStoryFraction(first),
            const FractionStoryText(' من الكعكة، ثم أكل '),
            FractionStoryFraction(second),
            const FractionStoryText('. كم أكل من الكعكة؟'),
          ]
        : <FractionStorySegment>[
            FractionStoryText('كان مع $name '),
            FractionStoryFraction(first),
            const FractionStoryText(' من الشوكولاتة، فأعطى صديقه '),
            FractionStoryFraction(second),
            const FractionStoryText('. كم بقي معه؟'),
          ];

    final explanation = add
        ? 'المقامان متساويان ($denominatorText)، فنجمع البسطين: '
            '$firstText + $secondText = $totalText، والناتج $answerText.'
        : 'المقامان متساويان ($denominatorText)، ونطرح البسطين: '
            '$firstText − $secondText = $totalText، والناتج $answerText.';

    final questionText = add
        ? 'أكل $name ${first.toArabicString()} من الكعكة، ثم أكل '
            '${second.toArabicString()}. كم أكل من الكعكة؟'
        : 'كان مع $name ${first.toArabicString()} من الشوكولاتة، فأعطى '
            'صديقه ${second.toArabicString()}. كم بقي معه؟';

    return MixedNumberQuestion(
      num1: first,
      num2: second,
      operation: operation,
      choices: choices,
      correctIndex: correctIndex,
      questionText: questionText,
      explanation: explanation,
      spokenText: add
          ? 'أكل $name $firstText على $denominatorText من الكعكة، ثم أكل '
              '$secondText على $denominatorText. كم أكل من الكعكة؟'
          : 'كان مع $name $firstText على $denominatorText من الشوكولاتة، '
              'فأعطى صديقه $secondText على $denominatorText. كم بقي معه؟',
      story: story,
    );
  }

  /// Generates a plain `a/d ± b/e` question with unlike denominators. The
  /// result is reduced and every choice is a real fraction, so grade-5
  /// students see the common-denominator step with fraction bars.
  MixedNumberQuestion generateUnlikeFractionQuestion({required bool add}) {
    final firstDenominator =
        _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;
    var secondDenominator =
        _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;
    var guard = 0;
    while (secondDenominator == firstDenominator && guard < 20) {
      secondDenominator =
          _random.nextInt(maxDenominator - minDenominator + 1) + minDenominator;
      guard++;
    }

    final firstNumerator = _random.nextInt(firstDenominator - 1) + 1;
    final secondNumerator = _random.nextInt(secondDenominator - 1) + 1;

    var first = MixedNumber(0, firstNumerator, firstDenominator);
    var second = MixedNumber(0, secondNumerator, secondDenominator);

    // Subtraction must stay non-negative: order the larger fraction first.
    if (!add &&
        firstNumerator * secondDenominator <
            secondNumerator * firstDenominator) {
      final temporary = first;
      first = second;
      second = temporary;
    }

    final commonDenominator = (first.denominator * second.denominator) ~/
        MixedNumber._gcd(first.denominator, second.denominator);
    final firstScaled = commonDenominator ~/ first.denominator;
    final secondScaled = commonDenominator ~/ second.denominator;
    final firstTop = first.numerator * firstScaled;
    final secondTop = second.numerator * secondScaled;
    final total = add ? firstTop + secondTop : firstTop - secondTop;
    final answer = MixedNumber.fromImproper(total, commonDenominator);
    final wrongTop = add
        ? first.numerator + second.numerator
        : (first.numerator - second.numerator).abs();

    final choices = _buildVisualChoices(answer, [
      // Common mistake: operating on numerators and denominators directly.
      MixedNumber.fromImproper(
        wrongTop,
        first.denominator + second.denominator,
      ),
      // Common mistake: using the common denominator without scaling.
      MixedNumber.fromImproper(wrongTop, commonDenominator),
      MixedNumber.fromImproper(total + 1, commonDenominator),
      MixedNumber.fromImproper((total - 1).abs(), commonDenominator),
    ]);
    final correctIndex = choices.indexOf(answer);

    final firstText = first.toArabicString();
    final secondText = second.toArabicString();
    final commonText = ArabicNumbers.formatInt(commonDenominator);
    final firstTopText = ArabicNumbers.formatInt(firstTop);
    final secondTopText = ArabicNumbers.formatInt(secondTop);
    final totalText = ArabicNumbers.formatInt(total);
    final answerText = answer.toArabicString();
    final symbol = add ? '+' : '−';
    final verb = add ? 'نجمع' : 'نطرح';

    return MixedNumberQuestion(
      num1: first,
      num2: second,
      operation: add ? '+' : '-',
      choices: choices,
      correctIndex: correctIndex,
      questionText: 'أوجد ناتج: $firstText $symbol $secondText = ؟',
      explanation: 'نوحّد المقامات على $commonText: '
          '$firstText = $firstTopText/$commonText، و'
          '$secondText = $secondTopText/$commonText، '
          'ثم $verb البسطين: $firstTopText $symbol $secondTopText = '
          '$totalText، والناتج $answerText.',
      spokenText: 'أوجد ناتج: ${first.toSpokenString()} '
          '${add ? 'زائد' : 'ناقص'} ${second.toSpokenString()}',
    );
  }

  /// Generates a `a/b × c/d` or `a/b ÷ c/d` question whose answer is a real
  /// fraction, so multiplication/division renders with fraction bars too.
  MixedNumberQuestion generateFractionMulDivQuestion({
    required bool multiply,
  }) {
    final firstDenominator = _random.nextInt(5) + 2;
    final secondDenominator = _random.nextInt(5) + 2;
    final firstNumerator = _random.nextInt(firstDenominator - 1) + 1;
    final secondNumerator = _random.nextInt(secondDenominator - 1) + 1;

    final first = MixedNumber(0, firstNumerator, firstDenominator);
    final second = MixedNumber(0, secondNumerator, secondDenominator);

    final total = multiply
        ? firstNumerator * secondNumerator
        : firstNumerator * secondDenominator;
    final denominator = multiply
        ? firstDenominator * secondDenominator
        : firstDenominator * secondNumerator;
    final answer = MixedNumber.fromImproper(total, denominator);

    final choices = _buildVisualChoices(answer, [
      // Common mistake: adding numerators and denominators instead.
      MixedNumber.fromImproper(
        firstNumerator + secondNumerator,
        firstDenominator + secondDenominator,
      ),
      // Common mistake: the other operation.
      MixedNumber.fromImproper(
        multiply
            ? firstNumerator * secondDenominator
            : firstNumerator * secondNumerator,
        multiply
            ? firstDenominator * secondNumerator
            : firstDenominator * secondDenominator,
      ),
      MixedNumber.fromImproper(total + 1, denominator),
      MixedNumber.fromImproper((total - 1).abs(), denominator),
    ]);
    final correctIndex = choices.indexOf(answer);

    final firstText = first.toArabicString();
    final secondText = second.toArabicString();
    final numeratorText = ArabicNumbers.formatInt(total);
    final denominatorText = ArabicNumbers.formatInt(denominator);
    final answerText = answer.toArabicString();
    final symbol = multiply ? '×' : '÷';

    final explanation = multiply
        ? 'نضرب البسط في البسط والمقام في المقام: '
            '${ArabicNumbers.formatInt(firstNumerator)} × '
            '${ArabicNumbers.formatInt(secondNumerator)} = $numeratorText، و'
            '${ArabicNumbers.formatInt(firstDenominator)} × '
            '${ArabicNumbers.formatInt(secondDenominator)} = '
            '$denominatorText، أي $numeratorText/$denominatorText، '
            'ثم نبسّط: $answerText.'
        : 'نقسم الكسر الأول على الثاني بضربه في مقلوب الثاني: '
            '$firstText × ${second.denominator}/${second.numerator} = '
            '$numeratorText/$denominatorText، ثم نبسّط: $answerText.';

    return MixedNumberQuestion(
      num1: first,
      num2: second,
      operation: multiply ? '*' : '/',
      choices: choices,
      correctIndex: correctIndex,
      questionText: 'أوجد ناتج: $firstText $symbol $secondText = ؟',
      explanation: explanation,
      spokenText: 'أوجد ناتج: ${first.toSpokenString()} '
          '${multiply ? 'ضرب' : 'مقسومًا على'} ${second.toSpokenString()}',
    );
  }

  List<MixedNumber> _buildChoices(
    MixedNumber correct,
    MixedNumber first,
    MixedNumber second,
    String operation, {
    bool properOnly = false,
  }) {
    final pool = <MixedNumber>[correct];
    final keys = <String>{correct.key};

    void add(MixedNumber candidate) {
      if (candidate.whole < 0 ||
          candidate.numerator < 0 ||
          candidate.denominator <= 0 ||
          candidate.numerator >= candidate.denominator) {
        return;
      }
      // Plain-fraction questions should not offer a zero fraction.
      if (properOnly && candidate.numerator == 0) return;
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

    // Nearby numbers make plausible distractors. Plain-fraction questions
    // keep every choice a proper fraction so the visual style stays uniform.
    for (final delta in const [1, -1, 2, -2, 3]) {
      if (!properOnly && correct.whole + delta >= 0) {
        add(MixedNumber(
          correct.whole + delta,
          correct.numerator,
          correct.denominator,
        ));
      }
      final numerator = correct.numerator + delta;
      if (numerator >= 0 && numerator < correct.denominator) {
        add(MixedNumber(
          properOnly ? 0 : correct.whole,
          numerator,
          correct.denominator,
        ));
      }
    }

    var guard = 0;
    while (pool.length < 4 && guard < 200) {
      if (properOnly) {
        final denominator =
            _random.nextInt(maxDenominator - minDenominator + 1) +
                minDenominator;
        add(MixedNumber(
          0,
          _random.nextInt(denominator - 1) + 1,
          denominator,
        ));
      } else {
        add(MixedNumber(
          _random.nextInt(5),
          _random.nextInt(correct.denominator),
          correct.denominator,
        ));
      }
      guard++;
    }
    while (pool.length < 4 && guard < 400) {
      final denominator = _random.nextInt(8) + 2;
      if (properOnly) {
        add(MixedNumber(
          0,
          _random.nextInt(denominator - 1) + 1,
          denominator,
        ));
      } else {
        add(MixedNumber.fromImproper(
          _random.nextInt(denominator * 4),
          denominator,
        ));
      }
      guard++;
    }

    final distractors = pool.sublist(1)..shuffle(_random);
    final choices = <MixedNumber>[correct, ...distractors.take(3)];
    choices.shuffle(_random);
    return choices;
  }

  /// Builds four unique fraction choices around [correct], preferring the
  /// plausible distractor [candidates] before filling with random fractions.
  List<MixedNumber> _buildVisualChoices(
    MixedNumber correct,
    List<MixedNumber> candidates,
  ) {
    final pool = <MixedNumber>[correct];
    final keys = <String>{correct.key};

    void add(MixedNumber candidate) {
      if (candidate.whole < 0 || candidate.numerator < 0) return;
      if (candidate.denominator <= 0) return;
      if (candidate.numerator >= candidate.denominator) return;
      if (candidate.whole == 0 && candidate.numerator == 0) return;
      if (keys.add(candidate.key)) pool.add(candidate);
    }

    for (final candidate in candidates) {
      add(candidate);
    }

    var guard = 0;
    while (pool.length < 4 && guard < 200) {
      final denominator = _random.nextInt(9) + 2;
      add(MixedNumber(0, _random.nextInt(denominator - 1) + 1, denominator));
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
