import 'enums.dart';
import 'exam_config.dart';

class LearningLevelSeed {
  const LearningLevelSeed({
    required this.number,
    required this.title,
    required this.section,
    required this.difficulty,
    required this.topics,
    required this.objectives,
    required this.questionCount,
    required this.passingScore,
    required this.timeLimitSeconds,
  });

  final int number;
  final String title;
  final MathSection section;
  final Difficulty difficulty;
  final List<String> topics;
  final String objectives;
  final int questionCount;
  final int passingScore;
  final int? timeLimitSeconds;
}

class LevelCatalog {
  LevelCatalog._();

  static const _stageNames = [
    'المدخل',
    'الأساسيات',
    'التدريب',
    'التطبيق',
    'السرعة',
    'المهارة',
    'المراجعة',
    'التحدي',
    'الإتقان',
    'اختبار الوحدة',
  ];

  static const _units = [
    (
      title: 'الجمع حتى ١٠',
      topics: ['الجمع', 'الأعداد حتى ١٠'],
      objectives: 'يتقن جمع الأعداد الصغيرة ويبني أساس العمليات الحسابية.',
      section: MathSection.addition,
      difficulty: Difficulty.easy,
    ),
    (
      title: 'الطرح حتى ١٠',
      topics: ['الطرح', 'الأعداد حتى ١٠'],
      objectives: 'يفهم معنى الطرح ويجد الفرق بين الأعداد الصغيرة.',
      section: MathSection.subtraction,
      difficulty: Difficulty.easy,
    ),
    (
      title: 'الجمع والطرح حتى ٢٠',
      topics: ['الجمع', 'الطرح', 'الأعداد حتى ٢٠'],
      objectives: 'ينتقل بثقة بين الجمع والطرح ضمن الأعداد حتى ٢٠.',
      section: MathSection.addition,
      difficulty: Difficulty.easy,
    ),
    (
      title: 'جداول الضرب ١–٥',
      topics: ['الضرب', 'الجداول من ١ إلى ٥'],
      objectives: 'يحفظ جداول الضرب الأولى ويستخدمها في حل المسائل.',
      section: MathSection.multiplication,
      difficulty: Difficulty.easy,
    ),
    (
      title: 'جداول الضرب ٦–١٠',
      topics: ['الضرب', 'الجداول من ٦ إلى ١٠'],
      objectives: 'يتقن الجداول المتوسطة ويحل مسائل الضرب بسرعة وثبات.',
      section: MathSection.multiplication,
      difficulty: Difficulty.medium,
    ),
    (
      title: 'الضرب حتى ١٢',
      topics: ['الضرب', 'الجداول الكاملة'],
      objectives: 'يستخدم جميع جداول الضرب حتى ١٢ في مواقف متنوعة.',
      section: MathSection.multiplication,
      difficulty: Difficulty.medium,
    ),
    (
      title: 'مدخل القسمة',
      topics: ['القسمة', 'العلاقة بالضرب'],
      objectives: 'يفهم القسمة كعملية عكسية للضرب ويجد الناتج بسهولة.',
      section: MathSection.division,
      difficulty: Difficulty.easy,
    ),
    (
      title: 'القسمة حتى ١٢',
      topics: ['القسمة', 'المقسوم والمقسوم عليه'],
      objectives: 'يحل مسائل القسمة المختلفة حتى العدد ١٢ بثقة.',
      section: MathSection.division,
      difficulty: Difficulty.medium,
    ),
    (
      title: 'العمليات المختلطة',
      topics: ['الجمع', 'الطرح', 'الضرب', 'القسمة'],
      objectives: 'يختار العملية المناسبة ويجمع بين المهارات الحسابية.',
      section: MathSection.mixed,
      difficulty: Difficulty.medium,
    ),
    (
      title: 'تحدي الأبطال',
      topics: ['جميع العمليات', 'السرعة', 'الإتقان'],
      objectives: 'يواجه تحديات متقدمة ويظهر إتقان المهارات الحسابية.',
      section: MathSection.mixed,
      difficulty: Difficulty.hard,
    ),
  ];

  static List<LearningLevelSeed> get seedLevels {
    final levels = <LearningLevelSeed>[];
    for (var unitIndex = 0; unitIndex < _units.length; unitIndex++) {
      final unit = _units[unitIndex];
      for (var stage = 0; stage < _stageNames.length; stage++) {
        final number = unitIndex * 10 + stage + 1;
        final section = _sectionFor(number, unit.section);
        levels.add(
          LearningLevelSeed(
            number: number,
            title: '${unit.title} — ${_stageNames[stage]}',
            section: section,
            difficulty: _difficultyFor(number, unit.difficulty),
            topics: unit.topics,
            objectives: unit.objectives,
            questionCount: _questionCountFor(number),
            passingScore: _passingScoreFor(number),
            timeLimitSeconds: _timeLimitFor(number),
          ),
        );
      }
    }
    return List.unmodifiable(levels);
  }

  static List<LearningLevelSeed> get levels => seedLevels;

  static MathSection _sectionFor(int number, MathSection unitSection) {
    if (number >= 21 && number <= 30) {
      return number.isEven ? MathSection.subtraction : MathSection.addition;
    }
    return unitSection;
  }

  static Difficulty _difficultyFor(int number, Difficulty base) {
    if (number >= 91) return Difficulty.hard;
    if (number >= 71 && base == Difficulty.easy) return Difficulty.medium;
    return base;
  }

  static int _questionCountFor(int number) {
    if (number <= 10) return 5;
    if (number <= 30) return 8;
    if (number <= 60) return 10;
    if (number <= 90) return 12;
    return 15;
  }

  static int _passingScoreFor(int number) {
    if (number <= 20) return 60;
    if (number <= 60) return 70;
    if (number <= 90) return 75;
    return 80;
  }

  static int? _timeLimitFor(int number) {
    if (number <= 20) return null;
    if (number <= 60) return 240;
    if (number <= 90) return 180;
    return 120;
  }

  static int? multiplicationTableFor(int number) {
    if (number >= 31 && number <= 40) return ((number - 31) % 5) + 1;
    if (number >= 41 && number <= 50) return 6 + ((number - 41) % 5);
    if (number >= 51 && number <= 60) return ((number - 51) % 12) + 1;
    return null;
  }

  static String sectionNameFor(int number) {
    return _sectionFor(number, _unitSectionFor(number)).name;
  }

  static String difficultyLabelFor(String value) {
    return switch (value) {
      'easy' => 'سهل',
      'medium' => 'متوسط',
      'hard' => 'صعب',
      _ => value,
    };
  }

  static String sectionLabelFor(int number) {
    return _sectionFor(number, _unitSectionFor(number)).shortLabel;
  }

  static MathSection _unitSectionFor(int number) {
    if (number <= 10) return MathSection.addition;
    if (number <= 20) return MathSection.subtraction;
    if (number <= 30) return MathSection.addition;
    if (number <= 60) return MathSection.multiplication;
    if (number <= 80) return MathSection.division;
    return MathSection.mixed;
  }

  static ExamConfig examConfigFor({
    required int levelId,
    required int levelNumber,
    required String title,
    required String section,
    required String difficulty,
    required int questionCount,
    required int? durationSeconds,
    int schoolGrade = 1,
  }) {
    final mathSection = MathSection.values.firstWhere(
      (value) => value.name == section,
      orElse: () => _unitSectionFor(levelNumber),
    );
    final levelDifficulty = Difficulty.values.firstWhere(
      (value) => value.name == difficulty,
      orElse: () => Difficulty.easy,
    );
    return ExamConfig(
      section: mathSection,
      title: title,
      questionCount: questionCount,
      durationSeconds: durationSeconds,
      difficulty: levelDifficulty,
      source: ExamSource.exam,
      levelId: levelId,
      levelNumber: levelNumber,
      schoolGrade: schoolGrade,
      multiplicationTable: multiplicationTableFor(levelNumber),
    );
  }
}
