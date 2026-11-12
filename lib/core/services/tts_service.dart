import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService();

  final FlutterTts _tts = FlutterTts();
  bool initialized = false;
  bool available = false;
  bool enabled = true;
  double rate = 0.45;
  String? lastError;
  String? unavailableReason;

  Future<void> initialize({double speechRate = 0.45}) async {
    if (initialized) return;
    initialized = true;
    rate = speechRate;
    try {
      await _tts.awaitSpeakCompletion(true);
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(1.02);
      await _tts.setVolume(0.95);
      available = await _checkArabicVoice();
      if (!available) {
        unavailableReason =
            'لم يتم العثور على صوت عربي مثبت على هذا الجهاز. يمكنك تثبيت صوت عربي من إعدادات النظام، وسيظل التطبيق يعمل بدون النطق.';
      }
    } catch (error) {
      available = false;
      lastError = error.toString();
      unavailableReason =
          'تعذر تشغيل النطق الصوتي على هذا الجهاز. بقية الأنشطة تعمل بشكل طبيعي.';
      debugPrint('TTS unavailable: $error');
    }
  }

  Future<bool> _checkArabicVoice() async {
    for (final language in ['ar-SA', 'ar-EG', 'ar']) {
      try {
        final result = await _tts.isLanguageAvailable(language);
        if (result == true || result == 1) {
          await _tts.setLanguage(language);
          return true;
        }
      } catch (error) {
        lastError = error.toString();
      }
    }
    return false;
  }

  Future<void> speak(String text) async {
    if (!enabled || !available || text.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _tts.setSpeechRate(rate);
      await _tts.speak(text);
    } catch (error) {
      lastError = error.toString();
      debugPrint('TTS speak failed: $error');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (error) {
      lastError = error.toString();
    }
  }

  Future<void> setRate(double value) async {
    rate = value.clamp(0.2, 0.8);
    if (!available) return;
    try {
      await _tts.setSpeechRate(rate);
    } catch (error) {
      lastError = error.toString();
    }
  }

  Future<void> dispose() async {
    try {
      await _tts.stop();
    } catch (error) {
      lastError = error.toString();
    }
  }
}
