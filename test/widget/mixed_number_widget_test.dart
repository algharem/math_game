import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
