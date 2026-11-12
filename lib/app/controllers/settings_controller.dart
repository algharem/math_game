import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/audio_service.dart';
import '../../core/services/settings_service.dart';
import '../../shared/models/enums.dart';
import '../providers.dart';

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final settings = ref.watch(settingsServiceProvider).load();
    final audio = ref.read(audioServiceProvider);
    audio.enabled = settings.soundEnabled;
    final tts = ref.read(ttsServiceProvider);
    tts.enabled = settings.ttsEnabled;
    unawaited(tts.setRate(settings.speechRate));
    return settings;
  }

  Future<void> _save() => ref.read(settingsServiceProvider).save(state);

  Future<void> setSoundEnabled(bool value) async {
    state = state.copyWith(soundEnabled: value);
    ref.read(audioServiceProvider).enabled = value;
    if (value) {
      unawaited(ref.read(audioServiceProvider).play(SoundEffect.tap));
    }
    await _save();
  }

  Future<void> setTtsEnabled(bool value) async {
    state = state.copyWith(ttsEnabled: value);
    final tts = ref.read(ttsServiceProvider);
    tts.enabled = value;
    if (value) {
      unawaited(tts.initialize(speechRate: state.speechRate));
    }
    await _save();
  }

  Future<void> setSpeechRate(double value) async {
    state = state.copyWith(speechRate: value);
    unawaited(ref.read(ttsServiceProvider).setRate(value));
    await _save();
  }

  Future<void> setLargeText(bool value) async {
    state = state.copyWith(largeText: value);
    await _save();
  }

  Future<void> setHighContrast(bool value) async {
    state = state.copyWith(highContrast: value);
    await _save();
  }

  Future<void> setTimersEnabled(bool value) async {
    state = state.copyWith(timersEnabled: value);
    await _save();
  }

  Future<void> setDailyGoalMinutes(int value) async {
    state = state.copyWith(dailyGoalMinutes: value.clamp(5, 60));
    await _save();
  }

  Future<void> setDefaultDifficulty(Difficulty value) async {
    state = state.copyWith(defaultDifficulty: value);
    await _save();
  }

  Future<void> selectProfile(String? profileId) async {
    state = state.copyWith(
      selectedProfileId: profileId,
      clearSelectedProfile: profileId == null,
    );
    await _save();
  }

  Future<void> setParentPin(String pin) async {
    state = state.copyWith(parentPinHash: AppSettings.hashPin(pin));
    await _save();
  }

  Future<void> resetParentPin() async {
    state = state.copyWith(
      parentPinHash: AppSettings.hashPin(AppSettings.defaultPin),
    );
    await _save();
  }
}
