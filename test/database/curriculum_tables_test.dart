import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';

void main() {
  test('fresh database seeds all 68 curriculum topics', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    expect(await db.getCurriculumTopics(grade: 1, part: 1), hasLength(4));
    expect(await db.getCurriculumTopics(grade: 1, part: 2), hasLength(5));
    expect(await db.getCurriculumTopics(grade: 5, part: 1), hasLength(3));
    expect(await db.getCurriculumTopics(grade: 9, part: 2), hasLength(3));

    final topics = await db.getCurriculumTopics(grade: 2, part: 1);
    for (final topic in topics) {
      expect(topic.id, matches(RegExp(r'^g2_p1_t\d+$')));
      expect(topic.title.trim(), isNotEmpty);
      expect(topic.unitName.trim(), isNotEmpty);
    }
    // Availability flags survive the round-trip.
    final blocked = await db.getCurriculumTopics(grade: 5, part: 1);
    expect(
      blocked.any((topic) => topic.id == 'g5_p1_t3' && !topic.generationReady),
      isFalse,
    );
    expect(
      blocked.any((topic) => topic.id == 'g5_p1_t1' && topic.generationReady),
      isTrue,
    );
  });

  test('topic selection is persisted and replaced per profile/grade/part',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final profile = await db.insertProfile(name: 'سنة', avatarIndex: 0);

    expect(
      await db.getTopicSelection(
        profileId: profile.id,
        grade: 1,
        part: 1,
      ),
      isEmpty,
    );

    await db.saveTopicSelection(
      profileId: profile.id,
      grade: 1,
      part: 1,
      topicIds: const ['g1_p1_t1', 'g1_p1_t3'],
    );
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 1, part: 1),
      ['g1_p1_t1', 'g1_p1_t3'],
    );

    // Overwrite (upsert) — not append.
    await db.saveTopicSelection(
      profileId: profile.id,
      grade: 1,
      part: 1,
      topicIds: const ['g1_p1_t2'],
    );
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 1, part: 1),
      ['g1_p1_t2'],
    );

    // Different part keeps its own selection.
    await db.saveTopicSelection(
      profileId: profile.id,
      grade: 1,
      part: 2,
      topicIds: const ['g1_p2_t1'],
    );
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 1, part: 2),
      ['g1_p2_t1'],
    );
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 1, part: 1),
      ['g1_p1_t2'],
    );

    // Empty selection is valid (useapi clears the checklist).
    await db.saveTopicSelection(
      profileId: profile.id,
      grade: 1,
      part: 2,
      topicIds: const [],
    );
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 1, part: 2),
      isEmpty,
    );
  });
}
