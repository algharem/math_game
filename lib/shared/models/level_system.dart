class LevelInfo {
  const LevelInfo({
    required this.level,
    required this.title,
    required this.minPoints,
    required this.nextLevelPoints,
  });

  final int level;
  final String title;
  final int minPoints;
  final int? nextLevelPoints;

  bool get isMax => nextLevelPoints == null;

  int get pointsIntoLevel => 0;

  double progress(int points) {
    if (isMax) return 1;
    final span = nextLevelPoints! - minPoints;
    if (span <= 0) return 1;
    final value = (points - minPoints) / span;
    return value.clamp(0, 1).toDouble();
  }
}

class LevelSystem {
  LevelSystem._();

  static const List<({int min, String title})> _levels = [
    (min: 0, title: 'مبتدئ'),
    (min: 100, title: 'متعلم صغير'),
    (min: 300, title: 'بطل الحساب'),
    (min: 600, title: 'بطل الضرب'),
    (min: 1000, title: 'خبير الرياضيات'),
    (min: 1500, title: 'عبقري الحساب'),
  ];

  static LevelInfo fromPoints(int points) {
    var index = 0;
    for (var i = 0; i < _levels.length; i++) {
      if (points >= _levels[i].min) {
        index = i;
      } else {
        break;
      }
    }
    final current = _levels[index];
    final next = index + 1 < _levels.length ? _levels[index + 1].min : null;
    return LevelInfo(
      level: index + 1,
      title: current.title,
      minPoints: current.min,
      nextLevelPoints: next,
    );
  }

  static int pointsForLevel(int level) {
    final index = (level - 1).clamp(0, _levels.length - 1);
    return _levels[index].min;
  }

  static int get maxLevel => _levels.length;
}
