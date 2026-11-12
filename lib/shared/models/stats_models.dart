import 'enums.dart';

class SubjectPerformance {
  const SubjectPerformance({
    required this.section,
    required this.answered,
    required this.correct,
    required this.wrong,
  });

  final MathSection section;
  final int answered;
  final int correct;
  final int wrong;

  double get accuracy => answered == 0 ? 0 : (correct / answered) * 100;
}

class ProfileStats {
  const ProfileStats({
    required this.examsCount,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unanswered,
    required this.totalStars,
    required this.gems,
    required this.points,
    required this.learningSeconds,
    required this.todayLearningSeconds,
    required this.todayExamsCount,
    required this.subjects,
    required this.lastExamAt,
    required this.bestAccuracy,
    required this.perfectExams,
  });

  final int examsCount;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int unanswered;
  final int totalStars;
  final int gems;
  final int points;
  final int learningSeconds;
  final int todayLearningSeconds;
  final int todayExamsCount;
  final Map<MathSection, SubjectPerformance> subjects;
  final DateTime? lastExamAt;
  final double bestAccuracy;
  final int perfectExams;

  double get accuracy =>
      totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

  SubjectPerformance? performanceFor(MathSection section) => subjects[section];

  List<SubjectPerformance> get sortedSubjects {
    final list = subjects.values.toList();
    list.sort((a, b) => b.accuracy.compareTo(a.accuracy));
    return list;
  }

  static const empty = ProfileStats(
    examsCount: 0,
    totalQuestions: 0,
    correctAnswers: 0,
    wrongAnswers: 0,
    unanswered: 0,
    totalStars: 0,
    gems: 0,
    points: 0,
    learningSeconds: 0,
    todayLearningSeconds: 0,
    todayExamsCount: 0,
    subjects: {},
    lastExamAt: null,
    bestAccuracy: 0,
    perfectExams: 0,
  );
}

class FactMastery {
  const FactMastery({
    required this.section,
    required this.factKey,
    required this.attempts,
    required this.correct,
    required this.lastSeen,
  });

  final MathSection section;
  final String factKey;
  final int attempts;
  final int correct;
  final DateTime lastSeen;

  double get accuracy => attempts == 0 ? 0 : (correct / attempts) * 100;

  bool get isWeak => attempts >= 2 && accuracy < 70;

  String get label {
    final parts = factKey.split(':');
    if (parts.length == 3) {
      if (parts[0] == 'mul') return '${parts[1]} × ${parts[2]}';
      if (parts[0] == 'div') {
        final divisor = int.tryParse(parts[1]) ?? 0;
        final quotient = int.tryParse(parts[2]) ?? 0;
        return '${divisor * quotient} ÷ $divisor';
      }
    }
    if (parts.length == 5 && parts[0] == 'mix2') {
      if (parts[1] == 'sumprod') {
        return '(${parts[2]} + ${parts[3]}) × ${parts[4]}';
      }
      if (parts[1] == 'prodsum') {
        return '(${parts[2]} × ${parts[3]}) + ${parts[4]}';
      }
    }
    return factKey;
  }
}

class TableMastery {
  const TableMastery({
    required this.table,
    required this.attempts,
    required this.correct,
  });

  final int table;
  final int attempts;
  final int correct;

  double get accuracy => attempts == 0 ? 0 : (correct / attempts) * 100;

  bool get mastered => attempts >= 5 && accuracy >= 80;
}

class DailyStatus {
  const DailyStatus({
    required this.completedToday,
    required this.streak,
    required this.weekDays,
    required this.rewardClaimedToday,
    required this.rewardDayIndex,
    required this.canClaimReward,
  });

  final bool completedToday;
  final int streak;
  final List<bool> weekDays;
  final bool rewardClaimedToday;
  final int rewardDayIndex;
  final bool canClaimReward;

  static const empty = DailyStatus(
    completedToday: false,
    streak: 0,
    weekDays: [false, false, false, false, false, false, false],
    rewardClaimedToday: false,
    rewardDayIndex: 1,
    canClaimReward: false,
  );
}
