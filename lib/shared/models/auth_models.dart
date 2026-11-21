import '../../core/database/app_database.dart';

enum UserRole {
  student,
  parent;

  String get label {
    switch (this) {
      case UserRole.student:
        return 'طالب';
      case UserRole.parent:
        return 'ولي أمر';
    }
  }

  static UserRole fromName(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.student,
    );
  }
}

class AccountSummary {
  const AccountSummary({
    required this.user,
    required this.profile,
  });

  final User user;
  final Profile? profile;

  String get id => user.id;
  String get displayName => user.fullName;
  UserRole get role => UserRole.fromName(user.role);
  bool get isParent => role == UserRole.parent;
  bool get isStudent => role == UserRole.student;
  bool get needsPassword =>
      user.passwordHash == null || user.passwordHash!.trim().isEmpty;
  int get avatarIndex => user.avatarIndex;

  /// True for the shared `student1`…`student9` accounts created by
  /// [DevAccountSeeder]. Never grants extra privileges.
  bool get isDevelopment => user.accountType == 'development';

  int get schoolGrade => profile?.schoolGrade ?? 1;
  int get currentLevel => profile?.currentLevel ?? 1;
  int get completedLevels => profile?.totalCompletedLevels ?? 0;
  String? get profileId => profile?.id;

  String get initial {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '؟';
    return parts.first.substring(0, 1);
  }
}

class AuthSession {
  const AuthSession(this.account);

  final AccountSummary account;

  bool get isParent => account.isParent;
  bool get isStudent => account.isStudent;
  User get user => account.user;
  Profile? get profile => account.profile;
}

enum AuthFailure {
  userNotFound,
  wrongPassword,
  inactive,
  passwordRequired,
  passwordMismatch,
  weakPassword,
  passwordAlreadySet,
  profileMissing,
}

extension AuthFailureX on AuthFailure {
  String get message {
    switch (this) {
      case AuthFailure.userNotFound:
        return 'تعذر العثور على الحساب.';
      case AuthFailure.wrongPassword:
        return 'كلمة المرور غير صحيحة.';
      case AuthFailure.inactive:
        return 'هذا الحساب غير نشط.';
      case AuthFailure.passwordRequired:
        return 'يجب تعيين كلمة مرور للحساب أولاً.';
      case AuthFailure.passwordMismatch:
        return 'كلمتا المرور غير متطابقتين.';
      case AuthFailure.weakPassword:
        return 'كلمة المرور يجب أن تكون ٦ أحرف أو أكثر.';
      case AuthFailure.passwordAlreadySet:
        return 'كلمة المرور معيّنة مسبقاً.';
      case AuthFailure.profileMissing:
        return 'ملف الطالب غير موجود.';
    }
  }
}

class AuthResult {
  const AuthResult._({
    this.session,
    this.failure,
    this.requiresSetup = false,
  });

  const AuthResult.success(AuthSession session) : this._(session: session);

  const AuthResult.failure(AuthFailure failure) : this._(failure: failure);

  const AuthResult.setupRequired() : this._(requiresSetup: true);

  final AuthSession? session;
  final AuthFailure? failure;
  final bool requiresSetup;

  bool get isSuccess => session != null;
}

class AccountValidators {
  AccountValidators._();

  static const minimumPasswordLength = 6;

  static String? password(String? value) {
    final password = value ?? '';
    if (password.length < minimumPasswordLength) {
      return 'كلمة المرور يجب أن تكون ٦ أحرف أو أكثر.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) return 'كلمتا المرور غير متطابقتين.';
    return null;
  }

  static String? studentName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'اسم الطالب مطلوب.';
    if (name.length > 24) return 'الاسم طويل جداً.';
    return null;
  }
}

String schoolGradeLabel(int grade) {
  const labels = [
    'الصف الأول',
    'الصف الثاني',
    'الصف الثالث',
    'الصف الرابع',
    'الصف الخامس',
    'الصف السادس',
    'الصف السابع',
    'الصف الثامن',
    'الصف التاسع',
    'الصف العاشر',
    'الصف الحادي عشر',
    'الصف الثاني عشر',
  ];
  if (grade < 1) return labels.first;
  if (grade > labels.length) return labels.last;
  return labels[grade - 1];
}
