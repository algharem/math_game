import 'package:flutter/material.dart';

import '../core/utils/arabic_numbers.dart';
import '../core/utils/mixed_number_generator.dart';

/// Renders an Arabic mixed number (whole + proper fraction) with a real
/// horizontal fraction bar. Works inside the existing quiz choice buttons.
class MixedNumberWidget extends StatelessWidget {
  const MixedNumberWidget({
    super.key,
    required this.whole,
    required this.numerator,
    required this.denominator,
    this.fontSize = 28.0,
    this.textColor = const Color(0xFF2B2D42),
  });

  final int whole;
  final int numerator;
  final int denominator;
  final double fontSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final showFraction = numerator != 0 && denominator > 0;
    final showWhole = whole != 0 || !showFraction;

    return Semantics(
      label: _spokenLabel(showWhole, showFraction),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showWhole)
            Text(
              ArabicNumbers.formatInt(whole),
              style: TextStyle(
                fontSize: fontSize * 1.2,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
          if (showWhole && showFraction) const SizedBox(width: 8),
          if (showFraction)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ArabicNumbers.formatInt(numerator),
                  style: TextStyle(
                    fontSize: fontSize * 0.7,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Container(
                  width: fontSize * 0.9,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  ArabicNumbers.formatInt(denominator),
                  style: TextStyle(
                    fontSize: fontSize * 0.7,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _spokenLabel(bool showWhole, bool showFraction) {
    if (!showFraction) return ArabicNumbers.formatInt(whole);
    final fraction =
        '${ArabicNumbers.formatInt(numerator)} على ${ArabicNumbers.formatInt(denominator)}';
    if (!showWhole) return fraction;
    return '${ArabicNumbers.formatInt(whole)} و$fraction';
  }
}

/// Full visual expression for a generated mixed-number question:
/// `num1 ± num2 = answer` (or `= ؟` while the student is answering).
class MixedNumberExpression extends StatelessWidget {
  const MixedNumberExpression({
    super.key,
    required this.question,
    this.fontSize = 26,
    this.textColor = const Color(0xFF2B2D42),
    this.showResult = false,
  });

  final MixedNumberQuestion question;
  final double fontSize;
  final Color textColor;
  final bool showResult;

  @override
  Widget build(BuildContext context) {
    final symbolStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: textColor,
      fontFamily: 'Tajawal',
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _term(question.num1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fontSize * 0.3),
            child: Text(question.operationSymbol, style: symbolStyle),
          ),
          _term(question.num2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fontSize * 0.3),
            child: Text('=', style: symbolStyle),
          ),
          if (showResult)
            _term(question.correctAnswer)
          else
            Text('؟', style: symbolStyle),
        ],
      ),
    );
  }

  Widget _term(MixedNumber number) {
    return MixedNumberWidget(
      whole: number.whole,
      numerator: number.numerator,
      denominator: number.denominator,
      fontSize: fontSize,
      textColor: textColor,
    );
  }
}
