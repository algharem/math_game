import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/fraction_order_generator.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/widgets/fraction_order_widget.dart';
import 'package:math_heroes/widgets/mixed_number_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

const _question = FractionOrderQuestion(
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
  testWidgets('renders the four fractions and asks for the target rank', (
    tester,
  ) async {
    await tester
        .pumpWidget(_wrap(const FractionOrderPrompt(question: _question)));

    expect(find.text('رتّب تصاعديًا:'), findsOneWidget);
    // Four displayed fractions + the repeated highlighted target.
    expect(find.byType(MixedNumberWidget), findsNWidgets(5));
    expect(find.text('ما ترتيب'), findsOneWidget);
    expect(find.text('؟'), findsOneWidget);
    expect(find.text('،'), findsNWidgets(3));
  });

  testWidgets('shows the ascending chain when showResult is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const FractionOrderPrompt(question: _question, showResult: true)),
    );

    expect(find.text('الترتيب التصاعدي:'), findsOneWidget);
    expect(find.text('ما ترتيب'), findsNothing);
    expect(find.byType(MixedNumberWidget), findsNWidgets(4));
    expect(find.text('<'), findsNWidgets(3));
  });
}
