import 'enums.dart';
import '../../core/curriculum/grade_curriculum.dart';
import '../../core/curriculum/curriculum_registry.dart';

class DifficultyProfile {
  const DifficultyProfile._({
    required this.section,
    required this.difficulty,
    required this.levelNumber,
    required this.schoolGrade,
    required this.effectiveRank,
    this.curriculum,
    this.curriculumOverrides = false,
  });

  factory DifficultyProfile.resolve({
    required MathSection section,
    required Difficulty difficulty,
    int? levelNumber,
    int schoolGrade = 1,
  }) {
    final level = levelNumber?.clamp(1, 100).toInt();
    final grade = schoolGrade.clamp(1, 9).toInt();
    final curriculum = CurriculumRegistry.forGrade(grade);
    final levelRank = level ?? _baseRank(difficulty);
    final gradeRank = ((grade - 1) * 100 / 8).round();
    var rank =
        (levelRank * 0.78 + gradeRank * 0.22).round().clamp(1, 100).toInt();
    // When curriculum caps are in play, keep the in-grade level as the
    // authoritative progression signal.
    if (curriculum != null) {
      rank = levelRank.clamp(1, 100).toInt();
    }
    return DifficultyProfile._(
      section: section,
      difficulty: difficulty,
      levelNumber: level,
      schoolGrade: grade,
      effectiveRank: rank,
      curriculum: curriculum,
      curriculumOverrides: curriculum != null,
    );
  }

  final MathSection section;
  final Difficulty difficulty;
  final int? levelNumber;
  final int schoolGrade;
  final int effectiveRank;
  final GradeCurriculum? curriculum;
  final bool curriculumOverrides;

  bool get isLevel => levelNumber != null;
  int get level => levelNumber ?? 0;
  bool get isUpperGrade => schoolGrade >= 4;
  bool get isHighGrade => schoolGrade >= 6;

  static int _baseRank(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.easy => 20,
      Difficulty.medium => 55,
      Difficulty.hard => 85,
      Difficulty.random => 55,
    };
  }

  int get additionMax {
    final curriculumMax = _curriculumRangeMaxOrNull(
      CurriculumSkill.addition,
    );
    if (curriculumMax != null && isLevel) return curriculumMax;
    if (isLevel) {
      if (level <= 10) return 10;
      if (level <= 20) return 20;
      if (level <= 30) {
        return schoolGrade <= 3 ? 20 : (schoolGrade <= 6 ? 30 : 50);
      }
      if (level <= 80) {
        return schoolGrade <= 3 ? 50 : (schoolGrade <= 6 ? 100 : 150);
      }
      if (level <= 90) {
        return schoolGrade <= 3 ? 100 : (schoolGrade <= 6 ? 150 : 200);
      }
      return schoolGrade <= 3 ? 100 : (schoolGrade <= 6 ? 200 : 500);
    }
    return switch (difficulty) {
      Difficulty.easy => schoolGrade <= 3 ? 10 : (schoolGrade <= 6 ? 20 : 30),
      Difficulty.medium =>
        schoolGrade <= 3 ? 20 : (schoolGrade <= 6 ? 50 : 100),
      Difficulty.hard => schoolGrade <= 3 ? 50 : (schoolGrade <= 6 ? 100 : 200),
      Difficulty.random =>
        schoolGrade <= 3 ? 30 : (schoolGrade <= 6 ? 80 : 150),
    };
  }

  int get subtractionMax => additionMax;

  int get multiplicationFirstMax {
    final curriculumMax = _curriculumRangeMaxOrNull(
      CurriculumSkill.multiplication,
    );
    if (curriculumMax != null && isLevel) {
      return curriculumMax;
    }
    if (isLevel) {
      if (level >= 31 && level <= 40) return 5;
      if (level >= 41 && level <= 50) return 10;
      if (level >= 51 && level <= 60) return 12;
      if (level >= 81) {
        return schoolGrade <= 3 ? 5 : (schoolGrade <= 6 ? 10 : 12);
      }
      return 12;
    }
    return switch (difficulty) {
      Difficulty.easy => schoolGrade <= 3 ? 5 : (schoolGrade <= 6 ? 8 : 10),
      Difficulty.medium => schoolGrade <= 3 ? 8 : (schoolGrade <= 6 ? 10 : 12),
      Difficulty.hard => 12,
      Difficulty.random => schoolGrade <= 3 ? 8 : (schoolGrade <= 6 ? 10 : 12),
    };
  }

  int get multiplicationSecondMax {
    final curriculumMax = _curriculumRangeMaxOrNull(
      CurriculumSkill.multiplication,
      secondFactor: true,
    );
    if (curriculumMax != null && isLevel) {
      return curriculumMax;
    }
    if (isLevel) {
      if (level <= 40) {
        return schoolGrade <= 2 ? 5 : (schoolGrade <= 5 ? 10 : 12);
      }
      if (level <= 50) return schoolGrade <= 4 ? 10 : 12;
      if (level <= 60) return 12;
      if (level >= 81) {
        return schoolGrade <= 3 ? 5 : (schoolGrade <= 6 ? 10 : 12);
      }
      return 12;
    }
    return switch (difficulty) {
      Difficulty.easy => schoolGrade <= 3 ? 5 : (schoolGrade <= 6 ? 8 : 10),
      Difficulty.medium => schoolGrade <= 3 ? 8 : (schoolGrade <= 6 ? 10 : 12),
      Difficulty.hard => 12,
      Difficulty.random => schoolGrade <= 3 ? 8 : (schoolGrade <= 6 ? 10 : 12),
    };
  }

  int get divisionMax {
    final curriculumMax = _curriculumRangeMaxOrNull(
      CurriculumSkill.division,
    );
    if (curriculumMax != null && isLevel) return curriculumMax;
    if (isLevel) {
      if (level <= 70) {
        return schoolGrade <= 2 ? 5 : (schoolGrade <= 5 ? 9 : 12);
      }
      if (level <= 80) return schoolGrade <= 3 ? 10 : 12;
      return schoolGrade <= 5 ? 12 : 15;
    }
    return switch (difficulty) {
      Difficulty.easy => schoolGrade <= 3 ? 5 : (schoolGrade <= 6 ? 8 : 10),
      Difficulty.medium => schoolGrade <= 3 ? 9 : 12,
      Difficulty.hard => schoolGrade <= 3 ? 10 : 12,
      Difficulty.random => schoolGrade <= 3 ? 9 : 12,
    };
  }

  double get multiplicationMissingChance {
    final base = isLevel
        ? ((level % 10) + 2) / 14
        : switch (difficulty) {
            Difficulty.easy => 0.15,
            Difficulty.medium => 0.3,
            Difficulty.hard => 0.45,
            Difficulty.random => 0.3,
          };
    final adjusted = base + (isHighGrade ? 0.08 : 0);
    return adjusted.clamp(0.1, 0.6);
  }

  bool get allowsTwoStep {
    if (section != MathSection.mixed && section != MathSection.daily) {
      return false;
    }
    if (isLevel) {
      if (level >= 91) return schoolGrade >= 2;
      if (level >= 81) return schoolGrade >= 4;
      return false;
    }
    return switch (difficulty) {
      Difficulty.easy => false,
      Difficulty.medium => schoolGrade >= 7,
      Difficulty.hard => schoolGrade >= 4,
      Difficulty.random => schoolGrade >= 6,
    };
  }

  int get twoStepOperandMax {
    if (schoolGrade <= 3) return 10;
    if (schoolGrade <= 5) return 12;
    if (schoolGrade <= 7) return 15;
    return 20;
  }

  int get twoStepFactorMax {
    if (curriculumOverrides && curriculum != null) {
      final ranges = curriculum!.rangesForLevel(level);
      return ranges.multiplicationSecond.max.clamp(2, 999999).toInt();
    }
    if (schoolGrade <= 3) return 5;
    if (schoolGrade <= 6) return 10;
    return 12;
  }

  /// Cap from the grade curriculum for [skill], or null when there is no
  /// curriculum for this grade or the exam is not a level-based one.
  int? _curriculumRangeMaxOrNull(
    CurriculumSkill skill, {
    bool secondFactor = false,
  }) {
    final c = curriculum;
    if (c == null || !isLevel) return null;
    final ranges = c.rangesForLevel(level);
    switch (skill) {
      case CurriculumSkill.addition:
        return ranges.addition.max;
      case CurriculumSkill.subtraction:
        return ranges.subtraction.max;
      case CurriculumSkill.multiplication:
      case CurriculumSkill.twoStep:
        return secondFactor
            ? ranges.multiplicationSecond.max
            : ranges.multiplicationFirst.max;
      case CurriculumSkill.division:
        return ranges.division.max;
      case CurriculumSkill.placeValue:
        return ranges.placeValueMax;
      case CurriculumSkill.numberWords:
        return ranges.numberWordsMax;
      case CurriculumSkill.expandedForm:
        return ranges.expandedMax;
      case CurriculumSkill.compareNumbers:
        return ranges.compareMax;
      case CurriculumSkill.rounding:
        return ranges.roundingMax;
    }
  }

  // ---- Curriculum number-sense accessors (null when no curriculum) ----

  int? get numberWordsMax => _curriculumRangeMaxOrNull(
        CurriculumSkill.numberWords,
      );
  int? get expandedMax => _curriculumRangeMaxOrNull(
        CurriculumSkill.expandedForm,
      );
  int? get compareMax => _curriculumRangeMaxOrNull(
        CurriculumSkill.compareNumbers,
      );
  int? get roundingMax => _curriculumRangeMaxOrNull(
        CurriculumSkill.rounding,
      );
  List<int>? get roundingPlaces =>
      curriculum?.rangesForLevel(level).roundingPlaces;
  double? get curriculumKindChance => curriculum?.newQuestionKindChance;
  List<CurriculumSkill>? get curriculumKinds => curriculum?.supportedKinds;
}
