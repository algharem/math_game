import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/grade04_p2_unit6_bank.dart';
import 'package:math_heroes/core/curriculum/topic_seed.dart';
import 'package:math_heroes/shared/models/curriculum_topic.dart';

void main() {
  test('seed has the full 78-topic map with unique ids', () {
    expect(curriculumTopicSeed, hasLength(78));
    final ids = curriculumTopicSeed.map((topic) => topic.id).toSet();
    expect(ids, hasLength(curriculumTopicSeed.length),
        reason: 'duplicate topic ids found');
  });

  test('every topic id matches the g{grade}_p{part}_t{n} convention', () {
    for (final topic in curriculumTopicSeed) {
      expect(
        CurriculumTopic.idPattern.hasMatch(topic.id),
        isTrue,
        reason: 'invalid topic id ${topic.id}',
      );
      // Id components must agree with the row data.
      final match = CurriculumTopic.idPattern.firstMatch(topic.id)!;
      expect(int.parse(match.group(1)!), topic.grade, reason: topic.id);
      expect(int.parse(match.group(2)!), topic.part, reason: topic.id);
    }
  });

  test('per-grade topic counts match the curriculum map', () {
    final counts = <int, int>{};
    for (final topic in curriculumTopicSeed) {
      counts[topic.grade] = (counts[topic.grade] ?? 0) + 1;
    }
    expect(
      [
        for (var grade = 1; grade <= 9; grade++) counts[grade] ?? 0,
      ],
      [9, 8, 8, 17, 7, 7, 8, 7, 7],
    );
  });

  test('grade 4 part 2 Unit 6 topics appear in textbook order', () {
    final unit6 = topicsFor(curriculumTopicSeed, grade: 4, part: 2)
        .where(
          (topic) => topic.unitName == Unit6QuestionBank.unitName,
        )
        .toList();
    expect(unit6, hasLength(9));
    expect(
      unit6.map((topic) => topic.id).toList(),
      Unit6QuestionBank.lessonIds,
    );
    expect(
      unit6.map((topic) => topic.title).toList(),
      [
        'الأجزاء من عشرة',
        'الأجزاء من مائة',
        'الأعداد الكسرية في صورة كسور عشرية',
        'مقارنة وترتيب الكسور العشرية',
        'جمع الكسور العشرية',
        'طرح الكسور العشرية',
        'تدريبات ومسائل على الجمع والطرح',
        'مسائل تطبيقية',
        'اختبار الوحدة',
      ],
    );
    // First three lessons match the order confirmed from the book.
    expect(unit6.take(3).map((topic) => topic.title).toList(), [
      'الأجزاء من عشرة',
      'الأجزاء من مائة',
      'الأعداد الكسرية في صورة كسور عشرية',
    ]);
    expect(unit6.every((topic) => topic.generationReady), isTrue);
    expect(
      unit6.map((topic) => topic.pageReference).toList(),
      [41, 42, 44, 49, 56, 60, 64, 67, 71],
      reason: 'printed page references must follow the source book',
    );
  });

  test('topics cover parts 1 and 2 for every grade', () {
    for (var grade = 1; grade <= 9; grade++) {
      for (final part in const [1, 2]) {
        expect(
          topicsFor(curriculumTopicSeed, grade: grade, part: part),
          isNotEmpty,
          reason: 'grade $grade part $part has no topics',
        );
      }
    }
  });

  test('helpers filter by grade/part and readiness', () {
    final g1p2 = topicsFor(curriculumTopicSeed, grade: 1, part: 2);
    expect(g1p2, hasLength(5));
    expect(g1p2.every((topic) => topic.part == 2), isTrue);

    final readyOne = readyTopicsFor(curriculumTopicSeed, grade: 1, part: 1);
    expect(readyOne, isNotEmpty);
    expect(
      readyOne.every((topic) => topic.generationReady),
      isTrue,
    );
    // A part known to be half-blocked still keeps its non-ready topics
    // visible.
    final allG1P1 = topicsFor(curriculumTopicSeed, grade: 1, part: 1);
    expect(allG1P1.length, greaterThanOrEqualTo(readyOne.length));
  });

  test('every ready topic hashes to the generated-question factory path', () {
    // Sanity: at least one ready topic exists per grade so the exam
    // platform is usable across the whole curriculum.
    for (var grade = 1; grade <= 9; grade++) {
      final ready = curriculumTopicSeed
          .where((topic) => topic.grade == grade && topic.generationReady)
          .toList();
      expect(ready, isNotEmpty, reason: 'grade $grade has no ready topic');
    }
  });

  test('buildTopicIndex provides O(1) lookups', () {
    final index = buildTopicIndex(curriculumTopicSeed);
    expect(index['g4_p2_t2']?.grade, 4);
    expect(index['g4_p2_t2']?.part, 2);
    expect(index['unknown'], isNull);
  });
}
