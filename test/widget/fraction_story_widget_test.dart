import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/widgets/fraction_story_widget.dart';
import 'package:math_heroes/widgets/mixed_number_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

MixedNumberQuestion _storyQuestion() {
  return MixedNumberQuestion(
    num1: const MixedNumber(0, 2, 7),
    num2: const MixedNumber(0, 3, 7),
    operation: '+',
    choices: const [
      MixedNumber(0, 5, 7),
      MixedNumber(0, 4, 7),
      MixedNumber(0, 6, 7),
      MixedNumber(0, 1, 7),
    ],
    correctIndex: 0,
    questionText: 'أكل أحمد ٢/٧ من الكعكة، ثم أكل ٣/٧. كم أكل من الكعكة؟',
    explanation: 'نجمع البسطين.',
    spokenText: 'أكل أحمد ٢ على ٧ من الكعكة.',
    story: const [
      FractionStoryText('أكل أحمد '),
      FractionStoryFraction(MixedNumber(0, 2, 7)),
      FractionStoryText(' من الكعكة، ثم أكل '),
      FractionStoryFraction(MixedNumber(0, 3, 7)),
      FractionStoryText('. كم أكل من الكعكة؟'),
    ],
  );
}

void main() {
  testWidgets('renders the story text with inline visual fractions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(FractionStoryPrompt(question: _storyQuestion())),
    );

    expect(find.text('أكل أحمد '), findsOneWidget);
    expect(find.text(' من الكعكة، ثم أكل '), findsOneWidget);
    expect(find.text('. كم أكل من الكعكة؟'), findsOneWidget);
    // Only the two story fractions; no answer is appended yet.
    expect(find.byType(MixedNumberWidget), findsNWidgets(2));
    expect(find.text('الإجابة:'), findsNothing);
  });

  testWidgets('appends the visual correct answer when showResult is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(FractionStoryPrompt(question: _storyQuestion(), showResult: true)),
    );

    expect(find.text('الإجابة:'), findsOneWidget);
    // Two story fractions + the answer fraction.
    expect(find.byType(MixedNumberWidget), findsNWidgets(3));
    expect(find.text('٥'), findsOneWidget);
  });
}
