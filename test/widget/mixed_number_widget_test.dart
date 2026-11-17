import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/widgets/mixed_number_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('renders whole part, numerator, and denominator', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const MixedNumberWidget(whole: 2, numerator: 3, denominator: 4)),
    );

    expect(find.text('٢'), findsOneWidget);
    expect(find.text('٣'), findsOneWidget);
    expect(find.text('٤'), findsOneWidget);
  });

  testWidgets('renders a plain fraction when the whole part is zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const MixedNumberWidget(whole: 0, numerator: 3, denominator: 5)),
    );

    expect(find.text('٠'), findsNothing);
    expect(find.text('٣'), findsOneWidget);
    expect(find.text('٥'), findsOneWidget);
  });

  testWidgets('renders a whole number when the numerator is zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const MixedNumberWidget(whole: 4, numerator: 0, denominator: 1)),
    );

    expect(find.text('٤'), findsOneWidget);
    expect(find.text('٠'), findsNothing);
    expect(find.text('١'), findsNothing);
  });

  testWidgets('exposes an accessible spoken label', (tester) async {
    await tester.pumpWidget(
      _wrap(const MixedNumberWidget(whole: 1, numerator: 2, denominator: 3)),
    );

    final semantics = tester.getSemantics(find.byType(MixedNumberWidget));
    expect(semantics.label, contains('١'));
    expect(semantics.label, contains('على'));
  });

  group('MixedNumberExpression', () {
    MixedNumberQuestion question() {
      return MixedNumberQuestion(
        num1: const MixedNumber(2, 1, 3),
        num2: const MixedNumber(1, 1, 3),
        operation: '+',
        choices: const [
          MixedNumber(3, 2, 3),
          MixedNumber(3, 1, 3),
        ],
        correctIndex: 0,
        questionText: 'أوجد ناتج: ٢ و١/٣ + ١ و١/٣ = ؟',
        explanation: 'نجمع الأعداد الكسرية.',
        spokenText: 'أوجد ناتج',
      );
    }

    testWidgets('shows both operands and a question mark while answering', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(MixedNumberExpression(question: question())),
      );

      expect(find.byType(MixedNumberWidget), findsNWidgets(2));
      expect(find.text('+'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
      expect(find.text('؟'), findsOneWidget);
    });

    testWidgets('renders the visual correct answer when showResult is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(MixedNumberExpression(question: question(), showResult: true)),
      );

      expect(find.byType(MixedNumberWidget), findsNWidgets(3));
      expect(find.text('='), findsOneWidget);
      expect(find.text('؟'), findsNothing);
    });

    testWidgets('uses the multiplication and division symbols', (tester) async {
      for (final pair in const [('*', '×'), ('/', '÷')]) {
        final base = question();
        final generated = MixedNumberQuestion(
          num1: base.num1,
          num2: base.num2,
          operation: pair.$1,
          choices: base.choices,
          correctIndex: base.correctIndex,
          questionText: base.questionText,
          explanation: base.explanation,
          spokenText: base.spokenText,
        );
        await tester.pumpWidget(
          _wrap(MixedNumberExpression(question: generated)),
        );
        expect(find.text(pair.$2), findsOneWidget);
        expect(find.text('؟'), findsOneWidget);
      }
    });

    testWidgets('renders only the known fraction for equivalence questions', (
      tester,
    ) async {
      final equivalence = MixedNumberQuestion(
        num1: const MixedNumber(0, 1, 2),
        num2: const MixedNumber(0, 3, 6),
        operation: '=',
        choices: const [
          MixedNumber(0, 3, 6),
          MixedNumber(0, 2, 6),
        ],
        correctIndex: 0,
        questionText: '١/٢ = ؟',
        explanation: 'كسر مكافئ.',
        spokenText: 'ما الكسر المكافئ؟',
      );

      await tester.pumpWidget(
        _wrap(MixedNumberExpression(question: equivalence)),
      );

      // Only the base fraction is drawn while answering.
      expect(find.byType(MixedNumberWidget), findsOneWidget);
      expect(find.text('١'), findsOneWidget);
      expect(find.text('٢'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
      expect(find.text('؟'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(MixedNumberExpression(question: equivalence, showResult: true)),
      );

      expect(find.byType(MixedNumberWidget), findsNWidgets(2));
      expect(find.text('٣'), findsOneWidget);
      expect(find.text('٦'), findsOneWidget);
      expect(find.text('؟'), findsNothing);
    });
  });
}
