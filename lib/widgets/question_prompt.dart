import 'package:flutter/material.dart';

import '../shared/models/question.dart';
import 'fraction_order_widget.dart';
import 'fraction_story_widget.dart';
import 'mixed_number_widget.dart';

/// Chooses the right prompt renderer for [question]:
///
/// * fraction word problems -> [FractionStoryPrompt]
/// * other visual fractions -> [MixedNumberExpression]
/// * ordering questions -> [FractionOrderPrompt]
/// * everything else -> the plain equation text.
///
/// The quiz, results review, and retry screens share this so a visual question
/// looks the same everywhere.
class QuestionPrompt extends StatelessWidget {
  const QuestionPrompt({
    super.key,
    required this.question,
    this.fontSize = 22,
    this.storyFontSize,
    this.orderFontSize,
    this.textColor = const Color(0xFF2B2D42),
    this.highlightColor = const Color(0xFFE8F4FF),
    this.showResult = false,
    this.alignment = AlignmentDirectional.centerStart,
    this.plainTextStyle,
    this.plainTextAlign = TextAlign.start,
  });

  final Question question;
  final double fontSize;

  /// Defaults to [fontSize] when omitted.
  final double? storyFontSize;

  /// Defaults to [fontSize] when omitted.
  final double? orderFontSize;

  final Color textColor;
  final Color highlightColor;
  final bool showResult;
  final AlignmentGeometry alignment;
  final TextStyle? plainTextStyle;
  final TextAlign plainTextAlign;

  @override
  Widget build(BuildContext context) {
    final mixed = question.mixedNumber;
    if (mixed != null) {
      if (mixed.isWordProblem) {
        return FractionStoryPrompt(
          question: mixed,
          fontSize: storyFontSize ?? fontSize,
          textColor: textColor,
          highlightColor: highlightColor,
          showResult: showResult,
        );
      }
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: MixedNumberExpression(
          question: mixed,
          fontSize: fontSize,
          textColor: textColor,
          showResult: showResult,
        ),
      );
    }

    final order = question.fractionOrder;
    if (order != null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: FractionOrderPrompt(
          question: order,
          fontSize: orderFontSize ?? fontSize,
          textColor: textColor,
          highlightColor: highlightColor,
          showResult: showResult,
        ),
      );
    }

    final text = question.displayPrompt;
    // Arabic words need RTL so the decimal separator and following digits
    // stay in reading order. Pure numeric expressions keep LTR as before.
    final hasArabicLetters =
        RegExp(r'[\u0621-\u063A\u0641-\u064A\u066E-\u06D3]').hasMatch(text);
    return Directionality(
      textDirection: hasArabicLetters ? TextDirection.rtl : TextDirection.ltr,
      child: Text(
        text,
        textAlign: plainTextAlign,
        style: plainTextStyle ?? Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
