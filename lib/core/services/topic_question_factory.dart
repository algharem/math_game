import 'dart:math';

import '../../shared/models/curriculum_topic.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/question.dart';
import '../utils/arabic_number_words.dart';
import '../utils/arabic_numbers.dart';
import '../utils/fraction_order_generator.dart';
import '../utils/id_generator.dart';
import '../utils/mixed_number_generator.dart';

/// Per-topic numeric envelope (operands bounds) for question generation.
class TopicEnvelope {
  const TopicEnvelope({required this.min, required this.max});

  final int min;
  final int max;
}

enum TopicStrength { easy, medium, hard }

typedef TopicBuilder = Question Function(
  CurriculumTopic topic,
  TopicEnvelope envelope,
  Random random,
  int index,
);

/// Generates MCQ questions strictly inside one curriculum topic.
/// Topic ids match `topic_seed.dart`; unknown ids fall back to a plain
/// addition question inside the envelope.
class TopicQuestionFactory {
  TopicQuestionFactory._();

  static int _rand(Random random, int min, int max) {
    if (max <= min) return min;
    return min + random.nextInt(max - min + 1);
  }

  static Question question({
    required CurriculumTopic topic,
    required TopicStrength strength,
    required Random random,
    int index = 0,
  }) {
    final envelope = _envelopeFor(strength);
    final builder = _builders[topic.id] ?? _additionBuilder;
    return builder(topic, envelope, random, index);
  }

  static TopicEnvelope _envelopeFor(TopicStrength strength) {
    return switch (strength) {
      TopicStrength.easy => const TopicEnvelope(min: 1, max: 99),
      TopicStrength.medium => const TopicEnvelope(min: 1, max: 999),
      TopicStrength.hard => const TopicEnvelope(min: 1, max: 9999),
    };
  }

  static const Map<String, TopicBuilder> _builders = {
    // Grade 1
    'g1_p1_t1': _numberWordsWithin9,
    'g1_p1_t2': _compareWithin9,
    'g1_p1_t3': _additionWithin9,
    'g1_p1_t4': _subtractionWithin9,
    'g1_p2_t1': _placeValueTens,
    'g1_p2_t2': _compareWithin99,
    'g1_p2_t3': _additionWithin99,
    'g1_p2_t4': _additionWithin99,
    // Grade 2
    'g2_p1_t1': _expandedWithin999,
    'g2_p1_t2': _compareWithin999,
    'g2_p1_t3': _additionWithin999,
    'g2_p1_t4': _subtractionWithin999,
    'g2_p2_t1': _multiplicationTables5,
    'g2_p2_t2': _divisionWithin5,
    // Grade 3
    'g3_p1_t1': _expandedWithin9999,
    'g3_p1_t2': _additionWithin9999,
    'g3_p1_t3': _multiplicationTables10,
    'g3_p1_t4': _divisionWithin10,
    // Grade 4
    'g4_p1_t1': _expandedWithinMillions,
    'g4_p1_t2': _additionWithin999999,
    'g4_p1_t3': _rounding,
    'g4_p2_t1': _multiplicationLarge,
    'g4_p2_t2': _divisionLong,
    // Grade 5
    'g5_p1_t1': _primeCheck,
    'g5_p1_t2': _gcfOrLcm,
    'g5_p2_t4': _perimeterArea,
    // Grade 6
    'g6_p2_t3': _volume,
    // Grade 7
    'g7_p1_t1': _absoluteOrSignedCompare,
    'g7_p1_t2': _signedAddSub,
    'g7_p1_t3': _signedMulDiv,
    'g7_p1_t4': _expressionEvaluation,
    'g7_p2_t1': _linearEquation,
    // Grade 8
    'g8_p1_t1': _rootQuestion,
    'g8_p2_t1': _pythagoras,
    // Grade 9
    // Grade 9
    'g9_p1_t3': _linearSystem,
    'g9_p1_t4': _quadraticRoot,
    // Full-book coverage: every remaining seed topic is exam-able.
    'g1_p2_t5': _shapeFacts,
    'g2_p2_t3': _simpleUnits,
    'g2_p2_t4': _solidFacts,
    'g3_p2_t1': _wordProblem,
    'g3_p2_t2': _simpleFractions,
    'g3_p2_t3': _equivalentFractions,
    'g3_p2_t4': _likeFractionOps,
    'g4_p2_t3': _anglesPolygons,
    'g4_p2_t4': _unitConversions,
    'g4_p2_t5': _grade4Fractions,
    'g5_p1_t3': _unlikeFractionOps,
    'g5_p2_t1': _fractionMulDiv,
    'g5_p2_t2': _decimalOps,
    'g5_p2_t3': _ratioPercent,
    'g6_p1_t1': _advancedFractionDecimal,
    'g6_p1_t2': _unitRates,
    'g6_p1_t3': _proportions,
    'g6_p2_t1': _percentApplications,
    'g6_p2_t2': _circleMeasure,
    'g6_p2_t4': _basicStatistics,
    'g7_p2_t2': _anglePairs,
    'g7_p2_t3': _congruenceFacts,
    'g7_p2_t4': _basicStatistics,
    'g8_p1_t2': _rootSimplify,
    'g8_p1_t3': _factorCommon,
    'g8_p2_t2': _similarityRatio,
    'g8_p2_t3': _circleTheorems,
    'g8_p2_t4': _dispersion,
    'g9_p1_t1': _specialFactoring,
    'g9_p1_t2': _algebraicFractions,
    'g9_p2_t1': _trigBasics,
    'g9_p2_t2': _circleQuadrilateral,
    'g9_p2_t3': _advancedStatistics,
  };

  static Question base({
    required CurriculumTopic topic,
    required QuestionKind kind,
    required List<Object?> tokens,
    required int answer,
    required List<int> choices,
    required Random random,
    required String explanation,
    String? spokenText,
    int index = 0,
    MixedNumberQuestion? mixedNumber,
    FractionOrderQuestion? fractionOrder,
  }) {
    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: kind,
      tokens: tokens,
      correctAnswer: answer,
      choices: choices,
      explanation: explanation,
      factKey: '${topic.id}:$answer',
      spokenText: spokenText,
      topicId: topic.id,
      topicLabel: '${topic.title} (${topic.unitName})',
      mixedNumber: mixedNumber,
      fractionOrder: fractionOrder,
    );
  }

  // ─── Choice helpers ────────────────────────────────────────────────────

  static List<int> _choices(
    int answer,
    Random random, {
    List<int> candidates = const [],
  }) {
    final values = <int>{answer};
    final pool = candidates.where((value) => value != answer).toList()
      ..shuffle(random);
    for (final candidate in pool) {
      if (values.length >= 4) break;
      values.add(candidate);
    }
    var offset = 1;
    var guard = 0;
    while (values.length < 4 && guard < 200) {
      final candidate = answer + (offset.isEven ? offset : -offset);
      if (!values.contains(candidate)) values.add(candidate);
      offset++;
      guard++;
    }
    return values.toList(growable: false)..shuffle(random);
  }

  static int _swapDigits(int number, Random random) {
    final digits = '$number'.split('');
    if (digits.length < 2) return number + 1;
    final a = random.nextInt(digits.length);
    var b = random.nextInt(digits.length);
    while (b == a) {
      b = random.nextInt(digits.length);
    }
    final tmp = digits[a];
    digits[a] = digits[b];
    digits[b] = tmp;
    return int.tryParse(digits.join()) ?? number;
  }

  // ─── Grade 1 ───────────────────────────────────────────────────────────

  static Question _numberWordsWithin9(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final number = _rand(random, 0, 9);
    final words = ArabicNumberWords.formatOrClamp(number, max: 99);
    return base(
      topic: topic,
      kind: QuestionKind.numberWords,
      tokens: ['العدد', 'بالكلمات:', words],
      answer: number,
      choices: _choices(number, random,
          candidates: [0, 5, number + 1, number + 2, 9 - number]),
      random: random,
      explanation:
          'العدد «$words» يُكتب بالأرقام: ${ArabicNumbers.formatInt(number)}',
      spokenText: 'أي عددي بالأرقام يوافق «$words»؟',
      index: index,
    );
  }

  static Question _compareWithin9(
    CurriculumTopic t,
    TopicEnvelope env,
    Random random,
    int index,
  ) =>
      _compareNums(0, 9, random, t, index);

  static Question _compareWithin99(
    CurriculumTopic t,
    TopicEnvelope env,
    Random random,
    int index,
  ) =>
      _compareNums(10, 99, random, t, index);

  static Question _compareWithin999(
    CurriculumTopic t,
    TopicEnvelope env,
    Random random,
    int index,
  ) =>
      _compareNums(100, 999, random, t, index);

  static Question _compareNums(
    int min,
    int max,
    Random random,
    CurriculumTopic topic,
    int index,
  ) {
    final first = _rand(random, min, max);
    int second;
    do {
      second = _rand(random, min, max);
    } while (second == first);
    final askLarger = random.nextBool();
    final answer = askLarger
        ? (first > second ? first : second)
        : (first < second ? first : second);
    final prompt = askLarger ? 'أيهما أكبر؟' : 'أيهما أصغر؟';
    return base(
      topic: topic,
      kind: QuestionKind.compareNumbers,
      tokens: [prompt, first, 'و', second],
      answer: answer,
      choices: _choices(
        answer,
        random,
        candidates: [first, second, answer + 1, answer - 1],
      ),
      random: random,
      explanation:
          '$prompt ${ArabicNumbers.formatInt(first)} و${ArabicNumbers.formatInt(second)} — ${askLarger ? 'الأكبر' : 'الأصغر'} هو ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          '$prompt ${ArabicNumbers.formatInt(first)} أم ${ArabicNumbers.formatInt(second)}؟',
      index: index,
    );
  }

  static Question _additionWithin9(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 1, 8);
    final second = _rand(random, 1, 9 - first);
    return _additionCore(topic, first, second, random, index);
  }

  static Question _additionWithin99(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 10, 98);
    final second = _rand(random, 10, 98);
    return _additionCore(topic, first, second, random, index);
  }

  static Question _additionWithin999(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 100, 899);
    final second = _rand(random, 100, 899);
    return _additionCore(topic, first, second, random, index);
  }

  static Question _additionWithin9999(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 1000, 8999);
    final second = _rand(random, 1000, 8999);
    return _additionCore(topic, first, second, random, index);
  }

  static Question _additionWithin999999(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 1000, 499999);
    final second = _rand(random, 1000, 499999);
    return _additionCore(topic, first, second, random, index);
  }

  static Question _additionBuilder(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, env.min, env.max ~/ 2 + 1);
    final second = _rand(random, env.min, env.max ~/ 2 + 1);
    return _additionCore(topic, first, second, random, index);
  }

  static Question _additionCore(
    CurriculumTopic topic,
    int first,
    int second,
    Random random,
    int index,
  ) {
    final answer = first + second;
    return base(
      topic: topic,
      kind: QuestionKind.addition,
      tokens: [first, '+', second, '=', null],
      answer: answer,
      choices: _choices(answer, random,
          candidates: [answer + 1, answer - 1, answer + 10, answer - 10]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(first)} + ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(first)} زائد ${ArabicNumbers.formatInt(second)}؟',
      index: index,
    );
  }

  static Question _subtractionWithin9(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 1, 9);
    final second = _rand(random, 1, first);
    return _subtractionCore(topic, first, second, random, index);
  }

  static Question _subtractionWithin999(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 200, 999);
    final second = _rand(random, 10, 199);
    return _subtractionCore(topic, first, second, random, index);
  }

  static Question _subtractionCore(
    CurriculumTopic topic,
    int first,
    int second,
    Random random,
    int index,
  ) {
    final answer = first - second;
    return base(
      topic: topic,
      kind: QuestionKind.subtraction,
      tokens: [first, '−', second, '=', null],
      answer: answer,
      choices: _choices(answer, random,
          candidates: [answer + 1, answer - 1, answer + 10, answer - 10]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(first)} − ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(first)} ناقص ${ArabicNumbers.formatInt(second)}؟',
      index: index,
    );
  }

  static Question _placeValueTens(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final number = _rand(random, 10, 99);
    if (random.nextBool()) {
      final words = ArabicNumberWords.formatOrClamp(number, max: 99);
      return base(
        topic: topic,
        kind: QuestionKind.numberWords,
        tokens: ['العدد', 'بالكلمات:', words],
        answer: number,
        choices: _choices(number, random, candidates: [
          _swapDigits(number, random),
          number + 10,
          number - 10
        ]),
        random: random,
        explanation:
            'العدد «$words» يُكتب بالأرقام: ${ArabicNumbers.formatInt(number)}',
        spokenText: 'اقرأ العدد المكتوب بالكلمات ثم اختر الرقم المناسب: $words',
        index: index,
      );
    }
    final tens = number ~/ 10;
    final ones = number % 10;
    return base(
      topic: topic,
      kind: QuestionKind.placeValueSplit,
      tokens: ['كم', 'عدد', 'العشرات', 'في', number, '؟'],
      answer: tens,
      choices: _choices(tens, random, candidates: [ones, tens + 1, ones + 1]),
      random: random,
      explanation:
          'في ${ArabicNumbers.formatInt(number)}: ${ArabicNumbers.formatInt(tens)} عشرات و${ArabicNumbers.formatInt(ones)} آحاد',
      spokenText: 'كم عدد العشرات في العدد ${ArabicNumbers.formatInt(number)}؟',
      index: index,
    );
  }

  static Question _expandedForRange(
    CurriculumTopic topic,
    int min,
    int max,
    Random random,
    int index,
  ) {
    final number = _rand(random, min, max);
    final parts = <int>[];
    var remaining = number;
    var place = 1;
    while (remaining > 0) {
      final digit = remaining % 10;
      remaining ~/= 10;
      if (digit > 0) {
        parts.insert(0, digit * place);
      }
      place *= 10;
    }
    if (parts.isEmpty) parts.add(number);
    final tokens = <Object?>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) tokens.add('+');
      tokens.add(parts[i]);
    }
    tokens.add('=');
    tokens.add(null);
    final partText =
        parts.map((part) => ArabicNumbers.formatInt(part)).join(' + ');
    return base(
      topic: topic,
      kind: QuestionKind.expandedForm,
      tokens: tokens,
      answer: number,
      choices: _choices(number, random, candidates: [
        _swapDigits(number, random),
        number + 100,
        if (number - 100 > min) number - 100,
      ]),
      random: random,
      explanation:
          'صورة العدد ${ArabicNumbers.formatInt(number)} الموسّعة: $partText',
      spokenText: 'ما العدد الذي صورته الموسّعة هي: $partText؟',
      index: index,
    );
  }

  static Question _expandedWithin999(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) =>
      _expandedForRange(topic, 105, 998, random, index);

  static Question _expandedWithin9999(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) =>
      _expandedForRange(topic, 1005, 9998, random, index);

  static Question _expandedWithinMillions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) =>
      _expandedForRange(topic, 10005, 99998, random, index);

  // ─── Multiplication / division ─────────────────────────────────────────

  static Question _multiplicationTables5(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 2, 5);
    final second = _rand(random, 2, 9);
    return _multiplicationCore(topic, first, second, random, index);
  }

  static Question _multiplicationTables10(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 2, 10);
    final second = _rand(random, 2, 10);
    return _multiplicationCore(topic, first, second, random, index);
  }

  static Question _multiplicationLarge(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first = _rand(random, 11, 99);
    final second = _rand(random, 2, 9);
    return _multiplicationCore(topic, first, second, random, index);
  }

  static Question _multiplicationCore(
    CurriculumTopic topic,
    int first,
    int second,
    Random random,
    int index,
  ) {
    final answer = first * second;
    return base(
      topic: topic,
      kind: QuestionKind.multiplicationResult,
      tokens: [first, '×', second, '=', null],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + first,
        answer - first,
        answer + 10,
        answer - 10
      ]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(first)} × ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(first)} ضرب ${ArabicNumbers.formatInt(second)}؟',
      index: index,
    );
  }

  static Question _divisionWithin5(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final divisor = _rand(random, 2, 5);
    final quotient = _rand(random, 2, 10);
    return _divisionCore(topic, divisor, quotient, random, index);
  }

  static Question _divisionWithin10(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final divisor = _rand(random, 2, 10);
    final quotient = _rand(random, 2, 10);
    return _divisionCore(topic, divisor, quotient, random, index);
  }

  static Question _divisionLong(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final divisor = _rand(random, 2, 12);
    final quotient = _rand(random, 12, 50);
    return _divisionCore(topic, divisor, quotient, random, index);
  }

  static Question _divisionCore(
    CurriculumTopic topic,
    int divisor,
    int quotient,
    Random random,
    int index,
  ) {
    final dividend = divisor * quotient;
    return base(
      topic: topic,
      kind: QuestionKind.divisionQuotient,
      tokens: [dividend, '÷', divisor, '=', null],
      answer: quotient,
      choices: _choices(quotient, random,
          candidates: [quotient + 1, quotient - 1, quotient + 2, quotient - 2]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(dividend)} ÷ ${ArabicNumbers.formatInt(divisor)} = ${ArabicNumbers.formatInt(quotient)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(dividend)} مقسومًا على ${ArabicNumbers.formatInt(divisor)}؟',
      index: index,
    );
  }

  // ─── Rounding ──────────────────────────────────────────────────────────

  static Question _rounding(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final number = _rand(random, 150, 9999);
    const places = [10, 100, 1000];
    final allowed = places.where((place) => place < number ~/ 4).toList();
    final place = allowed.isEmpty
        ? places.first
        : allowed[random.nextInt(allowed.length)];
    final rounded = (number / place).round() * place;
    final label = switch (place) {
      10 => 'عشرة',
      100 => 'مئة',
      1000 => 'ألف',
      _ => '$place',
    };
    return base(
      topic: topic,
      kind: QuestionKind.rounding,
      tokens: ['إلى أقرب $label:', number, '≈', null],
      answer: rounded,
      choices: _choices(rounded, random, candidates: [
        rounded + place,
        rounded - place > 0 ? rounded - place : rounded + place,
        number,
        rounded + 1,
      ]),
      random: random,
      explanation:
          'تقريب ${ArabicNumbers.formatInt(number)} إلى أقرب $label يعطي ${ArabicNumbers.formatInt(rounded)}',
      spokenText:
          'قرّب العدد ${ArabicNumbers.formatInt(number)} إلى أقرب $label',
      index: index,
    );
  }

  // ─── Grade 5: primes & GCF/LCM ─────────────────────────────────────────

  static bool _isPrime(int number) {
    if (number < 2) return false;
    for (var i = 2; i * i <= number; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  static Question _primeCheck(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    int prime;
    do {
      prime = _rand(random, 11, 97);
    } while (!_isPrime(prime));
    final composites = <int>{};
    var guard = 0;
    while (composites.length < 3 && guard < 200) {
      final candidate = _rand(random, 12, 99);
      guard++;
      if (!_isPrime(candidate)) composites.add(candidate);
    }
    final deck = [prime, ...composites.take(3)];
    deck.shuffle(random);
    return base(
      topic: topic,
      kind: QuestionKind.primeCheck,
      tokens: ['أي', 'من', 'الأعداد', 'التالية', 'عدد', 'أولي؟'],
      answer: prime,
      choices: deck.take(4).toList(growable: false),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(prime)} عدد أولي لأنه لا يقبل القسمة إلا على 1 وعلى نفسه.',
      spokenText: 'أي من الأعداد التالية عدد أولي؟',
      index: index,
    );
  }

  static int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b > 0) {
      final t = a % b;
      a = b;
      b = t;
    }
    return a;
  }

  static int _computeLcm(int a, int b) {
    final shared = _gcd(a, b);
    if (shared == 0) return 0;
    return a ~/ shared * b;
  }

  static Question _gcfOrLcm(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final askGcf = random.nextBool();
    final a = _rand(random, 6, 48);
    int b;
    do {
      b = _rand(random, 6, 48);
    } while (b == a);
    final answer = askGcf ? _gcd(a, b) : _computeLcm(a, b);
    final wrongs = askGcf
        ? [
            _computeLcm(a, b),
            _gcd(a, b) + 2,
            _gcd(a + 1, b) + 1,
          ]
        : [
            _gcd(a, b),
            _computeLcm(a, b) ~/ 2 > 1
                ? _computeLcm(a, b) ~/ 2
                : _computeLcm(a, b) + 2,
            a * b,
          ];
    final tokens = <String>[
      askGcf ? 'ق.م.أ' : 'م.م.أ',
      'للعددين',
    ];
    return base(
      topic: topic,
      kind: QuestionKind.gcfLcm,
      tokens: [...tokens, a, 'و', b, '=', null],
      answer: answer,
      choices: _choices(answer, random, candidates: wrongs),
      random: random,
      explanation:
          '${askGcf ? 'ق.م.أ' : 'م.م.أ'} للعددين ${ArabicNumbers.formatInt(a)} و${ArabicNumbers.formatInt(b)} هو ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'ما ${askGcf ? 'القاسم المشترك الأكبر' : 'المضاعف المشترك الأصغر'} للعددين ${ArabicNumbers.formatInt(a)} و${ArabicNumbers.formatInt(b)}؟',
      index: index,
    );
  }

  // ─── Geometry / volume ─────────────────────────────────────────────────

  static Question _perimeterArea(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final askArea = random.nextBool();
    final isSquare = random.nextBool();
    final width = _rand(random, 2, 19);
    final height = isSquare ? width : _rand(random, 2, 19);
    final answer = askArea ? width * height : 2 * (width + height);
    final shape = isSquare ? 'مربع' : 'مستطيل';
    final sides = isSquare
        ? 'طول ضلعه ${ArabicNumbers.formatInt(width)}'
        : 'طوله ${ArabicNumbers.formatInt(width)} وعرضه ${ArabicNumbers.formatInt(height)}';
    final request = askArea ? 'أوجد مساحته' : 'أوجد محيطه';
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: [shape, sides, '—', request],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        askArea ? 2 * (width + height) : width * height,
        width * 2 + height,
        answer + width > 0 ? answer + width : answer + height,
      ]),
      random: random,
      explanation: askArea
          ? 'المساحة = الطول × العرض = ${ArabicNumbers.formatInt(width)} × ${ArabicNumbers.formatInt(height)} = ${ArabicNumbers.formatInt(answer)}'
          : 'المحيط = 2 × (الطول + العرض) = ${ArabicNumbers.formatInt(answer)}',
      spokenText: '$shape $sides، طلب: $request',
      index: index,
    );
  }

  static Question _volume(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final isCube = random.nextBool();
    final a = _rand(random, 2, 9);
    if (isCube) {
      final answer = a * a * a;
      return base(
        topic: topic,
        kind: QuestionKind.geometryMeasure,
        tokens: ['حجم', 'مكعب', 'طول', 'حرفه', a, '؟'],
        answer: answer,
        choices: _choices(answer, random,
            candidates: [a * a, answer + a, (answer ~/ 2) + 1]),
        random: random,
        explanation:
            'الحجم = الحرف³ = ${ArabicNumbers.formatInt(a)}³ = ${ArabicNumbers.formatInt(answer)}',
        spokenText: 'ما حجم مكعب طول حرفه ${ArabicNumbers.formatInt(a)}؟',
        index: index,
      );
    }
    final b = _rand(random, 2, 9);
    final c = _rand(random, 2, 9);
    final answer = a * b * c;
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: ['حجم', 'متوازي', 'أبعاده', a, 'و', b, 'و', c, '؟'],
      answer: answer,
      choices: _choices(answer, random,
          candidates: [a * b * c + a, a * b + c, a + b + c]),
      random: random,
      explanation:
          'الحجم = الطول × العرض × الارتفاع = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'ما حجم متوازي المستطيلات أبعاده ${ArabicNumbers.formatInt(a)} و${ArabicNumbers.formatInt(b)} و${ArabicNumbers.formatInt(c)}؟',
      index: index,
    );
  }

  // ─── Grade 7: integers & algebra ───────────────────────────────────────

  static Question _absoluteOrSignedCompare(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    if (random.nextBool()) {
      final value = _rand(random, 1, 12);
      final negative = random.nextBool();
      final shown = negative ? -value : value;
      return base(
        topic: topic,
        kind: QuestionKind.absoluteValue,
        tokens: ['ما', 'القيمة', 'المطلقة', 'للعدد', shown, '؟'],
        answer: value,
        choices:
            _choices(value, random, candidates: [-value, value + 1, value + 2]),
        random: random,
        explanation:
            'القيمة المطلقة للعدد ${ArabicNumbers.formatInt(shown)} هي ${ArabicNumbers.formatInt(value)}',
        spokenText:
            'ما القيمة المطلقة للعدد ${ArabicNumbers.formatInt(shown)}؟',
        index: index,
      );
    }
    final first = -_rand(random, 1, 12);
    final second =
        random.nextBool() ? -_rand(random, 1, 12) : _rand(random, 1, 12);
    final askLarger = random.nextBool();
    final answer = askLarger
        ? (first > second ? first : second)
        : (first < second ? first : second);
    return base(
      topic: topic,
      kind: QuestionKind.compareNumbers,
      tokens: ['أيهما أكبر؟', first, 'و', second],
      answer: answer,
      choices: _choices(answer, random,
          candidates: [first, second, answer + 1, answer - 1]),
      random: random,
      explanation:
          'على خط الأعداد الأكبر هو الطرف الأيمن: ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'أيهما أكبر: ${ArabicNumbers.formatInt(first)} أم ${ArabicNumbers.formatInt(second)}؟',
      index: index,
    );
  }

  static Question _signedAddSub(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final first =
        random.nextBool() ? -_rand(random, 2, 15) : _rand(random, 2, 15);
    final second =
        random.nextBool() ? -_rand(random, 1, 15) : _rand(random, 1, 15);
    final isAdd = random.nextBool();
    final answer = isAdd ? first + second : first - second;
    final opText = isAdd ? '+' : '−';
    return base(
      topic: topic,
      kind: isAdd ? QuestionKind.addition : QuestionKind.subtraction,
      tokens: [first, opText, second, '=', null],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        isAdd ? first - second : first + second,
        -answer,
        answer + 2,
      ]),
      random: random,
      explanation:
          'بتطبيق قواعد الإشارات: ${ArabicNumbers.formatInt(first)} ${isAdd ? '+' : '−'} ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(first)} ${isAdd ? 'زائد' : 'ناقص'} ${ArabicNumbers.formatInt(second)}؟',
      index: index,
    );
  }

  static Question _signedMulDiv(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    if (random.nextBool()) {
      final a = random.nextBool() ? -_rand(random, 2, 9) : _rand(random, 2, 9);
      final b = random.nextBool() ? -_rand(random, 2, 9) : _rand(random, 2, 9);
      final answer = a * b;
      return base(
        topic: topic,
        kind: QuestionKind.multiplicationResult,
        tokens: [a, '×', b, '=', null],
        answer: answer,
        choices: _choices(answer, random,
            candidates: [-answer, answer - a, answer + b]),
        random: random,
        explanation:
            'إشارة الناتج: موجب عند تساوي الإشارتين وسالب عند اختلافهما؛ الناتج ${ArabicNumbers.formatInt(answer)}',
        spokenText:
            'كم يساوي ${ArabicNumbers.formatInt(a)} ضرب ${ArabicNumbers.formatInt(b)}؟',
        index: index,
      );
    }
    final b = random.nextBool() ? -_rand(random, 2, 9) : _rand(random, 2, 9);
    final quotient =
        random.nextBool() ? -_rand(random, 2, 9) : _rand(random, 2, 9);
    final a = b * quotient;
    return base(
      topic: topic,
      kind: QuestionKind.divisionQuotient,
      tokens: [a, '÷', b, '=', null],
      answer: quotient,
      choices: _choices(quotient, random,
          candidates: [-quotient, quotient + 1, quotient - 2]),
      random: random,
      explanation: 'الناتج: ${ArabicNumbers.formatInt(quotient)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(a)} مقسومًا على ${ArabicNumbers.formatInt(b)}؟',
      index: index,
    );
  }

  static Question _expressionEvaluation(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final coeffA = _rand(random, 2, 6);
    final constant = _rand(random, 1, 12);
    final value = _rand(random, 1, 9);
    final answer = coeffA * value + constant;
    return base(
      topic: topic,
      kind: QuestionKind.evaluateExpression,
      tokens: ['إذا', 'س =', value, 'فأوجد', coeffA, 'س +', constant],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        coeffA * value + constant + value,
        coeffA + constant,
        answer - value > 0 ? answer - value : answer + value,
      ]),
      random: random,
      explanation:
          'بعد التعويض س = ${ArabicNumbers.formatInt(value)}: ${ArabicNumbers.formatInt(coeffA)} × ${ArabicNumbers.formatInt(value)} + ${ArabicNumbers.formatInt(constant)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'إذا كان س يساوي ${ArabicNumbers.formatInt(value)} فأوجد قيمة ${ArabicNumbers.formatInt(coeffA)} س زائد ${ArabicNumbers.formatInt(constant)}',
      index: index,
    );
  }

  static Question _linearEquation(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final x = _rand(random, 1, 9);
    final a = _rand(random, 2, 6);
    final b = _rand(random, 1, 12);
    final c = a * x + b;
    return base(
      topic: topic,
      kind: QuestionKind.solveLinearEquation,
      tokens: [a, 'س +', b, '=', c, '؛ أوجد', 'س'],
      answer: x,
      choices: _choices(x, random, candidates: [
        x + 1,
        x - 1 > 0 ? x - 1 : x + 2,
        c ~/ b > 0 ? c ~/ b : c
      ]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(a)}س = ${ArabicNumbers.formatInt(c - b)} إذًا س = ${ArabicNumbers.formatInt(x)}',
      spokenText:
          'إذا كان ${ArabicNumbers.formatInt(a)} س زائد ${ArabicNumbers.formatInt(b)} يساوي ${ArabicNumbers.formatInt(c)} فأوجد قيمة س',
      index: index,
    );
  }

  static Question _linearSystem(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final x = _rand(random, 1, 6);
    final y = _rand(random, 1, 6);
    final a1 = _rand(random, 1, 4);
    final b1 = _rand(random, 1, 4);
    final c1 = a1 * x + b1 * y;
    final a2 = _rand(random, 1, 4);
    final b2 = _rand(random, 1, 4);
    final c2 = a2 * x + b2 * y;
    return base(
      topic: topic,
      kind: QuestionKind.linearSystem,
      tokens: [
        'منظام:',
        a1,
        'س +',
        b1,
        'ص =',
        c1,
        '،',
        a2,
        'س +',
        b2,
        'ص =',
        c2,
        '؛ أوجد',
        'س',
      ],
      answer: x,
      choices: _choices(x, random, candidates: [y, x + 1, x + y]),
      random: random,
      explanation:
          'حل المنظام: س = ${ArabicNumbers.formatInt(x)} و ص = ${ArabicNumbers.formatInt(y)}',
      spokenText: 'أوجد قيمة س في المنظام المعطى',
      index: index,
    );
  }

  static Question _quadraticRoot(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    // x² − (r+s)x + rs = 0 with integer roots r and s.
    final r = _rand(random, 1, 8);
    final s = _rand(random, 1, 8);
    final b = r + s;
    final c = r * s;
    return base(
      topic: topic,
      kind: QuestionKind.quadraticRoot,
      tokens: ['أحد', 'حلّي', 'المعادلة', 'س² −', b, 'س +', c, '= 0'],
      answer: r,
      choices: _choices(r, random, candidates: [s, r + s, -r]),
      random: random,
      explanation:
          'بالتحليل: (س − ${ArabicNumbers.formatInt(r)})(س − ${ArabicNumbers.formatInt(s)}) = 0 فالحلّان هما ${ArabicNumbers.formatInt(r)} و${ArabicNumbers.formatInt(s)}',
      spokenText: 'أوجد أحد حلّي المعادلة التربيعية المسقطة',
      index: index,
    );
  }

  // ─── Grade 8 ───────────────────────────────────────────────────────────

  static Question _rootQuestion(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    if (random.nextBool()) {
      final n = _rand(random, 3, 20);
      final square = n * n;
      return base(
        topic: topic,
        kind: QuestionKind.squareRoot,
        tokens: ['ما', 'الجذر', 'التربيعي', 'للعدد', square, '؟'],
        answer: n,
        choices: _choices(n, random, candidates: [n + 1, n - 1, n + 2]),
        random: random,
        explanation:
            'لأن ${ArabicNumbers.formatInt(n)} × ${ArabicNumbers.formatInt(n)} = ${ArabicNumbers.formatInt(square)}',
        spokenText:
            'ما الجذر التربيعي للعدد ${ArabicNumbers.formatInt(square)}؟',
        index: index,
      );
    }
    final n = _rand(random, 2, 10);
    final cube = n * n * n;
    return base(
      topic: topic,
      kind: QuestionKind.cubeRoot,
      tokens: ['ما', 'الجذر', 'التكعيبي', 'للعدد', cube, '؟'],
      answer: n,
      choices: _choices(n, random, candidates: [n + 1, n - 1, n + 2]),
      random: random,
      explanation:
          'لأن ${ArabicNumbers.formatInt(n)}³ = ${ArabicNumbers.formatInt(cube)}',
      spokenText: 'ما الجذر التكعيبي للعدد ${ArabicNumbers.formatInt(cube)}؟',
      index: index,
    );
  }

  static Question _pythagoras(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const triples = [
      [3, 4, 5],
      [6, 8, 10],
      [5, 12, 13],
      [9, 12, 15],
      [8, 15, 17],
      [7, 24, 25],
    ];
    final triple = triples[random.nextInt(triples.length)];
    if (random.nextBool()) {
      final legIndex = random.nextInt(2);
      final otherLeg = triple[legIndex == 0 ? 1 : 0];
      return base(
        topic: topic,
        kind: QuestionKind.pythagoras,
        tokens: [
          'مثلث',
          'قائم',
          'ساقاه',
          triple[legIndex],
          'و',
          otherLeg,
          '؛ أوجد',
          'الوتر',
        ],
        answer: triple[2],
        choices: _choices(triple[2], random, candidates: [
          triple[legIndex] + otherLeg,
          triple[2] + 1,
          triple[2] - 1,
        ]),
        random: random,
        explanation:
            'الوتر = √(ساق² + ساق²) = ${ArabicNumbers.formatInt(triple[2])}',
        spokenText:
            'في مثلث قائم الساقان ${ArabicNumbers.formatInt(triple[legIndex])} و${ArabicNumbers.formatInt(otherLeg)}؛ أوجد الوتر',
        index: index,
      );
    }
    final leg = triple[0];
    final hypotenuse = triple[2];
    final otherLeg = triple[1];
    return base(
      topic: topic,
      kind: QuestionKind.pythagoras,
      tokens: [
        'الوتر',
        hypotenuse,
        'و',
        'إحدى',
        'الساقين',
        leg,
        '؛ أوجد',
        'الساق',
        'الأخرى',
      ],
      answer: otherLeg,
      choices: _choices(otherLeg, random, candidates: [
        hypotenuse - leg,
        otherLeg + 1,
        leg,
      ]),
      random: random,
      explanation:
          'الساق الأخرى = √(وتر² − ساق²) = ${ArabicNumbers.formatInt(otherLeg)}',
      spokenText:
          'الوتر ${ArabicNumbers.formatInt(hypotenuse)} وإحدى الساقين ${ArabicNumbers.formatInt(leg)}؛ أوجد الساق الأخرى',
      index: index,
    );
  }

  // ─── Full-book coverage: shapes & solids ─────────────────────────────

  static Question _shapeFacts(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const facts = [
      ('مثلث', 3, 'أضلاع'),
      ('مربع', 4, 'أضلاع'),
      ('مستطيل', 4, 'أضلاع'),
      ('دائرة', 0, 'أضلاع'),
    ];
    final fact = facts[random.nextInt(facts.length)];
    return base(
      topic: topic,
      kind: QuestionKind.shapeFacts,
      tokens: ['كم ${fact.$3}؟', fact.$1],
      answer: fact.$2,
      choices: _choices(fact.$2, random, candidates: [3, 4, 5, 2]),
      random: random,
      explanation:
          '${fact.$1}: عدد ${fact.$3} = ${ArabicNumbers.formatInt(fact.$2)}',
      spokenText: 'كم ${fact.$3} ${fact.$1}؟',
      index: index,
    );
  }

  static Question _solidFacts(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const facts = [
      ('مكعب', 'أوجه', 6),
      ('مكعب', 'حروف', 12),
      ('مكعب', 'رؤوس', 8),
      ('أسطوانة', 'أوجه', 3),
      ('كره', 'وجه', 1),
    ];
    final fact = facts[random.nextInt(facts.length)];
    return base(
      topic: topic,
      kind: QuestionKind.shapeFacts,
      tokens: ['كم', fact.$2, 'لـ', fact.$1, '؟'],
      answer: fact.$3,
      choices: _choices(fact.$3, random, candidates: [4, 6, 8, 12, 3]),
      random: random,
      explanation:
          '${fact.$1}: عدد ${fact.$2} = ${ArabicNumbers.formatInt(fact.$3)}',
      spokenText: 'كم ${fact.$2} ${fact.$1}؟',
      index: index,
    );
  }

  // ─── Full-book coverage: units & word problems ──────────────────────

  static const _simpleUnitFacts = [
    ('متر', 'سنتيمتراً', 100),
    ('ساعة', 'دقيقة', 60),
    ('يوم', 'ساعة', 24),
    ('أسبوع', 'يوماً', 7),
  ];

  static Question _simpleUnits(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final fact = _simpleUnitFacts[random.nextInt(_simpleUnitFacts.length)];
    return base(
      topic: topic,
      kind: QuestionKind.unitConversion,
      tokens: ['كم', fact.$2, 'في', 'واحد', fact.$1, '؟'],
      answer: fact.$3,
      choices: _choices(fact.$3, random, candidates: [
        fact.$3 * 2,
        fact.$3 ~/ 2 > 0 ? fact.$3 ~/ 2 : fact.$3 + 1,
        fact.$3 + 10,
      ]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(1)} ${fact.$1} = ${ArabicNumbers.formatInt(fact.$3)} ${fact.$2}',
      spokenText: 'كم ${fact.$2} في ${fact.$1} واحد؟',
      index: index,
    );
  }

  static Question _unitConversions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final fact = _simpleUnitFacts[random.nextInt(_simpleUnitFacts.length)];
    final multiplier = _rand(random, 2, 9);
    final answer = fact.$3 * multiplier;
    return base(
      topic: topic,
      kind: QuestionKind.unitConversion,
      tokens: ['كم', fact.$2, 'في', multiplier, fact.$1, '؟'],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + fact.$3,
        answer > fact.$3 ? answer - fact.$3 : answer + fact.$3,
        answer * 2,
      ]),
      random: random,
      explanation:
          '${ArabicNumbers.formatInt(multiplier)} ${fact.$1} × ${ArabicNumbers.formatInt(fact.$3)} ${fact.$2} = ${ArabicNumbers.formatInt(answer)} ${fact.$2}',
      spokenText:
          'كم ${fact.$2} في ${ArabicNumbers.formatInt(multiplier)} ${fact.$1}؟',
      index: index,
    );
  }

  // ─── Grade 4 Part 2: Fractions (الكسور العادية) ───────────────────────
  //
  // Covers the Yemeni grade-4 part-2 fractions unit:
  //   • like-denominator addition/subtraction
  //   • mixed-number addition/subtraction (no negative results)
  //   • ordering like-denominator fractions (answer = position of a given
  //     fraction in the ascending chain, encoded as a 1-based rank)
  //   • simple fraction word problems
  //
  // Encoding note: ordering questions keep their 1-based rank as the integer
  // answer; visual fraction questions attach a `MixedNumberQuestion` payload
  // (whole == 0 for plain fractions) and use the generated choice index.

  static Question _grade4Fractions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final variant = random.nextInt(4);
    switch (variant) {
      case 0:
        return _likeFracAddSub(topic, random, index, add: true);
      case 1:
        return _likeFracAddSub(topic, random, index, add: false);
      case 2:
        return _mixedNumberAddSub(topic, random, index);
      default:
        return _fractionOrder(topic, random, index);
    }
  }

  /// a/d ± b/d with like denominators. Uses the visual fraction generator so
  /// the prompt and the four choices render with real fraction bars.
  static Question _likeFracAddSub(
    CurriculumTopic topic,
    Random random,
    int index, {
    required bool add,
  }) {
    final generated = MixedNumberGenerator(
      random: random,
    ).generateLikeFractionQuestion(add: add);
    final question = base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [generated.questionText],
      answer: generated.correctIndex,
      choices: List<int>.generate(
        generated.choices.length,
        (choiceIndex) => choiceIndex,
      ),
      random: random,
      explanation: generated.explanation,
      spokenText: generated.spokenText,
      index: index,
      mixedNumber: generated,
    );
    return question.copyWith(
      factKey: '${topic.id}:${generated.correctAnswer.toArabicString()}',
    );
  }

  /// Mixed numbers: uses [MixedNumberGenerator] so the question, its four
  /// visual choices, and the correct-answer index all come from one source.
  static Question _mixedNumberAddSub(
    CurriculumTopic topic,
    Random random,
    int index,
  ) {
    final generated = MixedNumberGenerator(random: random).generateQuestion();
    final question = base(
      topic: topic,
      kind: QuestionKind.mixedNumber,
      tokens: [generated.questionText],
      answer: generated.correctIndex,
      choices: List<int>.generate(
        generated.choices.length,
        (choiceIndex) => choiceIndex,
      ),
      random: random,
      explanation: generated.explanation,
      spokenText: generated.spokenText,
      index: index,
      mixedNumber: generated,
    );
    return question.copyWith(
      factKey: '${topic.id}:${generated.correctAnswer.toArabicString()}',
    );
  }

  /// Ordering: 4 like-denominator fractions; the answer is the 1-based rank
  /// of a highlighted fraction in ascending order (1..4). Uses the visual
  /// generator so the prompt renders with real fraction bars.
  static Question _fractionOrder(
    CurriculumTopic topic,
    Random random,
    int index,
  ) {
    final generated = FractionOrderGenerator(random: random).generate();
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [generated.questionText],
      answer: generated.correctRank,
      choices: [1, 2, 3, 4]..shuffle(random),
      random: random,
      explanation: generated.explanation,
      spokenText: generated.spokenText,
      index: index,
      fractionOrder: generated,
    );
  }

  static Question _wordProblem(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final boxes = _rand(random, 2, 6);
    final perBox = _rand(random, 2, 9);
    final answer = boxes * perBox;
    return base(
      topic: topic,
      kind: QuestionKind.wordProblem,
      tokens: [
        '$boxes صناديق وفي كل صندوق $perBox تفاحات؛ كم التفاحات كلها؟',
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + boxes,
        answer - perBox > 0 ? answer - perBox : answer + perBox,
        answer + perBox,
      ]),
      random: random,
      explanation:
          'نضرب: ${ArabicNumbers.formatInt(boxes)} × ${ArabicNumbers.formatInt(perBox)} = ${ArabicNumbers.formatInt(answer)} تفاحة',
      spokenText:
          'في كل صندوق ${ArabicNumbers.formatInt(perBox)} تفاحات، توجد ${ArabicNumbers.formatInt(boxes)} صناديق؛ كم عدد التفاحات؟',
      index: index,
    );
  }

  // ─── Full-book coverage: fractions ────────────────────────────────────

  static Question _simpleFractions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const parts = [
      ('نصف', 2),
      ('ثلث', 3),
      ('ربع', 4),
    ];
    final part = parts[random.nextInt(parts.length)];
    final whole = part.$2 * _rand(random, 2, 12);
    final answer = whole ~/ part.$2;
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: ['ما', part.$1, whole, '؟'],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + part.$2,
        answer > part.$2 ? answer - part.$2 : answer + part.$2,
        whole,
      ]),
      random: random,
      explanation:
          '${part.$1} ${ArabicNumbers.formatInt(whole)} = ${ArabicNumbers.formatInt(whole)} ÷ ${ArabicNumbers.formatInt(part.$2)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText: 'ما ${part.$1} العدد ${ArabicNumbers.formatInt(whole)}؟',
      index: index,
    );
  }

  static Question _equivalentFractions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const base_ = [(1, 2), (2, 3), (3, 4), (1, 5), (2, 5)];
    final pair = base_[random.nextInt(base_.length)];
    final multiplier = _rand(random, 2, 6);
    final targetDenominator = pair.$2 * multiplier;
    final answer = pair.$1 * multiplier;
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [
        '${pair.$1}/${pair.$2}',
        '=',
        '؟ /',
        targetDenominator,
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + multiplier,
        pair.$2,
        targetDenominator,
      ]),
      random: random,
      explanation:
          'كسر متساوي: ${pair.$1}/${pair.$2} = ${ArabicNumbers.formatInt(answer)}/${ArabicNumbers.formatInt(targetDenominator)}',
      spokenText:
          'ما البسط في الكسر المكافئ داخل مقام ${ArabicNumbers.formatInt(targetDenominator)} للكسر ${pair.$1}/${pair.$2}؟',
      index: index,
    );
  }

  static Question _likeFractionOps(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final denominator = _rand(random, 4, 10);
    final first = _rand(random, 1, denominator - 2);
    final second = _rand(random, 1, denominator - first - 1);
    final isAdd = random.nextBool();
    final answer = isAdd
        ? first + second
        : first - second > 0
            ? first - second
            : first + second;
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [
        '$first/$denominator',
        isAdd ? '+' : '−',
        '$second/$denominator',
        '= ? /$denominator',
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + 1,
        denominator,
        answer > 1 ? answer - 2 : answer + 3,
      ]),
      random: random,
      explanation:
          'مقام مشترك ثابت: ($first ${isAdd ? '+' : '−'} $second)/$denominator = $answer/$denominator',
      spokenText: 'أوجد ناتج الكسرين ذوي المقام $denominator (بالمقام نفسه)',
      index: index,
    );
  }

  static Question _unlikeFractionOps(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    // a/b + 1/(b·k): answer numerator with the common denominator b·k.
    final denominator = _rand(random, 2, 6);
    final multiplier = _rand(random, 2, 4);
    final numAnswer = denominator * multiplier - 1 > 0
        ? denominator * multiplier - 1
        : denominator * multiplier + 1;
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [
        '$denominator/$denominator',
        '+',
        '1/${denominator * multiplier}',
        '= ? /${denominator * multiplier}',
      ],
      answer: numAnswer,
      choices: _choices(numAnswer, random, candidates: [
        numAnswer + 1,
        numAnswer - 1 > 0 ? numAnswer - 1 : numAnswer + 2,
        denominator * multiplier,
      ]),
      random: random,
      explanation:
          'توحيد المقامات: $denominator/$denominator = ${denominator * multiplier}/${denominator * multiplier} ثم نجمع',
      spokenText: 'اجمع الكسرين واختر بسط الناتج بمقام موحّد',
      index: index,
    );
  }

  static Question _fractionMulDiv(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final denominatorA = _rand(random, 2, 6);
    final numeratorA = _rand(random, 1, denominatorA - 1);
    if (random.nextBool()) {
      // Division of same-denominator fractions yields an integer.
      final numeratorB = _rand(random, 1, denominatorA - 1);
      if (numeratorB > 0 && numeratorA % numeratorB == 0 ||
          numeratorA > numeratorB && numeratorB < numeratorA) {
        final answer = numeratorA ~/ numeratorB == 0
            ? numeratorA
            : numeratorA ~/ numeratorB;
        return base(
          topic: topic,
          kind: QuestionKind.fractionOps,
          tokens: [
            '$numeratorA/$denominatorA',
            '÷',
            '$numeratorB/$denominatorA',
            '؟'
          ],
          answer: answer,
          choices: _choices(answer, random, candidates: [
            answer + 1,
            answer + 2,
            numeratorA,
          ]),
          random: random,
          explanation:
              'نقسم البسطين والمقامين: ($numeratorA ÷ $numeratorB) = ${ArabicNumbers.formatInt(answer)}',
          spokenText: 'أوجد ناتج قسمة الكسرين المتشابهين',
          index: index,
        );
      }
    }
    // Multiplication: fixed output denominator shows the numerator.
    final denominatorB = _rand(random, 2, 5);
    final numeratorB = _rand(random, 1, denominatorB - 1);
    final outDenominator = denominatorA * denominatorB;
    final answer = numeratorA * numeratorB;
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [
        '$numeratorA/$denominatorA',
        '×',
        '$numeratorB/$denominatorB',
        '= ? /$outDenominator',
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + numeratorA,
        answer + numeratorB,
        answer - 1 > 0 ? answer - 1 : answer + 3,
      ]),
      random: random,
      explanation:
          'الضرب: البسط في البسط والمقام في المقام = $answer/$outDenominator',
      spokenText: 'ناتج ضرب الكسرين (اختر بسط الناتج)',
      index: index,
    );
  }

  // ─── Full-book coverage: percents & ratios ───────────────────────────

  static const _percentRates = [10, 20, 25, 50];

  static Question _ratioPercent(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final rate = _percentRates[random.nextInt(_percentRates.length)];
    final total = 100 * _rand(random, 1, 6) ~/ rate == 0
        ? 100
        : 100 * _rand(random, 1, 6);
    final answer = total ~/ (100 ~/ rate);
    return base(
      topic: topic,
      kind: QuestionKind.percentCalc,
      tokens: ['ما', '$rate%', total, '؟'],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer * 2,
        answer > 10 ? answer ~/ 2 : answer + 5,
        rate,
      ]),
      random: random,
      explanation:
          '$rate% من ${ArabicNumbers.formatInt(total)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'ما ${ArabicNumbers.formatInt(rate)}% من ${ArabicNumbers.formatInt(total)}؟',
      index: index,
    );
  }

  static Question _percentApplications(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final rate = _percentRates[random.nextInt(_percentRates.length)];
    final price = 10 * _rand(random, 4, 40);
    final answer = price ~/ (100 ~/ rate);
    return base(
      topic: topic,
      kind: QuestionKind.percentCalc,
      tokens: ['سعر', price, 'ومقدار', '$rate%', '؛ ما الخصم؟'],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        rate,
        price - answer,
        answer * 2,
      ]),
      random: random,
      explanation:
          'الخصم = $rate% من ${ArabicNumbers.formatInt(price)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'سعر الشيء ${ArabicNumbers.formatInt(price)} والخصم ${ArabicNumbers.formatInt(rate)}%؛ ما مبلغ الخصم؟',
      index: index,
    );
  }

  static Question _unitRates(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final rate = _rand(random, 3, 40);
    final hours = _rand(random, 2, 5);
    final total = rate * hours;
    return base(
      topic: topic,
      kind: QuestionKind.wordProblem,
      tokens: ['معدل الوحدة:', total, 'كم في', hours, 'ساعات؛ كم في ساعة؟'],
      answer: rate,
      choices: _choices(rate, random, candidates: [
        total,
        rate + hours,
        rate > hours ? rate - hours : rate + 2,
      ]),
      random: random,
      explanation:
          'المعدل = ${ArabicNumbers.formatInt(total)} ÷ ${ArabicNumbers.formatInt(hours)} = ${ArabicNumbers.formatInt(rate)} كم/ساعة',
      spokenText:
          'قطعت سيارة ${ArabicNumbers.formatInt(total)} كيلومتراً في ${ArabicNumbers.formatInt(hours)} ساعات؛ كم معدلها في الساعة؟',
      index: index,
    );
  }

  static Question _proportions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final items = _rand(random, 2, 6);
    final each = _rand(random, 2, 12);
    final more = _rand(random, 2, 5);
    final answer = (items + more) * each;
    return base(
      topic: topic,
      kind: QuestionKind.wordProblem,
      tokens: [
        '$items أقلام بـ',
        items * each,
        'ريالاً؛ كم تستهلك',
        items + more,
        'أقلام؟',
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        items * each,
        answer + each,
        answer - each > 0 ? answer - each : answer + each,
      ]),
      random: random,
      explanation:
          'سعر الوحدة = ${ArabicNumbers.formatInt(each)}؛ الناتج = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'إذا كان سعر ${ArabicNumbers.formatInt(items)} أقلام ${ArabicNumbers.formatInt(items * each)} فكم سعر ${ArabicNumbers.formatInt(items + more)} أقلام؟',
      index: index,
    );
  }

  // ─── Full-book coverage: decimals ─────────────────────────────────────

  static Question _decimalOps(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final tenths = _rand(random, 3, 9);
    if (random.nextBool()) {
      return base(
        topic: topic,
        kind: QuestionKind.fractionOps,
        tokens: ['0.', tenths, '× 10 = ?'],
        answer: tenths,
        choices: _choices(tenths, random, candidates: [
          tenths * 10,
          tenths + 1,
          tenths > 1 ? tenths - 1 : tenths + 2,
        ]),
        random: random,
        explanation:
            'الضرب في 10 يحرّك الفاصلة يميناً: 0.$tenths × 10 = ${ArabicNumbers.formatInt(tenths)}',
        spokenText: 'ما ناتج ضرب 0.$tenths في 10؟',
        index: index,
      );
    }
    final other = _rand(random, 1, tenths - 1);
    return base(
      topic: topic,
      kind: QuestionKind.compareNumbers,
      tokens: ['أيهما أكبر: 0.', tenths, 'أم 0.', other, '؟'],
      answer: tenths,
      choices:
          _choices(tenths, random, candidates: [other, tenths + 1, other + 1]),
      random: random,
      explanation: '0.$tenths أكبر من 0.$other (بالمقارنة في خانة الأعشار)',
      spokenText: 'أيهما أكبر: 0.$tenths أم 0.$other؟',
      index: index,
    );
  }

  static Question _advancedFractionDecimal(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final whole = _rand(random, 11, 99);
    return base(
      topic: topic,
      kind: QuestionKind.fractionOps,
      tokens: [whole, '.5 × 100 = ?'],
      answer: whole * 100 + 50,
      choices: _choices(whole * 100 + 50, random, candidates: [
        whole * 100,
        whole * 10 + 5,
        whole * 100 + 5,
      ]),
      random: random,
      explanation: 'الضرب في 100 يحرك الفاصلة خانتين: ناتج ${whole * 100}.5',
      spokenText: 'ما ناتج ضرب $whole.5 في 100؟',
      index: index,
    );
  }

  // ─── Full-book coverage: geometry & theorems ─────────────────────────

  static Question _anglesPolygons(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const facts = [
      ('مجموع زوايا المثلث', 180),
      ('مجموع زوايا الرباعي', 360),
      ('الزاوية القائمة', 90),
      ('عدد أضلاع الخماسي', 5),
      ('عدد أضلاع السداسي', 6),
    ];
    final fact = facts[random.nextInt(facts.length)];
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: ['ما', fact.$1, '؟'],
      answer: fact.$2,
      choices: _choices(fact.$2, random, candidates: [
        fact.$2 * 2,
        fact.$2 > 90 ? fact.$2 - 90 : 90,
        fact.$2 ~/ 2 > 1 ? fact.$2 ~/ 2 : fact.$2 + 30,
      ]),
      random: random,
      explanation: '${fact.$1} = ${ArabicNumbers.formatInt(fact.$2)}',
      spokenText: 'ما ${fact.$1}؟',
      index: index,
    );
  }

  static Question _circleMeasure(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final radius = 7 * _rand(random, 1, 4);
    final askPerimeter = random.nextBool();
    // Using π = 22/7 keeps everything integer: 2πr = 44k, πr² = 154k².
    final answer =
        askPerimeter ? 2 * (22 ~/ 7) * radius : (22 ~/ 7) * radius * radius;
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: [
        askPerimeter ? 'محيط' : 'مساحة',
        'دائرة نصف قطرها',
        radius,
        '(استخدم 22/7)؟',
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + radius,
        askPerimeter ? (22 ~/ 7) * radius * radius : 2 * (22 ~/ 7) * radius,
        answer * 2,
      ]),
      random: random,
      explanation: askPerimeter
          ? 'المحيط = 2πr = 2 × (22/7) × ${ArabicNumbers.formatInt(radius)} = ${ArabicNumbers.formatInt(answer)}'
          : 'المساحة = πr² = (22/7) × ${ArabicNumbers.formatInt(radius)}² = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'أوجد ${askPerimeter ? 'محيط' : 'مساحة'} دائرة نصف قطرها ${ArabicNumbers.formatInt(radius)} باستخدام 22 على 7',
      index: index,
    );
  }

  static Question _circleTheorems(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final inscribed = _rand(random, 15, 60);
    final central = inscribed * 2;
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: [
        'الزاوية المركزية ضعف المحيطية؛ المحيطية',
        inscribed,
        'فالمركزية؟'
      ],
      answer: central,
      choices: _choices(central, random, candidates: [
        inscribed,
        central ~/ 2 + 1,
        central + 10,
      ]),
      random: random,
      explanation:
          'المركزية = 2 × المحيطية = ${ArabicNumbers.formatInt(central)}°',
      spokenText:
          'الزاوية المحيطية ${ArabicNumbers.formatInt(inscribed)} درجة؛ ما قياس الزاوية المركزية؟',
      index: index,
    );
  }

  static Question _circleQuadrilateral(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    if (random.nextBool()) {
      return base(
        topic: topic,
        kind: QuestionKind.geometryMeasure,
        tokens: ['الزاوية بين المماس ونصف القطر عند نقطة التماس = ?'],
        answer: 90,
        choices: _choices(90, random, candidates: [45, 60, 180]),
        random: random,
        explanation: 'المماس عمودي على نصف القطر عند نقطة التماس (90°)',
        spokenText: 'ما قياس الزاوية بين المماس ونصف القطر؟',
        index: index,
      );
    }
    final given = _rand(random, 35, 95);
    final opposite = 180 - given;
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: ['رباعي دائري؛ إحدى زواياه', given, 'فالمقابلة لها؟'],
      answer: opposite,
      choices: _choices(opposite, random, candidates: [
        180,
        given,
        90,
      ]),
      random: random,
      explanation:
          'مجموع الزاويتين المتقابلتين = 180° → ${ArabicNumbers.formatInt(opposite)}°',
      spokenText:
          'في رباعي دائري قياس زاوية ${ArabicNumbers.formatInt(given)}°؛ ما قياس المقابلة؟',
      index: index,
    );
  }

  static Question _similarityRatio(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final scale = _rand(random, 2, 5);
    final small = _rand(random, 2, 12);
    final answer = small * scale;
    return base(
      topic: topic,
      kind: QuestionKind.geometryMeasure,
      tokens: [
        'نسبة التشابه 1:$scale؛ الضلع الأول',
        small,
        'فالنظير الثاني؟',
      ],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        small,
        small + scale,
        answer + scale,
      ]),
      random: random,
      explanation:
          'الضلع النظير = ${ArabicNumbers.formatInt(small)} × ${ArabicNumbers.formatInt(scale)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'مثلثان متشابهان بنسبة 1 إلى ${ArabicNumbers.formatInt(scale)}؛ ضلع الأول ${ArabicNumbers.formatInt(small)}، فما نظيره؟',
      index: index,
    );
  }

  static Question _congruenceFacts(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    const facts = [
      ('ضض', 3),
      ('زا-ض-زا', 2),
      ('ضلع-زاوية-ضلع', 2),
    ];
    final fact = facts[random.nextInt(facts.length)];
    return base(
      topic: topic,
      kind: QuestionKind.shapeFacts,
      tokens: ['في تطابق المثلثات، أي عناصر تمثلها', fact.$1, '؟'],
      answer: fact.$2,
      choices: _choices(fact.$2, random, candidates: [1, 2, 3, 4]),
      random: random,
      explanation: 'رمز ${fact.$1} يدل على ${fact.$2} عناصر',
      spokenText: 'كم عنصر يمثل رمز ${fact.$1} في حالات تطابق المثلثات؟',
      index: index,
    );
  }

  static Question _anglePairs(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    switch (random.nextInt(3)) {
      case 0:
        final first = _rand(random, 10, 80);
        final answer = 90 - first;
        return base(
          topic: topic,
          kind: QuestionKind.geometryMeasure,
          tokens: ['زاويتان متتامتان؛ الأولى', first, 'فالثانية؟'],
          answer: answer,
          choices: _choices(answer, random, candidates: [
            180 - first,
            90,
            first,
          ]),
          random: random,
          explanation:
              'مجموع الزاويتين المتتاميتين = 90° → ${ArabicNumbers.formatInt(answer)}°',
          spokenText:
              'زاويتان متتامتان، الأولى ${ArabicNumbers.formatInt(first)}°؛ ما الثانية؟',
          index: index,
        );
      case 1:
        final first = _rand(random, 10, 120);
        final answer = 180 - first;
        return base(
          topic: topic,
          kind: QuestionKind.geometryMeasure,
          tokens: ['زاويتان متكاملتان؛ الأولى', first, 'فالثانية؟'],
          answer: answer,
          choices: _choices(answer, random, candidates: [
            90 - first - 1 > 0 ? 90 - first : 60,
            90,
            first,
          ]),
          random: random,
          explanation:
              'الزاويتان المتكاملتان تساويان 180° → ${ArabicNumbers.formatInt(answer)}°',
          spokenText:
              'زاويتان متكاملتان، الأولى ${ArabicNumbers.formatInt(first)}°؛ ما الثانية؟',
          index: index,
        );
      default:
        final first = _rand(random, 20, 80);
        final second = _rand(random, 20, 179 - first);
        final answer = 180 - first - second;
        return base(
          topic: topic,
          kind: QuestionKind.geometryMeasure,
          tokens: ['في مثلث زاويتين', first, 'و', second, 'فالثالثة؟'],
          answer: answer,
          choices: _choices(answer, random, candidates: [
            180,
            first + second,
            answer + 5 > 0 ? answer + 5 : 30,
          ]),
          random: random,
          explanation:
              'مجموع الزوايا 180° → الثالثة = ${ArabicNumbers.formatInt(answer)}°',
          spokenText:
              'في مثلث، زاويتها ${ArabicNumbers.formatInt(first)}° و${ArabicNumbers.formatInt(second)}°؛ أوجد الثالثة',
          index: index,
        );
    }
  }

  // ─── Full-book coverage: statistics ──────────────────────────────────

  static List<int> _dataset(Random random, int size, int max) {
    return List.generate(size, (_) => _rand(random, 1, max));
  }

  static Question _basicStatistics(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final values = [4, 8, 12].map((v) => v * _rand(random, 1, 3)).toList()
      ..shuffle(random);
    final sum = values.reduce((a, b) => a + b);
    return base(
      topic: topic,
      kind: QuestionKind.statisticsMeasure,
      tokens: ['وسط القيم', values.join('، '), '؟'],
      answer: sum ~/ 3,
      choices: _choices(sum ~/ 3, random, candidates: [
        sum ~/ 4,
        sum,
        values.first,
      ]),
      random: random,
      explanation:
          'الوسط = مجموع القيم ÷ عددها = ${ArabicNumbers.formatInt(sum)} ÷ 3 = ${ArabicNumbers.formatInt(sum ~/ 3)}',
      spokenText: 'ما الوسط الحسابي لأرقام ${values.join('، ')}؟',
      index: index,
    );
  }

  static Question _dispersion(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final values = _dataset(random, 4, 40)..sort();
    final range = values.last - values.first;
    return base(
      topic: topic,
      kind: QuestionKind.statisticsMeasure,
      tokens: ['المدى للقيم', values.join('، '), '؟'],
      answer: range,
      choices: _choices(range, random, candidates: [
        values.last,
        range + values.first,
        values.first,
      ]),
      random: random,
      explanation:
          'المدى = أكبر قيمة − أصغر قيمة = ${ArabicNumbers.formatInt(values.last)} − ${ArabicNumbers.formatInt(values.first)} = ${ArabicNumbers.formatInt(range)}',
      spokenText: 'ما مدى الأعداد ${values.join('، ')}؟',
      index: index,
    );
  }

  static Question _advancedStatistics(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final values =
        [2, 6, 10, 14, 18].map((v) => v * _rand(random, 1, 2)).toList()..sort();
    final median = values[2];
    return base(
      topic: topic,
      kind: QuestionKind.statisticsMeasure,
      tokens: ['الوسيط للقيم', values.join('، '), '؟'],
      answer: median,
      choices: _choices(median, random, candidates: [
        values.first,
        values.last,
        (values.first + values.last) ~/ 2,
      ]),
      random: random,
      explanation:
          'الوسيط هو القيمة الوسطى بعد الترتيب = ${ArabicNumbers.formatInt(median)}',
      spokenText: 'ما وسيط الأعداد ${values.join('، ')}؟',
      index: index,
    );
  }

  // ─── Full-book coverage: algebra advanced ────────────────────────────

  static Question _rootSimplify(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final n = _rand(random, 11, 25);
    final square = n * n;
    return base(
      topic: topic,
      kind: QuestionKind.squareRoot,
      tokens: ['ما', 'الجذر', 'التربيعي', 'للعدد', square, '؟'],
      answer: n,
      choices: _choices(n, random, candidates: [n + 1, n - 1, n + 2]),
      random: random,
      explanation:
          'لأن ${ArabicNumbers.formatInt(n)}² = ${ArabicNumbers.formatInt(square)}',
      spokenText: 'ما الجذر التربيعي للعدد ${ArabicNumbers.formatInt(square)}؟',
      index: index,
    );
  }

  static Question _factorCommon(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final common = _rand(random, 2, 9);
    final a = common * _rand(random, 2, 9);
    final b = common * _rand(random, 2, 9);
    return base(
      topic: topic,
      kind: QuestionKind.gcfLcm,
      tokens: [
        'العامل المشترك الأعظم للمقادير',
        a,
        'و',
        b,
        '؟',
      ],
      answer: common,
      choices: _choices(common, random, candidates: [
        common + 1,
        common * 2,
        common > 2 ? common - 1 : common + 2,
      ]),
      random: random,
      explanation:
          'كلا الحدين يقبل القسمة على ${ArabicNumbers.formatInt(common)} فهو العامل المشترك الأعظم',
      spokenText:
          'ما العامل المشترك الأعظم بين ${ArabicNumbers.formatInt(a)} و${ArabicNumbers.formatInt(b)}؟',
      index: index,
    );
  }

  static Question _specialFactoring(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final r = _rand(random, 2, 12);
    final square = r * r;
    return base(
      topic: topic,
      kind: QuestionKind.evaluateExpression,
      tokens: ['تحليل: س² −', square, '= (س − ؟)(س + ؟)'],
      answer: r,
      choices: _choices(r, random, candidates: [
        r + 1,
        square,
        r > 1 ? r - 1 : r + 2,
      ]),
      random: random,
      explanation: 'الفرق بين مربعين: س² − ${r * r} = (س − $r)(س + $r)',
      spokenText: 'في تحليل الفرق بين مربعين، ما قيمة الحد المفقود؟',
      index: index,
    );
  }

  static Question _algebraicFractions(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    final divisor = _rand(random, 2, 8);
    final value = _rand(random, 2, 12);
    final answer = divisor * value;
    return base(
      topic: topic,
      kind: QuestionKind.solveLinearEquation,
      tokens: ['أوجد س بحيث س /', divisor, '=', value],
      answer: answer,
      choices: _choices(answer, random, candidates: [
        answer + divisor,
        value,
        answer > 1 ? answer - divisor : answer + divisor * 2,
      ]),
      random: random,
      explanation:
          'س = ${ArabicNumbers.formatInt(value)} × ${ArabicNumbers.formatInt(divisor)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'إذا كان س مقسوما على ${ArabicNumbers.formatInt(divisor)} يساوي ${ArabicNumbers.formatInt(value)} فأوجد س',
      index: index,
    );
  }

  static Question _trigBasics(
    CurriculumTopic topic,
    TopicEnvelope env,
    Random random,
    int index,
  ) {
    if (random.nextBool()) {
      return base(
        topic: topic,
        kind: QuestionKind.percentCalc,
        tokens: ['ما قيمة تان 45°؟'],
        answer: 1,
        choices: _choices(1, random, candidates: [0, 2, -1]),
        random: random,
        explanation: 'قيمة ظا 45° = 1 (قيمة اعتيادية محفوظة)',
        spokenText: 'ما قيمة الظا للزاوية 45 درجة؟',
        index: index,
      );
    }
    // In a 45° right triangle, height = horizontal distance.
    final length = _rand(random, 3, 15);
    return base(
      topic: topic,
      kind: QuestionKind.pythagoras,
      tokens: ['مثلث قائم زاويته 45°؛ المسافة الأفقية', length, 'فالارتفاع؟'],
      answer: length,
      choices: _choices(length, random, candidates: [
        length * 2,
        length + 1,
        length > 1 ? length - 1 : length + 2,
      ]),
      random: random,
      explanation: 'في زاوية 45°، الارتفاع = المسافة الأفقية',
      spokenText:
          'مثلث قائم بزاوية 45 درجة، الساق الأفقية ${ArabicNumbers.formatInt(length)}؛ ما الارتفاع؟',
      index: index,
    );
  }
}
