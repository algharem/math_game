import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:local_auth/local_auth.dart' show BiometricType;

/// Why a biometric prompt did not succeed. Keeping this typed lets the UI show
/// an actionable Arabic message instead of a generic "try again".
enum BiometricFailure {
  notEnabled,
  notAvailable,
  notEnrolled,
  passcodeNotSet,
  lockedOut,
  permanentlyLockedOut,
  cancelled,
  unsupportedActivity,
  unknown,
}

class BiometricOutcome {
  const BiometricOutcome.success()
      : succeeded = true,
        failure = null;

  const BiometricOutcome.failed(this.failure) : succeeded = false;

  final bool succeeded;
  final BiometricFailure? failure;

  String get arabicMessage {
    switch (failure) {
      case BiometricFailure.notEnabled:
        return 'المصادقة الحيوية غير مفعلة لهذا الحساب.';
      case BiometricFailure.notAvailable:
        return 'جهازك لا يدعم المصادقة الحيوية.';
      case BiometricFailure.notEnrolled:
        return 'لم تسجّل بصمة أو تعرف وجه على هذا الجهاز. أضفها من إعدادات الجهاز ثم حاول مرة أخرى.';
      case BiometricFailure.passcodeNotSet:
        return 'يجب تفعيل قفل الشاشة (رمز PIN أو نمط أو كلمة مرور) لاستخدام المصادقة الحيوية.';
      case BiometricFailure.lockedOut:
        return 'محاولات كثيرة غير ناجحة. انتظر قليلاً ثم حاول مرة أخرى.';
      case BiometricFailure.permanentlyLockedOut:
        return 'تم قفل المصادقة الحيوية. افتح قفل الشاشة على جهازك ثم حاول مجدداً.';
      case BiometricFailure.cancelled:
        return 'تم إلغاء المصادقة الحيوية.';
      case BiometricFailure.unsupportedActivity:
        return 'تعذر تشغيل المصادقة الحيوية على هذا الجهاز.';
      case BiometricFailure.unknown:
      case null:
        return 'تعذر تفعيل المصادقة الحيوية. حاول مرة أخرى.';
    }
  }
}

class BiometricService {
  BiometricService();

  final LocalAuthentication _auth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled_';
  static const String _biometricLastUsedKey = 'biometric_last_used_';

  /// Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (error) {
      debugPrint('Biometric check failed: $error');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (error) {
      debugPrint('Get available biometrics failed: $error');
      return [];
    }
  }

  /// Check if biometric is enabled for a specific user
  Future<bool> isBiometricEnabled(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_biometricEnabledKey$userId') ?? false;
  }

  /// Enable or disable biometric for a specific user
  Future<void> setBiometricEnabled(String userId, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_biometricEnabledKey$userId', enabled);
  }

  /// Authenticate user with biometric.
  ///
  /// [requireEnabled] is false while the user is turning biometric login on:
  /// the flag is only written after a successful prompt, so checking it first
  /// would always fail.
  Future<bool> authenticate({
    required String userId,
    String localizedReason = 'المصادقة باستخدام البصمة',
    String? cancelLabel = 'إلغاء',
    String? goToSettingsLabel = 'الإعدادات',
    bool requireEnabled = true,
  }) async {
    final outcome = await authenticateWithDetails(
      userId: userId,
      localizedReason: localizedReason,
      cancelLabel: cancelLabel,
      goToSettingsLabel: goToSettingsLabel,
      requireEnabled: requireEnabled,
    );
    return outcome.succeeded;
  }

  /// Same as [authenticate] but reports *why* it failed so the UI can show a
  /// specific Arabic message instead of a generic "try again".
  Future<BiometricOutcome> authenticateWithDetails({
    required String userId,
    String localizedReason = 'المصادقة باستخدام البصمة',
    String? cancelLabel = 'إلغاء',
    String? goToSettingsLabel = 'الإعدادات',
    bool requireEnabled = true,
  }) async {
    if (requireEnabled && !await isBiometricEnabled(userId)) {
      debugPrint('Biometric not enabled for user: $userId');
      return const BiometricOutcome.failed(BiometricFailure.notEnabled);
    }

    if (!await isBiometricAvailable()) {
      final enrolled = await getAvailableBiometrics();
      debugPrint('Biometric not available. Enrolled types: $enrolled');
      return BiometricOutcome.failed(
        enrolled.isEmpty
            ? BiometricFailure.notEnrolled
            : BiometricFailure.notAvailable,
      );
    }

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!authenticated) {
        return const BiometricOutcome.failed(BiometricFailure.cancelled);
      }

      await _recordBiometricUse(userId);
      debugPrint('Biometric authentication successful for user: $userId');
      return const BiometricOutcome.success();
    } on PlatformException catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
            'Biometric PlatformException: ${error.code} ${error.message}');
        debugPrintStack(stackTrace: stackTrace);
      }
      return BiometricOutcome.failed(failureForCode(error.code));
    } catch (error, stackTrace) {
      if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
      debugPrint('Biometric authentication error: $error');
      return const BiometricOutcome.failed(BiometricFailure.unknown);
    }
  }

  @visibleForTesting
  static BiometricFailure failureForCode(String? code) {
    switch (code) {
      case 'NotEnrolled':
        return BiometricFailure.notEnrolled;
      case 'PasscodeNotSet':
        return BiometricFailure.passcodeNotSet;
      case 'LockedOut':
        return BiometricFailure.lockedOut;
      case 'PermanentlyLockedOut':
        return BiometricFailure.permanentlyLockedOut;
      case 'NotAvailable':
        return BiometricFailure.notAvailable;
      case 'no_fragment_activity':
        return BiometricFailure.unsupportedActivity;
      default:
        return BiometricFailure.unknown;
    }
  }

  /// Check if biometric was recently used (within last 24 hours)
  Future<bool> wasRecentlyAuthenticated(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastUsedTimestamp = prefs.getInt('$_biometricLastUsedKey$userId');
    if (lastUsedTimestamp == null) return false;

    final lastUsed = DateTime.fromMillisecondsSinceEpoch(lastUsedTimestamp);
    final now = DateTime.now();
    final difference = now.difference(lastUsed);

    // Consider recently used if within last 24 hours
    return difference.inHours < 24;
  }

  /// Record successful biometric authentication
  Future<void> _recordBiometricUse(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('$_biometricLastUsedKey$userId', now);
  }

  /// Clear biometric data for a user
  Future<void> clearBiometricData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_biometricEnabledKey$userId');
    await prefs.remove('$_biometricLastUsedKey$userId');
  }

  /// Get biometric display name
  String getBiometricDisplayName(List<BiometricType> availableBiometrics) {
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'البصمة';
    } else if (availableBiometrics.contains(BiometricType.face)) {
      return 'التعرف على الوجه';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'القزحية';
    } else {
      return 'المصادقة الحيوية';
    }
  }
}
