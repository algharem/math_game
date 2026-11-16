import 'package:flutter/material.dart';

import '../core/utils/arabic_numbers.dart';

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
