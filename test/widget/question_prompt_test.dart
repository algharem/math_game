import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/grade04_p2_unit6_bank.dart';
import 'package:math_heroes/core/utils/fraction_order_generator.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/question.dart';
import 'package:math_heroes/widgets/fraction_order_widget.dart';
import 'package:math_heroes/widgets/fraction_story_widget.dart';
import 'package:math_heroes/widgets/mixed_number_widget.dart';
import 'package:math_heroes/widgets/question_prompt.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

Question _plainQuestion() {
  return const Question(
    id: 'plain',
    kind: QuestionKind.addition,
    tokens: [2, '+', 3, '=', null],
    correctAnswer: 5,
    choices: [5, 6, 7, 8],
    explanation: '٢ + ٣ = ٥',
  );
}

MixedNumberQuestion _mixedQuestion({List<FractionStorySegment>? story}) {
  return MixedNumberQuestion(
    num1: const MixedNumber(2, 1, 3),
    num2: const MixedNumber(1, 1, 3),
    operation: '+',
    choices: const [
      MixedNumber(3, 2, 3),
      MixedNumber(3, 1, 3),
    ],
    correctIndex: 0,
    questionText: 'أوجد ناتج',
    explanation: 'نجمع الأعداد الكسرية.',
    spokenText: 'أوجد ناتج',
    story: story,
  );
}

Question _visualQuestion(MixedNumberQuestion mixed) {
  return Question(
    id: 'visual',
    kind: QuestionKind.mixedNumber,
    tokens: [mixed.questionText],
    correctAnswer: mixed.correctIndex,
    choices: List<int>.generate(mixed.choices.length, (index) => index),
    explanation: mixed.explanation,
    mixedNumber: mixed,
  );
}

const _orderQuestion = FractionOrderQuestion(
  fractions: [
    MixedNumber(0, 3, 7),
    MixedNumber(0, 1, 7),
    MixedNumber(0, 4, 7),
    MixedNumber(0, 2, 7),
  ],
  targetIndex: 0,
  questionText: 'رتّب الكسور تصاعديًا، ثم حدّد ترتيب الكسر المميّز.',
  explanation: '',
  spokenText: '',
);

void main() {
  testWidgets('plain questions fall back to the equation text', (tester) async {
    final question = _plainQuestion();
    await tester.pumpWidget(_wrap(QuestionPrompt(question: question)));

    expect(find.text(question.equationText), findsOneWidget);
    expect(find.byType(MixedNumberExpression), findsNothing);
    expect(find.byType(FractionStoryPrompt), findsNothing);
    expect(find.byType(FractionOrderPrompt), findsNothing);
  });

  testWidgets('authored Arabic prompts render verbatim with RTL direction', (
    tester,
  ) async {
    final authored = Unit6QuestionBank.questions
        .firstWhere((question) => question.id == 'g4p2u6_t8_b02')
        .toQuestion();
    await tester.pumpWidget(_wrap(QuestionPrompt(question: authored)));

    expect(find.text(authored.displayPrompt), findsOneWidget);
    expect(authored.displayPrompt, authored.promptText);
    expect(
      Directionality.of(tester.element(find.text(authored.displayPrompt))),
      TextDirection.rtl,
      reason: 'Arabic wording must keep decimal digits in reading order',
    );
  });

  testWidgets('plain numeric prompts keep their original LTR direction', (
    tester,
  ) async {
    final question = _plainQuestion();
    await tester.pumpWidget(_wrap(QuestionPrompt(question: question)));
    expect(
      Directionality.of(tester.element(find.text(question.equationText))),
      TextDirection.ltr,
    );
  });

  testWidgets('mixed numbers render as a visual expression', (tester) async {
    final mixed = _mixedQuestion();
    await tester.pumpWidget(
      _wrap(QuestionPrompt(question: _visualQuestion(mixed))),
    );

    expect(find.byType(MixedNumberExpression), findsOneWidget);
    expect(find.byType(MixedNumberWidget), findsNWidgets(2));
    expect(find.text('؟'), findsOneWidget);
    expect(find.byType(FractionStoryPrompt), findsNothing);

    await tester.pumpWidget(
      _wrap(
        QuestionPrompt(
          question: _visualQuestion(mixed),
          showResult: true,
        ),
      ),
    );

    expect(find.byType(MixedNumberWidget), findsNWidgets(3));
    expect(find.text('؟'), findsNothing);
  });

  testWidgets('word problems render the story with inline fractions', (
    tester,
  ) async {
    final mixed = _mixedQuestion(
      story: const [
        FractionStoryText('أكل سامي '),
        FractionStoryFraction(MixedNumber(0, 1, 2)),
        FractionStoryText(' من الكعكة. كم أكل؟'),
      ],
    );
    await tester.pumpWidget(
      _wrap(QuestionPrompt(question: _visualQuestion(mixed))),
    );

    expect(find.byType(FractionStoryPrompt), findsOneWidget);
    expect(find.byType(MixedNumberExpression), findsNothing);
    expect(find.textContaining('من الكعكة'), findsOneWidget);
    expect(find.byType(MixedNumberWidget), findsOneWidget);
  });

  testWidgets('ordering questions use the ordering prompt', (tester) async {
    const question = Question(
      id: 'order',
      kind: QuestionKind.fractionOps,
      tokens: ['رتّب'],
      correctAnswer: 1,
      choices: [1, 2, 3, 4],
      explanation: '',
      fractionOrder: _orderQuestion,
    );
    await tester.pumpWidget(_wrap(const QuestionPrompt(question: question)));

    expect(find.byType(FractionOrderPrompt), findsOneWidget);
    expect(find.byType(MixedNumberExpression), findsNothing);
    expect(find.text('رتّب تصاعديًا:'), findsOneWidget);
  });
}
