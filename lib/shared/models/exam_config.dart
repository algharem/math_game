import 'enums.dart';
import 'curriculum_topic.dart';

class ExamConfig {
  const ExamConfig({
    required this.section,
    required this.title,
    this.questionCount = 10,
    this.durationSeconds,
    this.answerMode = AnswerMode.multipleChoice,
    this.difficulty = Difficulty.easy,
    this.source = ExamSource.exam,
    this.multiplicationTable,
    this.multiplicationFormat = MultiplicationFormat.mixed,
    this.divisionFormat = DivisionFormat.mixed,
    this.dailyDateKey,
    this.levelId,
    this.levelNumber,
    this.schoolGrade = 1,
    this.topicIds = const [],
    this.bookPart,
    this.examMode = ExamMode.quickPractice,
    this.topicDifficultyLevel = 'medium',
  });

  final MathSection section;
  final String title;
  final int questionCount;
  final int? durationSeconds;
  final AnswerMode answerMode;
  final Difficulty difficulty;
  final ExamSource source;
  final int? multiplicationTable;
  final MultiplicationFormat multiplicationFormat;
  final DivisionFormat divisionFormat;
  final String? dailyDateKey;
  final int? levelId;
  final int? levelNumber;
  final int schoolGrade;

  /// Non-empty → questions come only from these curriculum topics.
  final List<String> topicIds;
  final int? bookPart;
  final ExamMode examMode;

  /// Label of the requested strength for topic exams (easy/medium/hard/mixed).
  final String topicDifficultyLevel;

  bool get isDaily => source == ExamSource.daily;
  bool get isLearningLevel => levelId != null;
  bool get isTimed => durationSeconds != null;

  /// Topic-driven adaptive exam (difficulty swings at runtime).
  bool get isAdaptiveTopicExam =>
      examMode == ExamMode.adaptiveExam && topicIds.isNotEmpty;

  ExamConfig copyWith({
    MathSection? section,
    String? title,
    int? questionCount,
    int? durationSeconds,
    bool clearDuration = false,
    AnswerMode? answerMode,
    Difficulty? difficulty,
    ExamSource? source,
    int? multiplicationTable,
    bool clearMultiplicationTable = false,
    MultiplicationFormat? multiplicationFormat,
    DivisionFormat? divisionFormat,
    String? dailyDateKey,
    int? levelId,
    int? levelNumber,
    int? schoolGrade,
    List<String>? topicIds,
    int? bookPart,
    bool clearBookPart = false,
    ExamMode? examMode,
    String? topicDifficultyLevel,
    bool clearLevel = false,
  }) {
    return ExamConfig(
      section: section ?? this.section,
      title: title ?? this.title,
      questionCount: questionCount ?? this.questionCount,
      durationSeconds:
          clearDuration ? null : (durationSeconds ?? this.durationSeconds),
      answerMode: answerMode ?? this.answerMode,
      difficulty: difficulty ?? this.difficulty,
      source: source ?? this.source,
      multiplicationTable: clearMultiplicationTable
          ? null
          : (multiplicationTable ?? this.multiplicationTable),
      multiplicationFormat: multiplicationFormat ?? this.multiplicationFormat,
      divisionFormat: divisionFormat ?? this.divisionFormat,
      dailyDateKey: dailyDateKey ?? this.dailyDateKey,
      levelId: clearLevel ? null : (levelId ?? this.levelId),
      levelNumber: clearLevel ? null : (levelNumber ?? this.levelNumber),
      schoolGrade: schoolGrade ?? this.schoolGrade,
      topicIds: topicIds ?? this.topicIds,
      bookPart: clearBookPart ? null : (bookPart ?? this.bookPart),
      examMode: examMode ?? this.examMode,
      topicDifficultyLevel: topicDifficultyLevel ?? this.topicDifficultyLevel,
    );
  }
}
