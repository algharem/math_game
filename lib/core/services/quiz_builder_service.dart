import 'dart:math';

import '../curriculum/topic_seed.dart';
import '../services/topic_question_factory.dart';
import '../../shared/models/difficulty_profile.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_config.dart';
import '../../shared/models/question.dart';
import '../curriculum/curriculum_registry.dart';
import '../curriculum/grade_curriculum.dart';
import '../utils/arabic_number_words.dart';
import '../utils/arabic_numbers.dart';
import '../utils/id_generator.dart';

class QuizBuilderService {
  QuizBuilderService._();

  static List<Question> generate(ExamConfig config) {
    if (config.topicIds.isNotEmpty) {
      return _generateTopicFiltered(config);
    }
    final seed = config.dailyDateKey == null
        ? null
        : _seedFromString('${config.dailyDateKey}:${config.title}');
    final random = seed == null ? Random() : Random(seed);
    final count = config.questionCount.clamp(1, 40);
    final questions = <Question>[];
    final signatures = <String>{};

    for (var index = 0; index < count; index++) {
      var question = _questionFor(config, random, index);
      var attempts = 0;
      while (attempts < 24 && !signatures.add(_signature(question))) {
        question = _questionFor(config, random, index);
        attempts++;
      }
      questions.add(question);
    }

    return questions;
  }

  /// Topic-filtered exam: questions strictly inside the selected topics.
  static List<Question> _generateTopicFiltered(ExamConfig config) {
    final random = Random();
    final index = buildTopicIndex(curriculumTopicSeed);
    final readyIds = config.topicIds
        .where((id) => index[id]?.generationReady ?? false)
        .toList();
    if (readyIds.isEmpty) return const [];

    final strength = switch (config.topicDifficultyLevel) {
      'easy' => TopicStrength.easy,
      'hard' => TopicStrength.hard,
      'mixed' => TopicStrength.values[random.nextInt(3)],
      _ => TopicStrength.medium,
    };
    final count = config.questionCount.clamp(1, 40);
    final questions = <Question>[];
    final signatures = <String>{};
    // Round-robin across selected topics so every topic is represented.
    for (var i = 0; i < count; i++) {
      final topic = index[readyIds[i % readyIds.length]]!;
      var attempts = 0;
      Question question;
      do {
        question = TopicQuestionFactory.question(
          topic: topic,
          strength: strength,
          random: random,
          index: i,
        );
        attempts++;
      } while (attempts < 18 && !signatures.add(_signature(question)));
      questions.add(question);
    }
    return questions;
  }

  /// Adaptive backup pool: extra questions (ordered easy→hard) that the
  /// quiz screen can pull from as the student's accuracy changes.
  static List<Question> generateAdaptivePool(ExamConfig config) {
    final result = <Question>[];
    for (final strength in TopicStrength.values) {
      result.addAll(
        _generateTopicFilteredSwing(config, strength),
      );
    }
    return result;
  }

  /// Adaptive pass 1: one full pool per strength tier, each exactly
  /// [ExamConfig.questionCount] long, round-robin over the selected topics.
  /// The quiz screen swaps upcoming questions between these tiers based on
  /// the student's recent accuracy.
  static Map<TopicStrength, List<Question>> generateAdaptiveTiers(
    ExamConfig config,
  ) {
    final result = <TopicStrength, List<Question>>{};
    for (final strength in TopicStrength.values) {
      result[strength] = _generateTopicFilteredSwing(config, strength);
    }
    return result;
  }

  static List<Question> _generateTopicFilteredSwing(
    ExamConfig config,
    TopicStrength strength,
  ) {
    final random = Random();
    final index = buildTopicIndex(curriculumTopicSeed);
    final readyIds = config.topicIds
        .where((id) => index[id]?.generationReady ?? false)
        .toList();
    if (readyIds.isEmpty) return const [];
    final questions = <Question>[];
    for (var i = 0; i < config.questionCount; i++) {
      final topic = index[readyIds[i % readyIds.length]]!;
      questions.add(
        TopicQuestionFactory.question(
          topic: topic,
          strength: strength,
          random: random,
          index: i,
        ),
      );
    }
    return questions;
  }

  static Question _questionFor(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final question = switch (config.section) {
      MathSection.multiplication =>
        _multiplicationQuestion(config, random, index),
      MathSection.division => _divisionQuestion(config, random, index),
      MathSection.addition => _additionQuestion(config, random, index),
      MathSection.subtraction => _subtractionQuestion(config, random, index),
      MathSection.mixed => _mixedQuestion(config, random, index),
      MathSection.daily => _dailyQuestion(config, random, index),
    };
    return _withTopicLabel(question, config);
  }

  /// Attaches the grade-book unit/lesson label when a curriculum exists.
  static Question _withTopicLabel(Question question, ExamConfig config) {
    final curriculum = CurriculumRegistry.forGrade(config.schoolGrade);
    if (curriculum == null) return question;
    final level = config.levelNumber ??
        (config.isDaily
            ? 55
            : switch (config.difficulty) {
                Difficulty.easy => 25,
                Difficulty.medium => 55,
                Difficulty.hard => 85,
                Difficulty.random => 55,
              });
    final label = curriculum.lessonLabelForLevel(level);
    if (label.isEmpty) return question;
    return question.copyWith(topicLabel: label);
  }

  /// Returns a random supported number-sense skill, or null to keep the
  /// legacy arithmetic generation.
  static CurriculumSkill? _pickCurriculumKind(
    ExamConfig config,
    Random random,
    DifficultyProfile profile,
  ) {
    final chance = profile.curriculumKindChance;
    if (chance == null || chance <= 0) return null;
    if (random.nextDouble() >= chance) return null;
    final candidates = <CurriculumSkill>[];
    for (final skill in const [
      CurriculumSkill.numberWords,
      CurriculumSkill.expandedForm,
      CurriculumSkill.compareNumbers,
      CurriculumSkill.rounding,
    ]) {
      if (profile.curriculumKinds?.contains(skill) != true) continue;
      switch (skill) {
        case CurriculumSkill.numberWords:
          if ((profile.numberWordsMax ?? 0) >= 100) candidates.add(skill);
        case CurriculumSkill.expandedForm:
          if ((profile.expandedMax ?? 0) >= 100) candidates.add(skill);
        case CurriculumSkill.compareNumbers:
          if ((profile.compareMax ?? 0) >= 100) candidates.add(skill);
        case CurriculumSkill.rounding:
          if ((profile.roundingMax ?? 0) >= 100) candidates.add(skill);
        default:
          break;
      }
    }
    if (candidates.isEmpty) return null;
    return candidates[random.nextInt(candidates.length)];
  }

  static Question _curriculumSkillQuestion(
    CurriculumSkill skill,
    ExamConfig config,
    Random random,
    int index,
    DifficultyProfile profile,
  ) {
    return switch (skill) {
      CurriculumSkill.numberWords =>
        _numberWordsQuestion(config, random, index, profile),
      CurriculumSkill.expandedForm =>
        _expandedFormQuestion(config, random, index, profile),
      CurriculumSkill.compareNumbers =>
        _compareNumbersQuestion(config, random, index, profile),
      CurriculumSkill.rounding =>
        _roundingQuestion(config, random, index, profile),
      _ => _additionQuestion(config, random, index),
    };
  }

  static String _signature(Question question) {
    final tokens = question.tokens.map((token) => token ?? '?').join(',');
    return '${question.kind.name}|$tokens|${question.correctAnswer}';
  }

  static DifficultyProfile _profile(ExamConfig config) {
    return DifficultyProfile.resolve(
      section: config.section,
      difficulty: config.difficulty,
      levelNumber: config.levelNumber,
      schoolGrade: config.schoolGrade,
    );
  }

  static int _randomBetween(Random random, int min, int max) {
    if (max <= min) return min;
    return random.nextInt(max - min + 1) + min;
  }

  static int _seedFromString(String value) {
    var seed = 17;
    for (final code in value.codeUnits) {
      seed = (seed * 31 + code) & 0x7fffffff;
    }
    return seed;
  }

  static Question _multiplicationQuestion(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final profile = _profile(config);
    final first = config.multiplicationTable ??
        _randomBetween(random, 1, profile.multiplicationFirstMax);
    final second = config.multiplicationTable == null
        ? _randomBetween(random, 1, profile.multiplicationSecondMax)
        : _randomBetween(random, 1, 12);
    final product = first * second;
    final format = config.multiplicationFormat == MultiplicationFormat.mixed
        ? (random.nextDouble() < profile.multiplicationMissingChance
            ? MultiplicationFormat.missing
            : MultiplicationFormat.result)
        : config.multiplicationFormat;

    late final QuestionKind kind;
    late final List<Object?> tokens;
    late final int answer;
    late final String explanation;
    switch (format) {
      case MultiplicationFormat.result:
        kind = QuestionKind.multiplicationResult;
        tokens = [first, '×', second, '=', null];
        answer = product;
        explanation =
            '${ArabicNumbers.formatInt(first)} × ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(product)}';
      case MultiplicationFormat.missing:
        final missingFirst = random.nextBool();
        if (missingFirst) {
          kind = QuestionKind.multiplicationMissingFirst;
          tokens = [null, '×', second, '=', product];
          answer = first;
        } else {
          kind = QuestionKind.multiplicationMissingSecond;
          tokens = [first, '×', null, '=', product];
          answer = second;
        }
        explanation =
            'العدد الناقص هو ${ArabicNumbers.formatInt(answer)} لأن ${ArabicNumbers.formatInt(first)} × ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(product)}';
      case MultiplicationFormat.mixed:
        kind = QuestionKind.multiplicationResult;
        tokens = [first, '×', second, '=', null];
        answer = product;
        explanation =
            '${ArabicNumbers.formatInt(first)} × ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(product)}';
    }

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: kind,
      tokens: tokens,
      correctAnswer: answer,
      choices: _choices(answer, random),
      explanation: explanation,
      factKey: 'mul:$first:$second',
      spokenText: _multiplicationSpoken(kind, first, second, product),
    );
  }

  static String _multiplicationSpoken(
    QuestionKind kind,
    int first,
    int second,
    int product,
  ) {
    final a = ArabicNumbers.formatInt(first);
    final b = ArabicNumbers.formatInt(second);
    final result = ArabicNumbers.formatInt(product);
    switch (kind) {
      case QuestionKind.multiplicationMissingFirst:
        return 'ما العدد الناقص؟ ... ضرب $b يساوي $result';
      case QuestionKind.multiplicationMissingSecond:
        return 'ما العدد الناقص؟ $a ضرب ... يساوي $result';
      default:
        return 'كم يساوي $a ضرب $b؟';
    }
  }

  static Question _divisionQuestion(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final profile = _profile(config);
    final divisor = _randomBetween(random, 2, profile.divisionMax);
    final quotient = _randomBetween(random, 2, profile.divisionMax);
    final dividend = divisor * quotient;
    final format = config.divisionFormat == DivisionFormat.mixed
        ? DivisionFormat.values[random.nextInt(4)]
        : config.divisionFormat;

    late final QuestionKind kind;
    late final List<Object?> tokens;
    late final int answer;
    switch (format) {
      case DivisionFormat.quotient:
        kind = QuestionKind.divisionQuotient;
        tokens = [dividend, '÷', divisor, '=', null];
        answer = quotient;
      case DivisionFormat.divisor:
        kind = QuestionKind.divisionDivisor;
        tokens = [dividend, '÷', null, '=', quotient];
        answer = divisor;
      case DivisionFormat.dividend:
        kind = QuestionKind.divisionDividend;
        tokens = [null, '÷', divisor, '=', quotient];
        answer = dividend;
      case DivisionFormat.mixed:
        kind = QuestionKind.divisionQuotient;
        tokens = [dividend, '÷', divisor, '=', null];
        answer = quotient;
    }

    final explanation =
        '${ArabicNumbers.formatInt(dividend)} ÷ ${ArabicNumbers.formatInt(divisor)} = ${ArabicNumbers.formatInt(quotient)}';

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: kind,
      tokens: tokens,
      correctAnswer: answer,
      choices: _choices(answer, random),
      explanation: explanation,
      factKey: 'div:$divisor:$quotient',
      spokenText: _divisionSpoken(kind, dividend, divisor, quotient),
    );
  }

  static String _divisionSpoken(
    QuestionKind kind,
    int dividend,
    int divisor,
    int quotient,
  ) {
    final a = ArabicNumbers.formatInt(dividend);
    final b = ArabicNumbers.formatInt(divisor);
    final result = ArabicNumbers.formatInt(quotient);
    switch (kind) {
      case QuestionKind.divisionDivisor:
        return 'ما العدد الناقص؟ $a مقسومًا على ... يساوي $result';
      case QuestionKind.divisionDividend:
        return 'ما العدد الناقص؟ ... مقسومًا على $b يساوي $result';
      default:
        return 'كم يساوي $a مقسومًا على $b؟';
    }
  }

  static Question _additionQuestion(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final profile = _profile(config);
    final first = _randomBetween(random, 1, profile.additionMax);
    final second = _randomBetween(random, 1, profile.additionMax);
    final answer = first + second;
    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.addition,
      tokens: [first, '+', second, '=', null],
      correctAnswer: answer,
      choices: _choices(answer, random),
      explanation:
          '${ArabicNumbers.formatInt(first)} + ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(first)} زائد ${ArabicNumbers.formatInt(second)}؟',
    );
  }

  static Question _subtractionQuestion(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final profile = _profile(config);
    final first = _randomBetween(random, 2, profile.subtractionMax);
    final second = _randomBetween(random, 1, first);
    final answer = first - second;
    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.subtraction,
      tokens: [first, '−', second, '=', null],
      correctAnswer: answer,
      choices: _choices(answer, random),
      explanation:
          '${ArabicNumbers.formatInt(first)} − ${ArabicNumbers.formatInt(second)} = ${ArabicNumbers.formatInt(answer)}',
      spokenText:
          'كم يساوي ${ArabicNumbers.formatInt(first)} ناقص ${ArabicNumbers.formatInt(second)}؟',
    );
  }

  static Question _mixedQuestion(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final profile = _profile(config);
    if (profile.allowsTwoStep && index % 3 == 2) {
      return _twoStepQuestion(random, index, profile);
    }
    final curriculumKind = _pickCurriculumKind(config, random, profile);
    if (curriculumKind != null) {
      return _curriculumSkillQuestion(
        curriculumKind,
        config,
        random,
        index,
        profile,
      );
    }
    final section = [
      MathSection.multiplication,
      MathSection.division,
      MathSection.addition,
      MathSection.subtraction,
    ][random.nextInt(4)];
    return switch (section) {
      MathSection.multiplication => _multiplicationQuestion(
          config.copyWith(
            section: MathSection.multiplication,
            multiplicationTable: null,
            multiplicationFormat: MultiplicationFormat.mixed,
          ),
          random,
          index,
        ),
      MathSection.division => _divisionQuestion(
          config.copyWith(
            section: MathSection.division,
            divisionFormat: DivisionFormat.mixed,
          ),
          random,
          index,
        ),
      MathSection.addition => _additionQuestion(config, random, index),
      MathSection.subtraction => _subtractionQuestion(config, random, index),
      _ => _additionQuestion(config, random, index),
    };
  }

  static Question _twoStepQuestion(
    Random random,
    int index,
    DifficultyProfile profile,
  ) {
    late final List<Object?> tokens;
    late final int answer;
    late final String explanation;
    late final String spokenText;
    late final String factKey;

    if (index.isEven) {
      final first = _randomBetween(random, 1, profile.twoStepOperandMax);
      final second = _randomBetween(random, 1, profile.twoStepOperandMax);
      final factor = _randomBetween(random, 2, profile.twoStepFactorMax);
      answer = (first + second) * factor;
      tokens = ['(', first, '+', second, ')', '×', factor, '=', null];
      explanation =
          '(${ArabicNumbers.formatInt(first)} + ${ArabicNumbers.formatInt(second)}) × ${ArabicNumbers.formatInt(factor)} = ${ArabicNumbers.formatInt(answer)}';
      spokenText =
          'كم يساوي قوس ${ArabicNumbers.formatInt(first)} زائد ${ArabicNumbers.formatInt(second)} قوس ضرب ${ArabicNumbers.formatInt(factor)}؟';
      factKey = 'mix2:sumprod:$first:$second:$factor';
    } else {
      final first = _randomBetween(random, 2, profile.twoStepFactorMax);
      final second = _randomBetween(random, 2, profile.twoStepFactorMax);
      final addend = _randomBetween(random, 1, profile.twoStepOperandMax);
      answer = first * second + addend;
      tokens = ['(', first, '×', second, ')', '+', addend, '=', null];
      explanation =
          '(${ArabicNumbers.formatInt(first)} × ${ArabicNumbers.formatInt(second)}) + ${ArabicNumbers.formatInt(addend)} = ${ArabicNumbers.formatInt(answer)}';
      spokenText =
          'كم يساوي قوس ${ArabicNumbers.formatInt(first)} ضرب ${ArabicNumbers.formatInt(second)} قوس زائد ${ArabicNumbers.formatInt(addend)}؟';
      factKey = 'mix2:prodsum:$first:$second:$addend';
    }

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.mixedExpression,
      tokens: tokens,
      correctAnswer: answer,
      choices: _choices(answer, random),
      explanation: explanation,
      factKey: factKey,
      spokenText: spokenText,
    );
  }

  static Question _dailyQuestion(
    ExamConfig config,
    Random random,
    int index,
  ) {
    final difficulty = index < 4 ? Difficulty.easy : Difficulty.medium;
    final section = [
      MathSection.multiplication,
      MathSection.division,
      MathSection.addition,
      MathSection.subtraction,
    ][index % 4];
    final childConfig = config.copyWith(
      section: section,
      difficulty: difficulty,
      multiplicationTable: null,
      multiplicationFormat: MultiplicationFormat.mixed,
      divisionFormat: DivisionFormat.mixed,
    );
    final childProfile = _profile(childConfig);
    final curriculumKind = _pickCurriculumKind(
      childConfig,
      random,
      childProfile,
    );
    if (curriculumKind != null) {
      return _curriculumSkillQuestion(
        curriculumKind,
        childConfig,
        random,
        index,
        childProfile,
      );
    }
    return switch (section) {
      MathSection.multiplication => _multiplicationQuestion(
          childConfig,
          random,
          index,
        ),
      MathSection.division => _divisionQuestion(childConfig, random, index),
      MathSection.addition => _additionQuestion(childConfig, random, index),
      MathSection.subtraction =>
        _subtractionQuestion(childConfig, random, index),
      _ => _additionQuestion(childConfig, random, index),
    };
  }

  // ---- Curriculum number-sense builders (textbook kinds) ----

  /// «اقرأ العدد المكتوب بالكلمات» — number shown in words, numeral choices.
  static Question _numberWordsQuestion(
    ExamConfig config,
    Random random,
    int index,
    DifficultyProfile profile,
  ) {
    final max = profile.numberWordsMax ?? 9999;
    final min = max >= 1000 ? 100 : 10;
    final number = _randomBetween(random, min, max);
    final words = ArabicNumberWords.formatOrClamp(number, max: max);
    final explanation =
        'العدد «${ArabicNumbers.toArabicDigits(words)}» يُكتب بالأرقام: ${ArabicNumbers.formatInt(number)}';

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.numberWords,
      tokens: ['العدد', 'بالكلمات:', words],
      correctAnswer: number,
      choices: _numberWordsChoices(number, random),
      explanation: explanation,
      factKey: 'numw:$number',
      spokenText:
          'اقرأ العدد المكتوب بالكلمات ثم اختر ما يوافقه من الأرقام: $words',
    );
  }

  /// «الصورة الموسّعة للعدد» — 4000 + 300 + 5 = ؟
  static Question _expandedFormQuestion(
    ExamConfig config,
    Random random,
    int index,
    DifficultyProfile profile,
  ) {
    final max = profile.expandedMax ?? 9999;
    final number = _randomBetween(random, 10, max);

    // Group digits into non-zero place values, e.g. 4305 → [4000, 300, 5].
    final parts = <int>[];
    var remaining = number;
    var place = 1;
    while (remaining > 0) {
      final digit = remaining % 10;
      remaining ~/= 10;
      if (digit > 0) parts.insert(0, digit * place);
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
    final explanation =
        'صورة العدد ${ArabicNumbers.formatInt(number)} الموسّعة: $partText = ${ArabicNumbers.formatInt(number)}';

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.expandedForm,
      tokens: tokens,
      correctAnswer: number,
      choices: _expandedChoices(number, random),
      explanation: explanation,
      factKey: 'exp:$number',
      spokenText: 'ما العدد الذي صورته الموسّعة هي: $partText؟',
    );
  }

  /// «أيهما أكبر/أصغر؟» — compare two numerals.
  static Question _compareNumbersQuestion(
    ExamConfig config,
    Random random,
    int index,
    DifficultyProfile profile,
  ) {
    final compareUpper = profile.compareMax ?? 9999;
    final lower = compareUpper >= 1000 ? 1000 : 10;
    final first = _randomBetween(random, lower, compareUpper);
    int second;
    do {
      second = _randomBetween(random, lower, compareUpper);
    } while (second == first);
    final askLarger = random.nextBool();
    final answer = askLarger
        ? (first > second ? first : second)
        : (first < second ? first : second);
    final prompt = askLarger ? 'أيهما أكبر؟' : 'أيهما أصغر؟';
    final explanation =
        '$prompt ${ArabicNumbers.formatInt(first)} و${ArabicNumbers.formatInt(second)} — ${askLarger ? 'الأكبر' : 'الأصغر'} هو ${ArabicNumbers.formatInt(answer)}';

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.compareNumbers,
      tokens: [prompt, first, 'و', second],
      correctAnswer: answer,
      choices: _compareChoices(answer, first, second, random),
      explanation: explanation,
      factKey: 'cmp:$first:$second',
      spokenText:
          '$prompt ${ArabicNumbers.formatInt(first)} أم ${ArabicNumbers.formatInt(second)}؟',
    );
  }

  /// «قرّب العدد إلى أقرب عشرة/مئة/ألف» — rounding.
  static Question _roundingQuestion(
    ExamConfig config,
    Random random,
    int index,
    DifficultyProfile profile,
  ) {
    final max = profile.roundingMax ?? 9999;
    final places = profile.roundingPlaces ?? const [10, 100, 1000];
    // Only allow places that make sense for the chosen magnitude.
    final number = _randomBetween(random, 10, max);
    final digits = '$number'.length;
    final allowed = places
        .where((place) => place <= number / 4 && '$place'.length <= digits)
        .toList();
    final place = allowed.isEmpty
        ? places.first
        : allowed[random.nextInt(allowed.length)];
    final answer = (number / place).round() * place;
    final placeLabel = switch (place) {
      10 => 'عشرة',
      100 => 'مئة',
      1000 => 'ألف',
      10000 => 'عشرة آلاف',
      _ => '$place',
    };
    final explanation =
        'تقريب ${ArabicNumbers.formatInt(number)} إلى أقرب $placeLabel يعطي ${ArabicNumbers.formatInt(answer)}';

    return Question(
      id: '${IdGenerator.next()}-$index',
      kind: QuestionKind.rounding,
      tokens: ['إلى أقرب $placeLabel:', number, '≈', null],
      correctAnswer: answer,
      choices: _roundingChoices(number, place, answer, random),
      explanation: explanation,
      factKey: 'round:$number:$place',
      spokenText:
          'قرّب العدد ${ArabicNumbers.formatInt(number)} إلى أقرب $placeLabel',
    );
  }

  // ---- Kind-specific distractors ----

  static List<int> _numberWordsChoices(int answer, Random random) {
    final magnitude = '$answer'.length - 1;
    final unit = (pow(10, magnitude).toInt()).clamp(1, 1000000);
    return _buildChoices(
      answer,
      random,
      candidates: [
        _swapTwoDigits(answer, random) ?? answer + unit,
        answer + unit,
        if (answer - unit > 0) answer - unit,
        answer + 10,
        if (answer - 10 > 0) answer - 10,
      ],
    );
  }

  static List<int> _expandedChoices(int answer, Random random) {
    return _buildChoices(
      answer,
      random,
      candidates: [
        _swapTwoDigits(answer, random) ?? answer + 100,
        answer + 100,
        if (answer - 100 > 0) answer - 100,
        answer + 10,
        if (answer - 10 > 0 && answer >= 100) answer - 10,
        answer ~/ 10 + (answer % 10) * pow(10, '$answer'.length - 1).toInt(),
      ],
    );
  }

  static List<int> _compareChoices(
    int answer,
    int first,
    int second,
    Random random,
  ) {
    final wrongAsk = answer == first ? second : first;
    final magnitude = ('$first'.length - 2).clamp(0, 6);
    final unit = pow(10, magnitude).toInt().clamp(1, 1000);
    return _buildChoices(
      answer,
      random,
      candidates: [
        wrongAsk,
        first + unit,
        if (first - unit > 0) first - unit,
        second + unit,
        if (second - unit > 0) second - unit,
      ],
    );
  }

  static List<int> _roundingChoices(
    int number,
    int place,
    int answer,
    Random random,
  ) {
    return _buildChoices(
      answer,
      random,
      candidates: [
        number,
        answer + place,
        if (answer - place > 0) answer - place,
        answer + 1,
        if (answer - 1 > 0) answer - 1,
        (number ~/ place) * place,
      ],
    );
  }

  /// Turns digit pairs around, e.g. 1234 ↔ 1243 — a classic place-value slip.
  static int? _swapTwoDigits(int number, Random random) {
    final digits = '$number'.split('');
    if (digits.length < 2) return null;
    var a = random.nextInt(digits.length);
    var b = random.nextInt(digits.length);
    while (b == a) {
      b = random.nextInt(digits.length);
    }
    final tmp = digits[a];
    digits[a] = digits[b];
    digits[b] = tmp;
    final swapped = int.tryParse(digits.join()) ?? 0;
    if (swapped == number || swapped <= 0) return null;
    return swapped;
  }

  /// Deduplicates candidates into a 4-choice list, falling back to safe
  /// ±m offsets when candidates run out.
  static List<int> _buildChoices(
    int answer,
    Random random, {
    List<int> candidates = const [],
  }) {
    final values = <int>{answer};
    final pool = candidates.where((value) => value > 0).toList()
      ..shuffle(random);
    for (final candidate in pool) {
      if (values.length >= 4) break;
      if (candidate != answer) values.add(candidate);
    }
    var offset = 1;
    var guard = 0;
    while (values.length < 4 && guard < 200) {
      final candidate = answer + (offset.isEven ? offset : -offset);
      if (candidate > 0 && !values.contains(candidate)) {
        values.add(candidate);
      }
      offset++;
      guard++;
    }
    final choices = values.toList(growable: false)..shuffle(random);
    return choices;
  }

  static List<int> _choices(int answer, Random random) {
    final values = <int>{answer};
    final candidates = <int>[
      answer + 1,
      answer - 1,
      answer + 2,
      answer - 2,
      answer + 10,
      answer - 10,
      answer + 5,
      answer - 5,
      answer * 2,
    ];
    candidates.shuffle(random);
    for (final candidate in candidates) {
      if (values.length >= 4) break;
      if (candidate >= 0 && candidate != answer) values.add(candidate);
    }
    var guard = 0;
    while (values.length < 4 && guard < 60) {
      final candidate = random.nextInt(max(20, answer + 12));
      if (candidate >= 0) values.add(candidate);
      guard++;
    }
    final choices = values.toList(growable: false)..shuffle(random);
    return choices;
  }
}
