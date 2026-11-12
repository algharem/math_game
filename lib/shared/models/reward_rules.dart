class RewardRules {
  RewardRules._();

  static const int correctPoints = 10;
  static const int completionBonus = 20;
  static const int perfectBonus = 30;
  static const int dailyBonus = 20;
  static const int perfectGemBonus = 5;

  static int starsFor(int correct, int total) {
    if (total <= 0) return 0;
    final ratio = correct / total;
    if (ratio >= 1) return 5;
    if (ratio >= 0.9) return 4;
    if (ratio >= 0.75) return 3;
    if (ratio >= 0.6) return 2;
    if (ratio >= 0.4) return 1;
    return 0;
  }

  static int gemsFor(int correct, int total) {
    final base = correct;
    final perfect = total > 0 && correct == total ? perfectGemBonus : 0;
    return base + perfect;
  }

  static int pointsFor({
    required int correct,
    required int total,
    required bool isDaily,
  }) {
    final perfect = total > 0 && correct == total;
    return correct * correctPoints +
        completionBonus +
        (perfect ? perfectBonus : 0) +
        (isDaily ? dailyBonus : 0);
  }

  static String performanceLabel(double accuracy) {
    if (accuracy >= 95) return 'أسطوري';
    if (accuracy >= 85) return 'ممتاز';
    if (accuracy >= 70) return 'جيد جدًا';
    if (accuracy >= 50) return 'جيد';
    return 'بحاجة إلى تدريب';
  }
}

class SevenDayReward {
  const SevenDayReward({
    required this.day,
    required this.stars,
    required this.gems,
  });

  final int day;
  final int stars;
  final int gems;
}

class SevenDayRewards {
  SevenDayRewards._();

  static const List<SevenDayReward> days = [
    SevenDayReward(day: 1, stars: 2, gems: 10),
    SevenDayReward(day: 2, stars: 3, gems: 15),
    SevenDayReward(day: 3, stars: 3, gems: 20),
    SevenDayReward(day: 4, stars: 4, gems: 25),
    SevenDayReward(day: 5, stars: 4, gems: 30),
    SevenDayReward(day: 6, stars: 5, gems: 40),
    SevenDayReward(day: 7, stars: 8, gems: 80),
  ];

  static SevenDayReward forDay(int dayIndex) {
    final safe = dayIndex.clamp(1, 7);
    return days[safe - 1];
  }

  static int rewardDayForStreak(int streak) {
    if (streak <= 0) return 1;
    return ((streak - 1) % 7) + 1;
  }
}
