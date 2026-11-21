import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/auth_models.dart';
import '../providers.dart';

class AccountsController extends AsyncNotifier<List<AccountSummary>> {
  @override
  Future<List<AccountSummary>> build() {
    return ref.watch(accountServiceProvider).getAccounts();
  }

  Future<AccountSummary> createStudent({
    required String name,
    required int schoolGrade,
    required int avatarIndex,
    String? password,
  }) async {
    final account = await ref.read(accountServiceProvider).createStudent(
          name: name,
          schoolGrade: schoolGrade,
          avatarIndex: avatarIndex,
          password: password,
        );
    await refreshAccounts();
    return account;
  }

  Future<AccountSummary> updateStudent({
    required AccountSummary account,
    required String name,
    required int schoolGrade,
    required int avatarIndex,
  }) async {
    final updated = await ref.read(accountServiceProvider).updateStudent(
          account: account,
          name: name,
          schoolGrade: schoolGrade,
          avatarIndex: avatarIndex,
        );
    await refreshAccounts();
    return updated;
  }

  Future<void> removeStudent(AccountSummary account) async {
    await ref.read(accountServiceProvider).deactivateStudent(account);
    await refreshAccounts();
  }

  Future<void> resetStudentPassword({
    required String userId,
    required String password,
  }) async {
    await ref.read(accountServiceProvider).resetStudentPassword(
          userId: userId,
          newPassword: password,
        );
    await refreshAccounts();
  }

  Future<void> refreshAccounts() async {
    state = AsyncData(await ref.read(accountServiceProvider).getAccounts());
  }
}

class AuthController extends Notifier<AuthSession?> {
  @override
  AuthSession? build() => null;

  Future<AuthResult> login({
    required String userId,
    required String password,
  }) async {
    final result = await ref.read(accountServiceProvider).login(
          userId: userId,
          password: password,
        );
    if (result.session != null) {
      state = result.session;
      ref.invalidate(accountsProvider);
    }
    return result;
  }

  Future<AuthResult> loginWithUsername({
    required String username,
    required String password,
  }) async {
    final result = await ref.read(accountServiceProvider).loginWithUsername(
          username: username,
          password: password,
        );
    if (result.session != null) {
      state = result.session;
      ref.invalidate(accountsProvider);
    }
    return result;
  }

  Future<AuthResult> loginWithBiometric({
    required String userId,
  }) async {
    final result = await ref.read(accountServiceProvider).loginWithBiometric(
          userId: userId,
        );
    if (result.session != null) {
      state = result.session;
      ref.invalidate(accountsProvider);
    }
    return result;
  }

  Future<AuthResult> setInitialPassword({
    required String userId,
    required String password,
  }) async {
    final result = await ref.read(accountServiceProvider).setInitialPassword(
          userId: userId,
          password: password,
        );
    if (result.session != null) {
      state = result.session;
      ref.invalidate(accountsProvider);
    }
    return result;
  }

  Future<AuthResult> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await ref.read(accountServiceProvider).changePassword(
          userId: userId,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    if (result.session != null) {
      state = result.session;
      ref.invalidate(accountsProvider);
    }
    return result;
  }

  Future<void> logout() async {
    state = null;
    ref.invalidate(accountsProvider);
    ref.read(activeProfileProvider.notifier).clear();
    ref.read(parentSelectedProfileIdProvider.notifier).state = null;
    ref.read(parentUnlockedProvider.notifier).state = false;
    await ref.read(settingsProvider.notifier).selectProfile(null);
  }

  Future<void> refreshCurrentUser() async {
    final current = state;
    if (current == null) return;
    final database = ref.read(databaseProvider);
    final user = await database.getUser(current.user.id);
    if (user == null || !user.isActive) {
      await logout();
      return;
    }
    final profile = user.profileId == null
        ? null
        : await database.getProfile(user.profileId!);
    state = AuthSession(
      AccountSummary(user: user, profile: profile),
    );
  }
}
