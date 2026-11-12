import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/level_system.dart';
import 'package:math_heroes/shared/models/reward_rules.dart';
import 'package:math_heroes/shared/models/stats_models.dart';

void main() {
  group('RewardRules', () {
    test('star thresholds', () {
      expect(RewardRules.starsFor(10, 10), 5);
      expect(RewardRules.starsFor(9, 10), 4);
      expect(RewardRules.starsFor(8, 10), 3);
      expect(RewardRules.starsFor(6, 10), 2);
      expect(RewardRules.starsFor(4, 10), 1);
      expect(RewardRules.starsFor(3, 10), 0);
      expect(RewardRules.starsFor(0, 0), 0);
    });

    test('gems include a perfect bonus', () {
      expect(RewardRules.gemsFor(8, 10), 8);
      expect(RewardRules.gemsFor(10, 10), 15);
    });

    test('points include completion, perfect and daily bonuses', () {
      expect(
        RewardRules.pointsFor(correct: 5, total: 10, isDaily: false),
        70,
      );
      expect(
        RewardRules.pointsFor(correct: 10, total: 10, isDaily: false),
        150,
      );
      expect(
        RewardRules.pointsFor(correct: 10, total: 10, isDaily: true),
        170,
      );
    });

    test('seven-day rewards cycle', () {
      expect(SevenDayRewards.rewardDayForStreak(0), 1);
      expect(SevenDayRewards.rewardDayForStreak(1), 1);
      expect(SevenDayRewards.rewardDayForStreak(7), 7);
      expect(SevenDayRewards.rewardDayForStreak(8), 1);
      expect(SevenDayRewards.forDay(7).stars, 8);
      expect(SevenDayRewards.forDay(99).day, 7);
    });
  });

  group('LevelSystem', () {
    test('maps points to levels', () {
      expect(LevelSystem.fromPoints(0).level, 1);
      expect(LevelSystem.fromPoints(99).level, 1);
      expect(LevelSystem.fromPoints(100).level, 2);
      expect(LevelSystem.fromPoints(1500).level, 6);
      expect(LevelSystem.fromPoints(99999).level, 6);
      expect(LevelSystem.fromPoints(99999).isMax, isTrue);
    });

    test('progress is clamped between zero and one', () {
      final info = LevelSystem.fromPoints(150);
      expect(info.progress(100), 0);
      expect(info.progress(200), closeTo(0.5, 0.0001));
      expect(info.progress(300), 1);
    });
  });

  group('FactMastery', () {
    test('formats multiplication and division labels', () {
      final now = DateTime(2026);
      expect(
        FactMastery(
          section: MathSection.multiplication,
          factKey: 'mul:7:8',
          attempts: 3,
          correct: 2,
          lastSeen: now,
        ).label,
        '7 × 8',
      );
      expect(
        FactMastery(
          section: MathSection.division,
          factKey: 'div:6:4',
          attempts: 3,
          correct: 2,
          lastSeen: now,
        ).label,
        '24 ÷ 6',
      );
      expect(
        FactMastery(
          section: MathSection.mixed,
          factKey: 'mix2:sumprod:2:3:4',
          attempts: 3,
          correct: 2,
          lastSeen: now,
        ).label,
        '(2 + 3) × 4',
      );
      expect(
        FactMastery(
          section: MathSection.mixed,
          factKey: 'mix2:prodsum:2:3:4',
          attempts: 3,
          correct: 2,
          lastSeen: now,
        ).label,
        '(2 × 3) + 4',
      );
    });

    test('weak facts require attempts and low accuracy', () {
      final now = DateTime(2026);
      expect(
        FactMastery(
          section: MathSection.multiplication,
          factKey: 'mul:2:2',
          attempts: 1,
          correct: 0,
          lastSeen: now,
        ).isWeak,
        isFalse,
      );
      expect(
        FactMastery(
          section: MathSection.multiplication,
          factKey: 'mul:2:2',
          attempts: 2,
          correct: 1,
          lastSeen: now,
        ).isWeak,
        isTrue,
      );
    });
  });
}
