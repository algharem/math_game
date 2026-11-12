import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/services/account_service.dart';
import 'package:math_heroes/shared/models/auth_models.dart';

void main() {
  late AppDatabase db;
  late AccountService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = AccountService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('seeds a parent account with default password 123456', () async {
    final accounts = await service.getAccounts();
    final parent = accounts.singleWhere((account) => account.isParent);

    expect(parent.needsPassword, isFalse);
    final login = await service.login(userId: parent.id, password: '123456');
    expect(login.isSuccess, isTrue);
    expect(await service.getParentSession(), isNotNull);
    expect(accounts.where((account) => account.isStudent), isEmpty);
  });

  test('creates and authenticates a student account', () async {
    final created = await service.createStudent(
      name: 'سارة',
      schoolGrade: 3,
      avatarIndex: 2,
      password: 'secret123',
    );

    expect(created.isStudent, isTrue);
    expect(created.profile, isNotNull);
    expect(created.schoolGrade, 3);
    expect(created.needsPassword, isFalse);

    final good = await service.login(
      userId: created.id,
      password: 'secret123',
    );
    expect(good.isSuccess, isTrue);
    expect(good.session?.profile?.id, created.profileId);

    final bad = await service.login(
      userId: created.id,
      password: 'wrong',
    );
    expect(bad.failure, AuthFailure.wrongPassword);

    final accounts = await service.getAccounts();
    expect(accounts, hasLength(2));
  });

  test('forces initial password setup for a legacy student', () async {
    final profile = await db.insertProfile(name: 'طالب قديم', avatarIndex: 0);
    final user = await db.insertUser(
      profileId: profile.id,
      fullName: profile.name,
      role: UserRole.student.name,
      avatarIndex: 0,
    );

    final firstLogin = await service.login(
      userId: user.id,
      password: 'anything',
    );
    expect(firstLogin.requiresSetup, isTrue);

    final setup = await service.setInitialPassword(
      userId: user.id,
      password: 'newpass1',
    );
    expect(setup.isSuccess, isTrue);

    final login = await service.login(
      userId: user.id,
      password: 'newpass1',
    );
    expect(login.isSuccess, isTrue);
  });

  test('changes a password only with the current password', () async {
    final created = await service.createStudent(
      name: 'عمر',
      schoolGrade: 4,
      avatarIndex: 1,
      password: 'oldpass1',
    );

    final wrongCurrent = await service.changePassword(
      userId: created.id,
      currentPassword: 'nope',
      newPassword: 'newpass1',
    );
    expect(wrongCurrent.failure, AuthFailure.wrongPassword);

    final changed = await service.changePassword(
      userId: created.id,
      currentPassword: 'oldpass1',
      newPassword: 'newpass1',
    );
    expect(changed.isSuccess, isTrue);

    expect(
      (await service.login(userId: created.id, password: 'oldpass1')).failure,
      AuthFailure.wrongPassword,
    );
    expect(
      (await service.login(userId: created.id, password: 'newpass1')).isSuccess,
      isTrue,
    );
  });

  test('rejects weak passwords and inactive accounts', () async {
    final created = await service.createStudent(
      name: 'ليان',
      schoolGrade: 2,
      avatarIndex: 3,
      password: 'secret123',
    );

    final weak = await service.changePassword(
      userId: created.id,
      currentPassword: 'secret123',
      newPassword: '123',
    );
    expect(weak.failure, AuthFailure.weakPassword);

    await service.deactivateStudent(created);
    final inactive = await service.login(
      userId: created.id,
      password: 'secret123',
    );
    expect(inactive.failure, AuthFailure.inactive);
  });
}
