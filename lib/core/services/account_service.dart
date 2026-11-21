import '../database/app_database.dart';
import '../security/password_hasher.dart';
import '../../shared/models/auth_models.dart';

class AccountService {
  AccountService(this._database);

  final AppDatabase _database;

  Future<List<AccountSummary>> getAccounts() async {
    final users = await _database.getActiveUsers();
    final profiles = await _database.getAllProfiles();
    final profilesById = {for (final profile in profiles) profile.id: profile};
    final accounts = users
        .map(
          (user) => AccountSummary(
            user: user,
            profile:
                user.profileId == null ? null : profilesById[user.profileId],
          ),
        )
        .toList(growable: false);
    accounts.sort((a, b) {
      if (a.isParent != b.isParent) return a.isParent ? 1 : -1;
      return a.displayName.compareTo(b.displayName);
    });
    return accounts;
  }

  Future<AccountSummary?> getStudentAccount(String profileId) async {
    final user = await _database.getUserForProfile(profileId);
    if (user == null || !user.isActive) return null;
    final profile = await _database.getProfile(profileId);
    return AccountSummary(user: user, profile: profile);
  }

  Future<AuthResult> login({
    required String userId,
    required String password,
  }) async {
    final user = await _database.getUser(userId);
    if (user == null) return const AuthResult.failure(AuthFailure.userNotFound);
    if (!user.isActive) return const AuthResult.failure(AuthFailure.inactive);
    if (user.passwordHash == null || user.passwordHash!.isEmpty) {
      return const AuthResult.setupRequired();
    }
    if (!PasswordHasher.verify(password, user.passwordHash!)) {
      return const AuthResult.failure(AuthFailure.wrongPassword);
    }
    return _sessionFor(user);
  }

  /// Username-based login for the shared testing students. Unknown and
  /// inactive usernames both report [AuthFailure.userNotFound] so the form
  /// does not reveal which accounts exist.
  Future<AuthResult> loginWithUsername({
    required String username,
    required String password,
  }) async {
    final user = await _database.findActiveUserByUsername(username);
    if (user == null) {
      return const AuthResult.failure(AuthFailure.userNotFound);
    }
    if (user.passwordHash == null || user.passwordHash!.isEmpty) {
      return const AuthResult.setupRequired();
    }
    if (!PasswordHasher.verify(password, user.passwordHash!)) {
      return const AuthResult.failure(AuthFailure.wrongPassword);
    }
    return _sessionFor(user);
  }

  /// Looks up an account by username without authenticating it.
  Future<AccountSummary?> getAccountByUsername(String username) async {
    final user = await _database.findUserByUsername(username);
    if (user == null) return null;
    final profile = user.profileId == null
        ? null
        : await _database.getProfile(user.profileId!);
    return AccountSummary(user: user, profile: profile);
  }

  Future<AuthResult> loginWithBiometric({
    required String userId,
  }) async {
    final user = await _database.getUser(userId);
    if (user == null) return const AuthResult.failure(AuthFailure.userNotFound);
    if (!user.isActive) return const AuthResult.failure(AuthFailure.inactive);
    if (user.passwordHash == null || user.passwordHash!.isEmpty) {
      return const AuthResult.setupRequired();
    }
    // Biometric authentication should be handled by the UI layer
    // This method assumes biometric authentication has already succeeded
    return _sessionFor(user);
  }

  Future<AuthResult> setInitialPassword({
    required String userId,
    required String password,
  }) async {
    final passwordError = AccountValidators.password(password);
    if (passwordError != null) {
      return const AuthResult.failure(AuthFailure.weakPassword);
    }
    final user = await _database.getUser(userId);
    if (user == null) return const AuthResult.failure(AuthFailure.userNotFound);
    if (!user.isActive) return const AuthResult.failure(AuthFailure.inactive);
    if (user.passwordHash != null && user.passwordHash!.isNotEmpty) {
      return const AuthResult.failure(AuthFailure.passwordAlreadySet);
    }
    await _database.setUserPasswordHash(userId, PasswordHasher.hash(password));
    final updated = await _database.getUser(userId);
    if (updated == null) {
      return const AuthResult.failure(AuthFailure.userNotFound);
    }
    return _sessionFor(updated);
  }

  Future<AuthResult> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (AccountValidators.password(newPassword) != null) {
      return const AuthResult.failure(AuthFailure.weakPassword);
    }
    final user = await _database.getUser(userId);
    if (user == null) return const AuthResult.failure(AuthFailure.userNotFound);
    if (!user.isActive) return const AuthResult.failure(AuthFailure.inactive);
    if (user.passwordHash == null ||
        !PasswordHasher.verify(currentPassword, user.passwordHash!)) {
      return const AuthResult.failure(AuthFailure.wrongPassword);
    }
    await _database.setUserPasswordHash(
      userId,
      PasswordHasher.hash(newPassword),
    );
    return _sessionFor(user);
  }

  Future<void> resetStudentPassword({
    required String userId,
    required String newPassword,
  }) async {
    final passwordError = AccountValidators.password(newPassword);
    if (passwordError != null) {
      throw ArgumentError(passwordError);
    }
    await _database.setUserPasswordHash(
      userId,
      PasswordHasher.hash(newPassword),
    );
  }

  Future<AccountSummary> createStudent({
    required String name,
    required int schoolGrade,
    required int avatarIndex,
    String? password,
  }) async {
    final nameError = AccountValidators.studentName(name);
    if (nameError != null) throw ArgumentError(nameError);
    final resolvedPassword = password?.trim().isNotEmpty == true
        ? password!.trim()
        : await _nextDefaultStudentPassword();
    final passwordError = AccountValidators.password(resolvedPassword);
    if (passwordError != null) throw ArgumentError(passwordError);

    return _database.transaction(() async {
      final profile = await _database.insertProfile(
        name: name,
        avatarIndex: avatarIndex,
        schoolGrade: schoolGrade.clamp(1, 12),
      );
      final user = await _database.insertUser(
        profileId: profile.id,
        fullName: profile.name,
        passwordHash: PasswordHasher.hash(resolvedPassword),
        role: UserRole.student.name,
        avatarIndex: avatarIndex,
      );
      return AccountSummary(user: user, profile: profile);
    });
  }

  Future<String> _nextDefaultStudentPassword() async {
    final accounts = await getAccounts();
    final studentCount = accounts.where((a) => a.user.role == 'student').length;
    final ordinal = studentCount + 1;
    final digit = ((ordinal - 1) % 9) + 1;
    return '$digit$digit$digit$digit$digit$digit';
  }

  Future<AccountSummary> updateStudent({
    required AccountSummary account,
    required String name,
    required int schoolGrade,
    required int avatarIndex,
  }) async {
    final nameError = AccountValidators.studentName(name);
    if (nameError != null) throw ArgumentError(nameError);
    final profile = account.profile;
    if (profile == null) throw StateError('Student profile is missing');

    return _database.transaction(() async {
      final updatedProfile = profile.copyWith(
        name: name.trim(),
        avatarIndex: avatarIndex,
        schoolGrade: schoolGrade.clamp(1, 12),
      );
      await _database.updateProfile(updatedProfile);
      final updatedUser = account.user.copyWith(
        fullName: name.trim(),
        avatarIndex: avatarIndex,
      );
      await _database.updateUser(updatedUser);
      return AccountSummary(user: updatedUser, profile: updatedProfile);
    });
  }

  Future<void> deactivateStudent(AccountSummary account) async {
    if (!account.isStudent) {
      throw ArgumentError('Only student accounts can be removed');
    }
    await _database.setUserActive(account.id, false);
  }

  Future<AuthSession?> getParentSession() async {
    final user = await _database.getActiveParentUser();
    if (user == null) return null;
    final result = await _sessionFor(user);
    return result.session;
  }

  Future<AuthResult> _sessionFor(User user) async {
    Profile? profile;
    if (user.profileId != null) {
      profile = await _database.getProfile(user.profileId!);
    }
    final role = UserRole.fromName(user.role);
    if (role == UserRole.student && profile == null) {
      return const AuthResult.failure(AuthFailure.profileMissing);
    }
    return AuthResult.success(
      AuthSession(AccountSummary(user: user, profile: profile)),
    );
  }
}
