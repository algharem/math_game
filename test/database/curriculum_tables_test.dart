import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/grade04_p2_unit6_bank.dart';
import 'package:math_heroes/core/database/app_database.dart';

void main() {
  test('fresh database seeds all 78 curriculum topics without regression',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    expect(await db.getCurriculumTopics(grade: 1, part: 1), hasLength(4));
    expect(await db.getCurriculumTopics(grade: 1, part: 2), hasLength(5));
    expect(await db.getCurriculumTopics(grade: 5, part: 1), hasLength(3));
    expect(await db.getCurriculumTopics(grade: 9, part: 2), hasLength(3));
    // Existing grade 4 part 1 content is untouched.
    expect(await db.getCurriculumTopics(grade: 4, part: 1), hasLength(3));

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

  test('Unit 6 topics persist in textbook order and remain selectable',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final topics = await db.getCurriculumTopics(grade: 4, part: 2);
    // 5 original topics + 9 new Unit 6 lessons.
    expect(topics, hasLength(14));
    // Numeric suffix ordering: t1…t9 before t10…t14.
    expect(
      topics.map((topic) => topic.id).toList(),
      [
        'g4_p2_t1',
        'g4_p2_t2',
        'g4_p2_t3',
        'g4_p2_t4',
        'g4_p2_t5',
        'g4_p2_t6',
        'g4_p2_t7',
        'g4_p2_t8',
        'g4_p2_t9',
        'g4_p2_t10',
        'g4_p2_t11',
        'g4_p2_t12',
        'g4_p2_t13',
        'g4_p2_t14',
      ],
    );
    final unit6 = topics
        .where((topic) => topic.unitName == Unit6QuestionBank.unitName)
        .toList();
    expect(
        unit6.map((topic) => topic.title).toList(),
        Unit6QuestionBank.lessonIds
            .map((id) => Unit6QuestionBank.lessonNames[id])
            .toList());
    expect(unit6.every((topic) => topic.generationReady), isTrue);

    // Saved selections round-trip for the new unit.
    final profile = await db.insertProfile(name: 'طالب', avatarIndex: 0);
    await db.saveTopicSelection(
      profileId: profile.id,
      grade: 4,
      part: 2,
      topicIds: const ['g4_p2_t6', 'g4_p2_t8'],
    );
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 4, part: 2),
      ['g4_p2_t6', 'g4_p2_t8'],
    );
  });

  test('reopening an older database adds Unit 6 topics and keeps old data',
      () async {
    // A file-backed database survives close/reopen, unlike an in-memory one.
    final file = File(
      '/tmp/opencode/unit6_reopen_${DateTime.now().microsecondsSinceEpoch}.sqlite',
    );
    addTearDown(() {
      if (file.existsSync()) file.deleteSync();
    });
    var db = AppDatabase.forTesting(NativeDatabase(file));

    // Simulate an install created before Unit 6: drop only the new rows and
    // leave all pre-existing curriculum content untouched.
    await (db.delete(db.curriculumTopics)
          ..where((topic) => topic.id.isIn(Unit6QuestionBank.lessonIds)))
        .go();
    expect(await db.getCurriculumTopics(grade: 4, part: 2), hasLength(5));

    // Prior user data: profile, saved topic selection, and a stored result.
    final profile = await db.insertProfile(
      name: 'طالب قديم',
      avatarIndex: 0,
      schoolGrade: 4,
    );
    await db.saveTopicSelection(
      profileId: profile.id,
      grade: 4,
      part: 2,
      topicIds: const ['g4_p2_t1'],
    );
    await db.customStatement('''
      INSERT INTO exam_records (
        session_id, profile_id, section, title, difficulty, answer_mode,
        source, total, correct, wrong, unanswered, stars_earned, gems_earned,
        points_earned, duration_seconds, created_at
      ) VALUES (
        'legacy-results-session', '${profile.id}', 'addition', 'نتيجة قديمة',
        'easy', 'multipleChoice', 'exam', 5, 4, 1, 0, 2, 3, 40, 30,
        1735689600000
      )
    ''');
    await db.close();

    // Reopen with the new seed: beforeOpen re-seeds idempotently, so the
    // returning user gains Unit 6 without any migration or data loss.
    db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db.close);

    final g4p2 = await db.getCurriculumTopics(grade: 4, part: 2);
    expect(g4p2, hasLength(14));
    expect(
      g4p2.where((topic) => topic.unitName == Unit6QuestionBank.unitName),
      hasLength(9),
    );

    final restored = await db.getProfile(profile.id);
    expect(restored, isNotNull);
    expect(restored!.name, 'طالب قديم');
    expect(restored.schoolGrade, 4);
    expect(
      await db.getTopicSelection(profileId: profile.id, grade: 4, part: 2),
      ['g4_p2_t1'],
    );
    expect(
      (await db.getExamHistory(profile.id))
          .any((exam) => exam.sessionId == 'legacy-results-session'),
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
