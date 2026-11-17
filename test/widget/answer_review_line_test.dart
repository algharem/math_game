import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/curriculum/grade04_p2_unit6_bank.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/question.dart';
import 'package:math_heroes/widgets/answer_review_line.dart';
import 'package:math_heroes/widgets/mixed_number_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

Question _visualQuestion() {
  return Question(
    id: 'visual-1',
    kind: QuestionKind.fractionOps,
    tokens: const ['كسور'],
    correctAnswer: 2,
    choices: const [0, 1, 2, 3],
    explanation: 'نجمع البسطين.',
    mixedNumber: MixedNumberQuestion(
      num1: const MixedNumber(0, 2, 7),
      num2: const MixedNumber(0, 1, 7),
      operation: '+',
      choices: const [
        MixedNumber(0, 3, 7),
        MixedNumber(0, 4, 7),
        MixedNumber(0, 5, 7),
        MixedNumber(0, 6, 7),
      ],
      correctIndex: 2,
      questionText: '٣/٧',
      explanation: 'نجمع البسطين.',
      spokenText: 'اجمع الكسرين.',
    ),
  );
}

const _plainQuestion = Question(
  id: 'plain-1',
  kind: QuestionKind.addition,
  tokens: [2, '+', 3, '=', null],
  correctAnswer: 5,
  choices: [5, 6, 7, 8],
  explanation: '٢ + ٣ = ٥',
);

void main() {
  testWidgets('marks a correct answer without repeating the value', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AnswerReviewLine(
          question: _plainQuestion,
          childAnswer: 5,
          correct: true,
        ),
      ),
    );

    expect(find.text('إجابة صحيحة'), findsOneWidget);
    expect(find.byType(MixedNumberWidget), findsNothing);
  });

  testWidgets('shows plain numeric answers as slash-free text', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AnswerReviewLine(
          question: _plainQuestion,
          childAnswer: 7,
          correct: false,
        ),
      ),
    );

    expect(find.text('إجابتك: ٧ • الصحيحة: ٥'), findsOneWidget);
    expect(find.byType(MixedNumberWidget), findsNothing);
  });

  testWidgets('authored decimal answers keep their exact Arabic labels', (
    tester,
  ) async {
    final authored = Unit6QuestionBank.questions
        .firstWhere((question) => question.id == 'g4p2u6_t14_h04')
        .toQuestion();
    await tester.pumpWidget(
      _wrap(
        AnswerReviewLine(
          question: authored,
          childAnswer: 1,
          correct: false,
        ),
      ),
    );

    // Choice 1 is «١٫٢٥ والفرق ٠٫٧٦» and the correct answer keeps its
    // decimal point; the integer based engine never leaks a raw index.
    expect(find.textContaining('١٫٢٥ والفرق ٠٫٧٦'), findsOneWidget);
    expect(find.textContaining('١٫٢٥ والفرق ٠٫٧٥'), findsOneWidget);
    expect(authored.answerText, '١٫٢٥ والفرق ٠٫٧٥');
  });

  testWidgets('renders both fraction answers visually', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AnswerReviewLine(
          question: _visualQuestion(),
          childAnswer: 0,
          correct: false,
        ),
      ),
    );

    expect(find.text('إجابتك:'), findsOneWidget);
    expect(find.text('• الصحيحة:'), findsOneWidget);
    // Chosen 3/7 and correct 5/7.
    expect(find.byType(MixedNumberWidget), findsNWidgets(2));
    expect(find.text('٣'), findsOneWidget);
    expect(find.text('٥'), findsOneWidget);
  });

  testWidgets('shows a dash for an unanswered fraction question', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AnswerReviewLine(
          question: _visualQuestion(),
          childAnswer: null,
          correct: false,
        ),
      ),
    );

    expect(find.text('—'), findsOneWidget);
    // Only the correct answer is drawn.
    expect(find.byType(MixedNumberWidget), findsOneWidget);
  });
}
