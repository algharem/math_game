import '../../core/utils/arabic_numbers.dart';
import '../../core/utils/fraction_order_generator.dart';
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
    this.fractionOrder,
    this.promptText,
    this.correctAnswerText,
    this.choiceTexts,
    this.difficultyRank,
    this.sourcePage,
    this.verificationStatus,
    this.lessonName,
    this.skill,
    this.questionTypeLabel,
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

  /// Optional visual fraction-ordering payload. When present, [choices] hold
  /// the four 1-based ranks and [correctAnswer] is the target's rank.
  final FractionOrderQuestion? fractionOrder;

  /// Optional curriculum context, e.g. «الوحدة الخامسة: الكسور • ضرب الكسور».
  final String? topicLabel;

  /// Curriculum topic id when the question came from the topic-filter
  /// exam generator, e.g. `g4_p2_t2`.
  final String? topicId;

  /// Full authored Arabic prompt. When set it replaces the numeric
  /// [equationText] so textbook wording and decimals render exactly.
  final String? promptText;

  /// Display form of the correct answer, e.g. `١٫٢٥` or `صحيح`.
  final String? correctAnswerText;

  /// Display forms parallel to [choices] (answers stay 0-based indices for
  /// authored questions so decimal values survive the int-based engine).
  final List<String>? choiceTexts;

  /// Authored difficulty on the app's 1–100 scale.
  final int? difficultyRank;

  /// Printed textbook page this question's skill was verified against.
  final int? sourcePage;

  /// Source-verification state recorded with the authored question.
  final String? verificationStatus;

  /// Lesson title exactly as printed in the source book.
  final String? lessonName;

  /// Sub-skill practised by this question.
  final String? skill;

  /// Pedagogical type label, e.g. «اختيار متعدد» or «صح وخطأ».
  final String? questionTypeLabel;

  MathSection get section => kind.section;

  bool get isMixedNumber => mixedNumber != null;

  bool get isFractionOrder => fractionOrder != null;

  /// True when the prompt and/or choices need a custom visual renderer.
  bool get isVisual => mixedNumber != null || fractionOrder != null;

  /// Authored bank questions carry their own wording and decimal-safe
  /// choice labels, so they are always answered by tapping a choice.
  bool get isAuthoredBankQuestion => promptText != null && choiceTexts != null;

  String get equationText => tokens
      .map(
        (token) => token == null
            ? '؟'
            : token is int
                ? ArabicNumbers.formatInt(token)
                : token.toString(),
      )
      .join(' ');

  /// Prompt shown by the shared renderer: authored wording wins, generated
  /// questions keep the existing numeric expression.
  String get displayPrompt => promptText ?? equationText;

  String get solvedEquationText {
    final mixed = mixedNumber;
    if (mixed != null) {
      return mixed.questionText.replaceFirst(
        '؟',
        mixed.correctAnswer.toArabicString(),
      );
    }
    final order = fractionOrder;
    if (order != null) return order.ascendingText;
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
    final authored = correctAnswerText;
    if (authored != null) return authored;
    final mixed = mixedNumber;
    if (mixed != null) return mixed.correctAnswer.toArabicString();
    return ArabicNumbers.formatInt(correctAnswer);
  }

  /// Text for one choice value. Authored questions store decimal-safe
  /// labels in [choiceTexts], mixed-number questions store indices into
  /// their visual payload, and generated questions store plain integers.
  String choiceText(int? choice) {
    if (choice == null) return '—';
    final labels = choiceTexts;
    if (labels != null && choice >= 0 && choice < labels.length) {
      return labels[choice];
    }
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
    final order = fractionOrder;
    if (order != null) return order.isCorrectRank(answer);
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
    FractionOrderQuestion? fractionOrder,
    String? promptText,
    String? correctAnswerText,
    List<String>? choiceTexts,
    int? difficultyRank,
    int? sourcePage,
    String? verificationStatus,
    String? lessonName,
    String? skill,
    String? questionTypeLabel,
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
      fractionOrder: fractionOrder ?? this.fractionOrder,
      promptText: promptText ?? this.promptText,
      correctAnswerText: correctAnswerText ?? this.correctAnswerText,
      choiceTexts: choiceTexts ?? this.choiceTexts,
      difficultyRank: difficultyRank ?? this.difficultyRank,
      sourcePage: sourcePage ?? this.sourcePage,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      lessonName: lessonName ?? this.lessonName,
      skill: skill ?? this.skill,
      questionTypeLabel: questionTypeLabel ?? this.questionTypeLabel,
    );
  }
}
