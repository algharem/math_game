import '../../core/utils/arabic_numbers.dart';
import 'enums.dart';

class Question {
  const Question({
    required this.id,
    required this.kind,
    required this.tokens,
    required this.correctAnswer,
    required this.choices,
    required this.explanation,
    this.factKey,
    this.spokenText,
    this.topicLabel,
    this.topicId,
  });

  final String id;
  final QuestionKind kind;
  final List<Object?> tokens;
  final int correctAnswer;
  final List<int> choices;
  final String explanation;
  final String? factKey;
  final String? spokenText;

  /// Optional curriculum context, e.g. «الوحدة الخامسة: الكسور • ضرب الكسور».
  final String? topicLabel;

  /// Curriculum topic id when the question came from the topic-filter
  /// exam generator, e.g. `g4_p2_t2`.
  final String? topicId;

  MathSection get section => kind.section;

  String get equationText => tokens
      .map(
        (token) => token == null
            ? '؟'
            : token is int
                ? ArabicNumbers.formatInt(token)
                : token.toString(),
      )
      .join(' ');

  String get solvedEquationText => tokens
      .map(
        (token) => token == null
            ? ArabicNumbers.formatInt(correctAnswer)
            : token is int
                ? ArabicNumbers.formatInt(token)
                : token.toString(),
      )
      .join(' ');

  String get answerText => ArabicNumbers.formatInt(correctAnswer);

  String get readAloudText {
    if (spokenText != null) return spokenText!;
    final buffer = StringBuffer();
    for (final token in tokens) {
      if (token == null) {
        buffer.write(' كم ');
      } else if (token is int) {
        buffer.write('${ArabicNumbers.formatInt(token)} ');
      } else {
        switch (token.toString()) {
          case '×':
            buffer.write(' ضرب ');
          case '÷':
            buffer.write(' مقسومًا على ');
          case '+':
            buffer.write(' زائد ');
          case '−':
            buffer.write(' ناقص ');
          case '=':
            buffer.write(' يساوي ');
          default:
            buffer.write('$token ');
        }
      }
    }
    return '${buffer.toString().trim()}؟';
  }

  bool isCorrect(int? answer) => answer != null && answer == correctAnswer;

  Question copyWith({
    String? id,
    QuestionKind? kind,
    List<Object?>? tokens,
    int? correctAnswer,
    List<int>? choices,
    String? explanation,
    String? factKey,
    String? spokenText,
    String? topicLabel,
    String? topicId,
  }) {
    return Question(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      tokens: tokens ?? this.tokens,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      choices: choices ?? this.choices,
      explanation: explanation ?? this.explanation,
      factKey: factKey ?? this.factKey,
      spokenText: spokenText ?? this.spokenText,
      topicLabel: topicLabel ?? this.topicLabel,
      topicId: topicId ?? this.topicId,
    );
  }
}
