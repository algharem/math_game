import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/services/dev_account_seeder.dart';

/// Records whether the startup path closed the connection it opened.
class _TrackingDatabase extends AppDatabase {
  _TrackingDatabase(super.executor) : super.forTesting();

  bool closed = false;

  @override
  Future<void> close() async {
    closed = true;
    await super.close();
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('startup seeding does nothing when the seed is disabled', () async {
    var opened = false;
    final report = await DevAccountSeeder.seedAtStartup(
      isEnabled: () => false,
      openDatabase: () {
        opened = true;
        return _TrackingDatabase(NativeDatabase.memory());
      },
    );

    expect(report, isNull);
    expect(opened, isFalse, reason: 'a disabled seed must not touch storage');
  });

  test('startup seeding creates the accounts and closes the connection',
      () async {
    final database = _TrackingDatabase(NativeDatabase.memory());
    final report = await DevAccountSeeder.seedAtStartup(
      isEnabled: () => true,
      openDatabase: () => database,
    );

    expect(report, isNotNull);
    expect(report!.createdCount, 9);
    expect(report.mismatchedCount, 0);
    expect(database.closed, isTrue, reason: 'startup must release storage');
  });

  test('startup seeding is idempotent across launches', () async {
    final directory = await Directory.systemTemp.createTemp('math-heroes-');
    addTearDown(() async {
      if (await directory.exists()) await directory.delete(recursive: true);
    });
    final file = File('${directory.path}/math_heroes.sqlite');

    final opened = <_TrackingDatabase>[];
    Future<DevAccountSeedReport?> launch() => DevAccountSeeder.seedAtStartup(
          isEnabled: () => true,
          openDatabase: () {
            final database = _TrackingDatabase(NativeDatabase(file));
            opened.add(database);
            return database;
          },
        );

    final first = await launch();
    expect(first!.createdCount, 9);

    // A second launch opens the same file and creates nothing.
    final second = await launch();
    expect(second!.createdCount, 0);
    expect(second.alreadyPresentCount, 9);
    expect(second.mismatchedCount, 0);

    expect(opened, hasLength(2));
    expect(
      opened.every((database) => database.closed),
      isTrue,
      reason: 'every launch must close its own connection',
    );
  });

  test('a startup failure is swallowed so the app still launches', () async {
    final report = await DevAccountSeeder.seedAtStartup(
      isEnabled: () => true,
      openDatabase: () => throw StateError('storage unavailable'),
    );

    expect(report, isNull);
  });
}
