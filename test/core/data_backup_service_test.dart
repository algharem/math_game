import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/services/biometric_service.dart';
import 'package:math_heroes/core/services/data_backup_service.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _tempDir() {
  final dir = Directory.systemTemp.createTempSync('math_heroes_backup_test');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

String _validBackup(Directory dir) {
  final path = p.join(dir.path, 'math_heroes_backup_20260101_120000.sqlite');
  final db = sqlite3.open(path);
  db.execute('CREATE TABLE profiles (id TEXT PRIMARY KEY)');
  db.execute('CREATE TABLE users (id TEXT PRIMARY KEY)');
  db.execute('CREATE TABLE exam_records (id TEXT PRIMARY KEY)');
  db.execute("INSERT INTO profiles (id) VALUES ('p1')");
  db.dispose();
  return path;
}

void main() {
  group('DataBackupService.verifyBackup', () {
    test('accepts a healthy app backup', () async {
      final dir = _tempDir();
      final path = _validBackup(dir);
      await expectLater(DataBackupService.verifyBackup(path), completes);
    });

    test('rejects a missing file', () async {
      final dir = _tempDir();
      await expectLater(
        DataBackupService.verifyBackup(p.join(dir.path, 'missing.sqlite')),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('غير موجود'),
          ),
        ),
      );
    });

    test('rejects a corrupt sqlite file', () async {
      final dir = _tempDir();
      final path = p.join(dir.path, 'math_heroes_backup_broken.sqlite');
      File(path).writeAsStringSync('not a database at all');
      await expectLater(
        DataBackupService.verifyBackup(path),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects a foreign sqlite file without the app tables', () async {
      final dir = _tempDir();
      final path = p.join(dir.path, 'math_heroes_backup_foreign.sqlite');
      final db = sqlite3.open(path);
      db.execute('CREATE TABLE unrelated (id TEXT PRIMARY KEY)');
      db.dispose();
      await expectLater(
        DataBackupService.verifyBackup(path),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('ليس نسخة احتياطية صالحة'),
          ),
        ),
      );
    });

    test('importing a missing backup file fails with a clear message',
        () async {
      await expectLater(
        DataBackupService.importBackupFile(
          '/tmp/math_heroes_missing_backup.sqlite',
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('غير موجود'),
          ),
        ),
      );
    });
  });

  group('BiometricFailure mapping', () {
    test('maps local_auth platform codes to specific failures', () {
      expect(
        BiometricService.failureForCode('NotEnrolled'),
        BiometricFailure.notEnrolled,
      );
      expect(
        BiometricService.failureForCode('PasscodeNotSet'),
        BiometricFailure.passcodeNotSet,
      );
      expect(
        BiometricService.failureForCode('LockedOut'),
        BiometricFailure.lockedOut,
      );
      expect(
        BiometricService.failureForCode('PermanentlyLockedOut'),
        BiometricFailure.permanentlyLockedOut,
      );
      expect(
        BiometricService.failureForCode('NotAvailable'),
        BiometricFailure.notAvailable,
      );
      expect(
        BiometricService.failureForCode('no_fragment_activity'),
        BiometricFailure.unsupportedActivity,
      );
      expect(
        BiometricService.failureForCode('something_else'),
        BiometricFailure.unknown,
      );
    });

    test('every failure has a distinct Arabic message', () {
      final messages = <String>{};
      for (final failure in BiometricFailure.values) {
        final message = BiometricOutcome.failed(failure).arabicMessage;
        expect(message.trim(), isNotEmpty);
        messages.add(message);
      }
      expect(messages.length, BiometricFailure.values.length);
    });

    test('success outcome has no failure and no error message', () {
      const outcome = BiometricOutcome.success();
      expect(outcome.succeeded, isTrue);
      expect(outcome.failure, isNull);
    });
  });
}
