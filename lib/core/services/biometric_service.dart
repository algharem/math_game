import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:local_auth/local_auth.dart' show BiometricType;

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

  /// Authenticate user with biometric
  Future<bool> authenticate({
    required String userId,
    String localizedReason = 'المصادقة باستخدام البصمة',
    String? cancelLabel = 'إلغاء',
    String? goToSettingsLabel = 'الإعدادات',
  }) async {
    try {
      // Check if biometric is enabled for this user
      if (!await isBiometricEnabled(userId)) {
        debugPrint('Biometric not enabled for user: $userId');
        return false;
      }

      // Check if biometric is available
      if (!await isBiometricAvailable()) {
        debugPrint('Biometric not available');
        return false;
      }

      // Perform authentication
      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // Record successful authentication
        await _recordBiometricUse(userId);
        debugPrint('Biometric authentication successful for user: $userId');
        return true;
      } else {
        debugPrint('Biometric authentication failed or cancelled');
        return false;
      }
    } catch (error) {
      debugPrint('Biometric authentication error: $error');
      return false;
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