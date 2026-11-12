import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/shared/models/difficulty_profile.dart';
import 'package:math_heroes/shared/models/enums.dart';

void main() {
  group('DifficultyProfile', () {
    test('level is the primary driver while grade still increases rank', () {
      final low = DifficultyProfile.resolve(
        section: MathSection.addition,
        difficulty: Difficulty.easy,
        levelNumber: 1,
        schoolGrade: 1,
      );
      final lowHighGrade = DifficultyProfile.resolve(
        section: MathSection.addition,
        difficulty: Difficulty.easy,
        levelNumber: 1,
        schoolGrade: 9,
      );
      final high = DifficultyProfile.resolve(
        section: MathSection.addition,
        difficulty: Difficulty.easy,
        levelNumber: 100,
        schoolGrade: 1,
      );

      expect(lowHighGrade.effectiveRank, greaterThan(low.effectiveRank));
      expect(high.effectiveRank, greaterThan(lowHighGrade.effectiveRank));
      expect(
        DifficultyProfile.resolve(
          section: MathSection.addition,
          difficulty: Difficulty.easy,
          levelNumber: 100,
          schoolGrade: 9,
        ).effectiveRank,
        100,
      );
    });

    test('early arithmetic levels keep small-number bounds', () {
      // Grade 5 has a book curriculum that widens early-year caps
      // (consolidation of grade-4 material per the Yemeni textbook);
      // all other grades keep the legacy small-number start.
      for (var grade = 1; grade <= 9; grade++) {
        final profile = DifficultyProfile.resolve(
          section: MathSection.addition,
          difficulty: Difficulty.easy,
          levelNumber: 1,
          schoolGrade: grade,
        );
        if (grade == 5) {
          expect(profile.additionMax, 100);
          expect(profile.subtractionMax, 100);
        } else {
          expect(profile.additionMax, 10);
          expect(profile.subtractionMax, 10);
        }
      }
    });

    test('grade widens arithmetic ranges at higher levels', () {
      final gradeOne = DifficultyProfile.resolve(
        section: MathSection.addition,
        difficulty: Difficulty.easy,
        levelNumber: 21,
        schoolGrade: 1,
      );
      final gradeNine = DifficultyProfile.resolve(
        section: MathSection.addition,
        difficulty: Difficulty.easy,
        levelNumber: 21,
        schoolGrade: 9,
      );

      expect(gradeOne.additionMax, 20);
      expect(gradeNine.additionMax, greaterThan(gradeOne.additionMax));
    });

    test('multiplication and division ranges grow with grade', () {
      final earlyMultiplication = DifficultyProfile.resolve(
        section: MathSection.multiplication,
        difficulty: Difficulty.easy,
        levelNumber: 31,
        schoolGrade: 1,
      );
      final lateMultiplication = DifficultyProfile.resolve(
        section: MathSection.multiplication,
        difficulty: Difficulty.easy,
        levelNumber: 31,
        schoolGrade: 9,
      );
      final earlyDivision = DifficultyProfile.resolve(
        section: MathSection.division,
        difficulty: Difficulty.easy,
        levelNumber: 61,
        schoolGrade: 1,
      );
      final lateDivision = DifficultyProfile.resolve(
        section: MathSection.division,
        difficulty: Difficulty.easy,
        levelNumber: 71,
        schoolGrade: 9,
      );

      expect(
        lateMultiplication.multiplicationSecondMax,
        greaterThan(earlyMultiplication.multiplicationSecondMax),
      );
      expect(lateDivision.divisionMax, greaterThan(earlyDivision.divisionMax));
    });

    test('unlocked two-step expressions require advanced level and grade', () {
      bool allows(int level, int grade) => DifficultyProfile.resolve(
            section: MathSection.mixed,
            difficulty: Difficulty.hard,
            levelNumber: level,
            schoolGrade: grade,
          ).allowsTwoStep;

      expect(allows(81, 3), isFalse);
      expect(allows(81, 4), isTrue);
      expect(allows(91, 2), isTrue);
      expect(allows(70, 9), isFalse);
    });
  });
}
