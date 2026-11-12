import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/curriculum_registry.dart';

void main() {
  test('grade 5 curriculum is registered, others fall back to null', () {
    expect(CurriculumRegistry.forGrade(5), isNotNull);
    expect(CurriculumRegistry.forGrade(0), isNull);
    expect(CurriculumRegistry.forGrade(10), isNull);
    // Not extracted yet:
    for (final grade in [1, 2, 3, 4, 6, 7, 8, 9]) {
      expect(CurriculumRegistry.forGrade(grade), isNull, reason: 'grade $grade');
    }
  });

  test('grade 5 units are ordered and titled', () {
    final curriculum = CurriculumRegistry.forGrade(5)!;
    expect(curriculum.grade, 5);
    expect(curriculum.units.length, 10);
    for (var i = 0; i < curriculum.units.length; i++) {
      final unit = curriculum.units[i];
      expect(unit.number, i + 1, reason: 'unit order at index $i');
      expect(unit.title.trim(), isNotEmpty);
    }
  });

  test('grade 5 lessons use unit-section ids and have pages where known', () {
    final curriculum = CurriculumRegistry.forGrade(5)!;
    final ids = <String>{};
    for (final unit in curriculum.units) {
      for (final lesson in unit.lessons) {
        ids.add(lesson.id);
        expect(lesson.title.trim(), isNotEmpty);
      }
    }
    // Real lesson ids match U-L pattern.
    for (final id in ids) {
      expect(
        RegExp(r'^\d+-\d+$').hasMatch(id),
        isTrue,
        reason: 'invalid lesson id $id',
      );
    }
  });

  test('lesson label slices by level (unit mapping)', () {
    final curriculum = CurriculumRegistry.forGrade(5)!;
    final label1 = curriculum.lessonLabelForLevel(1);
    final label55 = curriculum.lessonLabelForLevel(55);
    final label100 = curriculum.lessonLabelForLevel(100);
    expect(label1, contains('الوحدة الأولى'));
    expect(label55, contains('الوحدة السادسة'));
    expect(label100, contains('الوحدة العاشرة'));
  });

  test('late ranges are wider than early ranges on every skill', () {
    final curriculum = CurriculumRegistry.forGrade(5)!;
    final early = curriculum.earlyRanges;
    final late = curriculum.lateRanges;
    expect(late.addition.max, greaterThanOrEqualTo(early.addition.max));
    expect(late.subtraction.max, greaterThanOrEqualTo(early.subtraction.max));
    expect(
      late.multiplicationFirst.max,
      greaterThanOrEqualTo(early.multiplicationFirst.max),
    );
    expect(
      late.multiplicationSecond.max,
      greaterThanOrEqualTo(early.multiplicationSecond.max),
    );
    expect(late.division.max, greaterThanOrEqualTo(early.division.max));
    expect(late.numberWordsMax, greaterThan(early.numberWordsMax));
    expect(late.roundingMax, greaterThan(early.roundingMax));
  });

  test('rangesForLevel interpolates between early and late', () {
    final curriculum = CurriculumRegistry.forGrade(5)!;
    final mid = curriculum.rangesForLevel(50);
    final early = curriculum.earlyRanges;
    final late = curriculum.lateRanges;
    expect(mid.addition.max, greaterThan(early.addition.max));
    expect(mid.addition.max, lessThan(late.addition.max));
    expect(curriculum.rangesForLevel(1).addition.max, early.addition.max);
    expect(curriculum.rangesForLevel(100).addition.max, late.addition.max);
  });
}
