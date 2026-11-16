import 'package:flutter/material.dart';

import '../core/utils/mixed_number_generator.dart';
import 'mixed_number_widget.dart';

/// Renders a fraction word problem as a story paragraph with inline visual
/// fractions. With [showResult] the correct answer is appended.
class FractionStoryPrompt extends StatelessWidget {
  const FractionStoryPrompt({
    super.key,
    required this.question,
    this.fontSize = 22,
    this.textColor = const Color(0xFF2B2D42),
    this.highlightColor = const Color(0xFFE8F4FF),
    this.showResult = false,
  });

  final MixedNumberQuestion question;
  final double fontSize;
  final Color textColor;
  final Color highlightColor;
  final bool showResult;

  @override
  Widget build(BuildContext context) {
    final story = question.story;
    if (story == null) return const SizedBox.shrink();

    final textStyle = TextStyle(
      fontSize: fontSize,
      height: 1.6,
      fontWeight: FontWeight.w600,
      color: textColor,
      fontFamily: 'Tajawal',
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 8,
            children: [
              for (final segment in story)
                switch (segment) {
                  FractionStoryText(:final text) =>
                    Text(text, style: textStyle),
                  FractionStoryFraction(:final value) => _fraction(value),
                },
            ],
          ),
          if (showResult) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'الإجابة:',
                  style: textStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: textColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: _fraction(question.correctAnswer),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _fraction(MixedNumber number) {
    return MixedNumberWidget(
      whole: number.whole,
      numerator: number.numerator,
      denominator: number.denominator,
      fontSize: fontSize,
      textColor: textColor,
    );
  }
}
