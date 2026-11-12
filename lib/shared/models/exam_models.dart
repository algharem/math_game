import 'enums.dart';
import 'exam_config.dart';
import 'question.dart';
import 'quiz_launch_data.dart';

class ExamAnswer {
  const ExamAnswer({
    required this.question,
    required this.childAnswer,
    required this.isCorrect,
    required this.timeSpentSeconds,
  });

  final Question question;
  final int? childAnswer;
  final bool isCorrect;
  final int timeSpentSeconds;

  bool get isUnanswered => childAnswer == null;

  String get childAnswerText =>
      childAnswer == null ? '—' : childAnswer.toString();
}

class ExamResultData {
  const ExamResultData({
    required this.sessionId,
    required this.profileId,
    required this.config,
    required this.total,
    required this.correct,
    required this.wrong,
    required this.unanswered,
    required this.stars,
    required this.gems,
    required this.points,
    required this.durationSeconds,
    required this.startedAt,
    required this.finishedAt,
    required this.answers,
  });

  final String sessionId;
  final String profileId;
  final ExamConfig config;
  final int total;
  final int correct;
  final int wrong;
  final int unanswered;
  final int stars;
  final int gems;
  final int points;
  final int durationSeconds;
  final DateTime startedAt;
  final DateTime finishedAt;
  final List<ExamAnswer> answers;

  MathSection get section => config.section;
  String get title => config.title;
  Difficulty get difficulty => config.difficulty;
  AnswerMode get answerMode => config.answerMode;
  ExamSource get source => config.source;
  String? get dailyDateKey => config.dailyDateKey;
  int? get levelId => config.levelId;
  int? get levelNumber => config.levelNumber;
  bool get isDaily => config.isDaily;
  bool get isPerfect => total > 0 && correct == total;

  double get accuracy => total == 0 ? 0 : (correct / total) * 100;

  List<ExamAnswer> get mistakes =>
      answers.where((answer) => !answer.isCorrect).toList(growable: false);

  ExamResultData copyWith({
    int? stars,
    int? gems,
    int? points,
  }) {
    return ExamResultData(
      sessionId: sessionId,
      profileId: profileId,
      config: config,
      total: total,
      correct: correct,
      wrong: wrong,
      unanswered: unanswered,
      stars: stars ?? this.stars,
      gems: gems ?? this.gems,
      points: points ?? this.points,
      durationSeconds: durationSeconds,
      startedAt: startedAt,
      finishedAt: finishedAt,
      answers: answers,
    );
  }
}

class ExamSaveOutcome {
  const ExamSaveOutcome({
    required this.stars,
    required this.gems,
    required this.points,
    required this.alreadySaved,
    required this.dailyRewardApplied,
    required this.newAchievements,
  });

  final int stars;
  final int gems;
  final int points;
  final bool alreadySaved;
  final bool dailyRewardApplied;
  final List<String> newAchievements;
}

class ResultArgs {
  const ResultArgs({
    required this.result,
    required this.launchData,
  });

  final ExamResultData result;
  final QuizLaunchData launchData;
}

class RetryArgs {
  const RetryArgs({
    required this.resultArgs,
    required this.onlyMistakes,
  });

  final ResultArgs resultArgs;
  final bool onlyMistakes;
}
