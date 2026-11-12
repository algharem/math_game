import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/network/lan_connection.dart';
import 'package:math_heroes/core/network/parent_lan_client.dart';
import 'package:math_heroes/core/network/parent_lan_server.dart';
import 'package:math_heroes/core/security/password_hasher.dart';
import 'package:math_heroes/core/services/account_service.dart';
import 'package:math_heroes/shared/models/auth_models.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';
import 'package:math_heroes/shared/models/exam_models.dart';
import 'package:math_heroes/shared/models/question.dart';

void main() {
  late AppDatabase db;
  late ParentLanServer server;
  late String baseUrl;
  late AccountSummary student;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final accountService = AccountService(db);
    final accounts = await accountService.getAccounts();
    final parent = accounts.singleWhere((account) => account.isParent);
    await db.setUserPasswordHash(parent.id, PasswordHasher.hash('parent123'));
    student = await accountService.createStudent(
      name: 'سارة',
      schoolGrade: 3,
      avatarIndex: 1,
      password: 'student123',
    );
    await db.saveExamResult(
      ExamResultData(
        sessionId: 'lan-session-1',
        profileId: student.profileId!,
        config: const ExamConfig(
          section: MathSection.multiplication,
          title: 'تمرين الضرب',
          questionCount: 1,
          multiplicationTable: 2,
          multiplicationFormat: MultiplicationFormat.result,
        ),
        total: 1,
        correct: 1,
        wrong: 0,
        unanswered: 0,
        stars: 1,
        gems: 2,
        points: 10,
        durationSeconds: 5,
        startedAt: DateTime(2026, 1, 1, 10),
        finishedAt: DateTime(2026, 1, 1, 10, 0, 5),
        answers: [
          ExamAnswer(
            question: const Question(
              id: 'q-1',
              kind: QuestionKind.multiplicationResult,
              tokens: [2, '×', 3, '=', null],
              correctAnswer: 6,
              choices: [4, 5, 6, 7],
              explanation: '٢ × ٣ = ٦',
              factKey: 'mul:2:3',
            ),
            childAnswer: 6,
            isCorrect: true,
            timeSpentSeconds: 5,
          ),
        ],
      ),
    );
    server = ParentLanServer(
      database: db,
      address: InternetAddress.loopbackIPv4,
      port: 0,
    );
    await server.start();
    baseUrl = 'http://127.0.0.1:${server.boundPort}';
  });

  tearDown(() async {
    await server.stop();
    await db.close();
  });

  test('requires authentication for parent data', () async {
    final client = ParentLanClient(LanConnectionInfo(baseUrl: baseUrl));
    addTearDown(client.close);
    await client.health();
    await expectLater(
      client.fetchStudents(),
      throwsA(isA<LanApiException>()),
    );
  });

  test('authenticates parent and exposes student data from source DB',
      () async {
    final client = ParentLanClient(LanConnectionInfo(baseUrl: baseUrl));
    addTearDown(client.close);
    await client.authenticate('ولي الأمر', 'parent123');
    final students = await client.fetchStudents();
    expect(students, hasLength(1));
    expect(students.single.profileId, student.profileId);
    expect(students.single.currentLevel, 1);

    final detail = await client.fetchStudentDetail(student.profileId!);
    expect(detail.student.name, 'سارة');
    expect(detail.stats.examsCount, 1);
    expect(detail.stats.todayExamsCount, 0);
    expect(detail.exams, hasLength(1));
    expect(detail.exams.single.status, 'completed');
    expect(detail.levels.totalLevels, 100);
    expect(server.activeSessionCount, 1);
  });

  test('rejects wrong parent credentials', () async {
    final client = ParentLanClient(LanConnectionInfo(baseUrl: baseUrl));
    addTearDown(client.close);
    await expectLater(
      client.authenticate('ولي الأمر', 'wrongpass'),
      throwsA(
        isA<LanApiException>().having(
          (error) => error.unauthorized,
          'unauthorized',
          isTrue,
        ),
      ),
    );
  });
}
