import '../../core/utils/arabic_numbers.dart';
import '../../core/utils/mixed_number_generator.dart';
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
    this.mixedNumber,
  });

  final String id;
  final QuestionKind kind;
  final List<Object?> tokens;
  final int correctAnswer;
  final List<int> choices;
  final String explanation;
  final String? factKey;
  final String? spokenText;

  /// Optional visual mixed-number payload. When present, [choices] are
  /// indices into [MixedNumberQuestion.choices] and [correctAnswer] is the
  /// index of the generated correct choice.
  final MixedNumberQuestion? mixedNumber;

  /// Optional curriculum context, e.g. «الوحدة الخامسة: الكسور • ضرب الكسور».
  final String? topicLabel;

  /// Curriculum topic id when the question came from the topic-filter
  /// exam generator, e.g. `g4_p2_t2`.
  final String? topicId;

  MathSection get section => kind.section;

  bool get isMixedNumber => mixedNumber != null;

  String get equationText => tokens
      .map(
        (token) => token == null
            ? '؟'
            : token is int
                ? ArabicNumbers.formatInt(token)
                : token.toString(),
      )
      .join(' ');

  String get solvedEquationText {
    final mixed = mixedNumber;
    if (mixed != null) {
      return mixed.questionText.replaceFirst(
        '؟',
        mixed.correctAnswer.toArabicString(),
      );
    }
    return tokens
        .map(
          (token) => token == null
              ? ArabicNumbers.formatInt(correctAnswer)
              : token is int
                  ? ArabicNumbers.formatInt(token)
                  : token.toString(),
        )
        .join(' ');
  }

  String get answerText {
    final mixed = mixedNumber;
    if (mixed != null) return mixed.correctAnswer.toArabicString();
    return ArabicNumbers.formatInt(correctAnswer);
  }

  /// Text for one choice value. Mixed-number questions store choice indices
  /// in [choices], so the label comes from the generated visual payload.
  String choiceText(int? choice) {
    if (choice == null) return '—';
    final mixed = mixedNumber;
    if (mixed != null && choice >= 0 && choice < mixed.choices.length) {
      return mixed.choices[choice].toArabicString();
    }
    return ArabicNumbers.formatInt(choice);
  }

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

  bool isCorrect(int? answer) {
    if (answer == null) return false;
    final mixed = mixedNumber;
    if (mixed != null) return mixed.isCorrectChoice(answer);
    return answer == correctAnswer;
  }

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
    MixedNumberQuestion? mixedNumber,
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
      mixedNumber: mixedNumber ?? this.mixedNumber,
    );
  }
}
