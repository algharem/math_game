import '../../core/database/app_database.dart';

enum LearningLevelStatus {
  completed,
  current,
  available,
}

class StudentLevelView {
  const StudentLevelView({
    required this.level,
    required this.progress,
    required this.status,
  });

  final LearningLevel level;
  final StudentLevelProgressData? progress;
  final LearningLevelStatus status;

  int get bestScore => progress?.bestScore ?? 0;
  int get attempts => progress?.attemptsCount ?? 0;
  bool get completed => status == LearningLevelStatus.completed;
  bool get inProgress => progress?.status == 'inProgress';
  DateTime? get completedAt => progress?.completedAt;
}

class StudentLevelOverview {
  StudentLevelOverview({
    required this.profile,
    required this.levels,
    required this.progressByLevelId,
  });

  final Profile profile;
  final List<LearningLevel> levels;
  final Map<int, StudentLevelProgressData> progressByLevelId;

  int get completedCount => progressByLevelId.values
      .where((progress) => progress.status == 'completed')
      .length;

  int get attemptedCount => progressByLevelId.values
      .where((progress) => progress.attemptsCount > 0)
      .length;

  int get totalLevels => levels.length;

  double get completionRatio =>
      totalLevels == 0 ? 0 : completedCount / totalLevels;

  List<StudentLevelView> get views => levels
      .map(
        (level) => StudentLevelView(
          level: level,
          progress: progressByLevelId[level.id],
          status: _statusFor(level),
        ),
      )
      .toList(growable: false);

  StudentLevelView? get currentView {
    for (final view in views) {
      if (view.status == LearningLevelStatus.current) return view;
    }
    return null;
  }

  StudentLevelView? get nextIncomplete {
    for (final view in views) {
      if (!view.completed) return view;
    }
    return null;
  }

  LearningLevelStatus _statusFor(LearningLevel level) {
    final progress = progressByLevelId[level.id];
    if (progress?.status == 'completed') {
      return LearningLevelStatus.completed;
    }
    if (level.levelNumber == profile.currentLevel) {
      return LearningLevelStatus.current;
    }
    return LearningLevelStatus.available;
  }
}
