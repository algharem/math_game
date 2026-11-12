import '../../shared/models/enums.dart';

/// Skills a curriculum unit/grade can exercise.
/// The first four are the original engine sections; the rest map to
/// textbook "الجملة العددية" (number sense) lessons.
enum CurriculumSkill {
  addition,
  subtraction,
  multiplication,
  division,
  twoStep,
  // Number-sense kinds (grade-book driven, MCQ-friendly):
  placeValue,
  numberWords,
  expandedForm,
  compareNumbers,
  rounding,
}

/// A lesson row from the textbook TOC, e.g. "5-6 ضرب الكسور (ص33)".
class CurriculumLesson {
  const CurriculumLesson({
    required this.id,
    required this.title,
    this.page,
  });

  final String id;
  final String title;
  final int? page;
}

class CurriculumUnit {
  const CurriculumUnit({
    required this.number,
    required this.title,
    required this.lessons,
    this.skills = const [],
  });

  final int number;
  final String title;
  final List<CurriculumLesson> lessons;
  final List<CurriculumSkill> skills;

  /// Lesson picked at relative position [0..1] inside the unit — used to
  /// label questions with a concrete lesson name.
  CurriculumLesson? lessonAt(double t) {
    if (lessons.isEmpty) return null;
    final index = (t.clamp(0.0, 0.999) * lessons.length).floor();
    return lessons[index];
  }
}

/// Numeric bounds for one skill, mirroring the textbook's own limits
/// (e.g. "الأعداد ضمن مئات الملايين").
class SkillRange {
  const SkillRange({required this.min, required this.max}) : assert(min <= max);

  final int min;
  final int max;
}

class GradeRanges {
  const GradeRanges({
    this.addition = const SkillRange(min: 1, max: 100),
    this.subtraction = const SkillRange(min: 1, max: 100),
    this.multiplicationFirst = const SkillRange(min: 1, max: 12),
    this.multiplicationSecond = const SkillRange(min: 1, max: 12),
    this.division = const SkillRange(min: 2, max: 12),
    // Number-sense ranges:
    this.placeValueMax = 1000,
    this.numberWordsMax = 100000,
    this.compareMax = 10000,
    this.roundingMax = 10000,
    this.expandedMax = 10000,
    this.roundingPlaces = const [10, 100, 1000],
  });

  final SkillRange addition;
  final SkillRange subtraction;
  final SkillRange multiplicationFirst;
  final SkillRange multiplicationSecond;
  final SkillRange division;

  /// Largest operand used in place-value style questions.
  final int placeValueMax;
  final int numberWordsMax;
  final int compareMax;
  final int roundingMax;
  final int expandedMax;

  /// Rounding targets in increasing size, e.g. [10, 100, 1000].
  /// Keep values as powers of ten.
  final List<int> roundingPlaces;
}

/// One school grade's syllabus: units ordered like the book, plus numeric
/// caps so exams mirror what the book teaches.
class GradeCurriculum {
  const GradeCurriculum({
    required this.grade,
    required this.bookLabel,
    required this.units,
    required this.earlyRanges,
    required this.lateRanges,
    this.newQuestionKindChance = 0.25,
    this.supportedKinds = const [
      CurriculumSkill.addition,
      CurriculumSkill.subtraction,
      CurriculumSkill.multiplication,
      CurriculumSkill.division,
      CurriculumSkill.numberWords,
      CurriculumSkill.expandedForm,
      CurriculumSkill.compareNumbers,
      CurriculumSkill.rounding,
    ],
  });

  final int grade;
  final String bookLabel;
  final List<CurriculumUnit> units;
  final GradeRanges earlyRanges;
  final GradeRanges lateRanges;

  /// Probability that a mixed/daily slot uses a curriculum number-sense kind.
  final double newQuestionKindChance;
  final List<CurriculumSkill> supportedKinds;

  bool supports(CurriculumSkill skill) => supportedKinds.contains(skill);

  /// Syllabus slice: which unit corresponds to the current level (1..100)?
  CurriculumUnit unitForLevel(int level) {
    final units = List<CurriculumUnit>.from(this.units);
    if (units.isEmpty) {
      return const CurriculumUnit(number: 0, title: '', lessons: []);
    }
    final clamped = level.clamp(1, 100);
    final index = ((clamped - 1) / (100 / units.length)).floor();
    return units[index.clamp(0, units.length - 1)];
  }

  /// Lesson label for the current level (unit + specific lesson).
  String lessonLabelForLevel(int level) {
    final unit = unitForLevel(level);
    if (unit.title.isEmpty) return '';
    final t = (level - 1) / 99;
    final lesson = unit.lessonAt(t);
    final unitText = 'الوحدة ${_arabicWord(unit.number)}: ${unit.title}';
    if (lesson == null || lesson.title.isEmpty) return unitText;
    return '$unitText • ${lesson.title}';
  }

  /// Blend between early and late year ranges by exam level.
  GradeRanges rangesForLevel(int level) {
    final t = ((level.clamp(1, 100) - 1) / 99).clamp(0.0, 1.0);
    if (t <= 0.001) return earlyRanges;
    if (t >= 0.999) return lateRanges;
    GradeRanges blend(GradeRanges a, GradeRanges b) => GradeRanges(
          addition: _lerp(a.addition, b.addition, t),
          subtraction: _lerp(a.subtraction, b.subtraction, t),
          multiplicationFirst:
              _lerp(a.multiplicationFirst, b.multiplicationFirst, t),
          multiplicationSecond:
              _lerp(a.multiplicationSecond, b.multiplicationSecond, t),
          division: _lerp(a.division, b.division, t),
          placeValueMax: _lerpInt(a.placeValueMax, b.placeValueMax, t),
          numberWordsMax: _lerpInt(a.numberWordsMax, b.numberWordsMax, t),
          compareMax: _lerpInt(a.compareMax, b.compareMax, t),
          roundingMax: _lerpInt(a.roundingMax, b.roundingMax, t),
          expandedMax: _lerpInt(a.expandedMax, b.expandedMax, t),
          roundingPlaces: a.roundingPlaces == b.roundingPlaces
              ? a.roundingPlaces
              : (t < 0.5 ? a.roundingPlaces : b.roundingPlaces),
        );
    return blend(earlyRanges, lateRanges);
  }

  static SkillRange _lerp(SkillRange a, SkillRange b, double t) {
    return SkillRange(
      min: _lerpInt(a.min, b.min, t),
      max: _lerpInt(a.max, b.max, t),
    );
  }

  static int _lerpInt(int a, int b, double t) {
    return (a + (b - a) * t).round();
  }

  static String _arabicWord(int number) {
    final words = const [
      '',
      'الأولى',
      'الثانية',
      'الثالثة',
      'الرابعة',
      'الخامسة',
      'السادسة',
      'السابعة',
      'الثامنة',
      'التاسعة',
      'العاشرة',
      'الحادية عشرة',
      'الثانية عشرة',
    ];
    if (number >= 1 && number < words.length) return words[number];
    return '$number';
  }
}

/// Maps a curriculum skill to the engine [QuestionKind] used for MCQs.
QuestionKind kindForSkill(CurriculumSkill skill) {
  switch (skill) {
    case CurriculumSkill.numberWords:
      return QuestionKind.numberWords;
    case CurriculumSkill.expandedForm:
      return QuestionKind.expandedForm;
    case CurriculumSkill.compareNumbers:
      return QuestionKind.compareNumbers;
    case CurriculumSkill.rounding:
      return QuestionKind.rounding;
    case CurriculumSkill.placeValue:
      return QuestionKind.numberWords;
    default:
      // Arithmetic skills keep their existing engine kinds.
      return switch (skill) {
        CurriculumSkill.addition => QuestionKind.addition,
        CurriculumSkill.subtraction => QuestionKind.subtraction,
        CurriculumSkill.multiplication => QuestionKind.multiplicationResult,
        CurriculumSkill.division => QuestionKind.divisionQuotient,
        CurriculumSkill.twoStep => QuestionKind.mixedExpression,
        _ => QuestionKind.addition,
      };
  }
}
