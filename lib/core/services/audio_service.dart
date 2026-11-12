import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum SoundEffect {
  tap,
  correct,
  wrong,
  star,
  celebration,
  applause,
  trophy,
}

class AudioService {
  AudioService();

  final AudioPlayer _player = AudioPlayer();
  bool enabled = true;
  bool available = true;
  String? lastError;

  static const Map<SoundEffect, String> _assets = {
    SoundEffect.tap: 'audio/tap.wav',
    SoundEffect.correct: 'audio/correct.wav',
    SoundEffect.wrong: 'audio/wrong.wav',
    SoundEffect.star: 'audio/star.wav',
    SoundEffect.celebration: 'audio/celebration.wav',
    SoundEffect.applause: 'audio/applause.wav',
    SoundEffect.trophy: 'audio/trophy.wav',
  };

  Future<void> initialize() async {
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setPlayerMode(PlayerMode.lowLatency);
    } catch (error) {
      available = false;
      lastError = error.toString();
      debugPrint('Audio unavailable: $error');
    }
  }

  Future<void> play(SoundEffect effect, {double volume = 0.85}) async {
    if (!enabled || !available) return;
    try {
      await _player.stop();
      await _player.play(
        AssetSource(_assets[effect] ?? _assets[SoundEffect.tap]!),
        volume: volume,
      );
    } catch (error) {
      lastError = error.toString();
      debugPrint('Sound effect failed: $error');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
