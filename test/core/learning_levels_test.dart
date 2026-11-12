import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/learning_levels.dart';

void main() {
  group('LevelCatalog', () {
    test('defines exactly one hundred unique levels', () {
      final levels = LevelCatalog.seedLevels;

      expect(levels, hasLength(100));
      expect(
        levels.map((level) => level.number).toSet(),
        hasLength(100),
      );
      expect(levels.first.number, 1);
      expect(levels.last.number, 100);
      for (var number = 1; number <= 100; number++) {
        expect(
          levels.where((level) => level.number == number),
          hasLength(1),
          reason: 'المستوى $number يجب أن يظهر مرة واحدة',
        );
      }
    });

    test('level numbers map back to their seeded section', () {
      for (final level in LevelCatalog.seedLevels) {
        expect(
          MathSection.values.firstWhere(
            (section) =>
                section.name == LevelCatalog.sectionNameFor(level.number),
          ),
          level.section,
        );
        expect(LevelCatalog.sectionLabelFor(level.number), isNotEmpty);
      }
    });

    test('builds a level exam config without losing level metadata', () {
      final config = LevelCatalog.examConfigFor(
        levelId: 42,
        levelNumber: 42,
        title: 'اختبار المستوى',
        section: LevelCatalog.sectionNameFor(42),
        difficulty: 'medium',
        questionCount: 10,
        durationSeconds: 240,
        schoolGrade: 7,
      );

      expect(config.levelId, 42);
      expect(config.levelNumber, 42);
      expect(config.schoolGrade, 7);
      expect(config.section, MathSection.multiplication);
      expect(config.difficulty, Difficulty.medium);
      expect(config.questionCount, 10);
      expect(config.durationSeconds, 240);
      expect(config.isLearningLevel, isTrue);
    });

    test('uses progressive question counts and thresholds', () {
      final levels = LevelCatalog.seedLevels;

      expect(levels[0].questionCount, 5);
      expect(levels[20].questionCount, 8);
      expect(levels[40].questionCount, 10);
      expect(levels[70].questionCount, 12);
      expect(levels[99].questionCount, 15);
      expect(levels[0].passingScore, 60);
      expect(levels[99].passingScore, 80);
      expect(levels[0].timeLimitSeconds, isNull);
      expect(levels[99].timeLimitSeconds, 120);
    });

    test('exposes Arabic difficulty labels', () {
      expect(LevelCatalog.difficultyLabelFor('easy'), 'سهل');
      expect(LevelCatalog.difficultyLabelFor('medium'), 'متوسط');
      expect(LevelCatalog.difficultyLabelFor('hard'), 'صعب');
      expect(LevelCatalog.difficultyLabelFor('custom'), 'custom');
    });
  });
}
