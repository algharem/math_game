import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../core/utils/mixed_number_generator.dart';
import '../shared/models/question.dart';
import 'mixed_number_widget.dart';

/// One-line review summary for a finished question: «إجابة صحيحة» or the
/// child's answer versus the correct one. Visual fraction questions show both
/// answers with real fraction bars instead of slash text.
class AnswerReviewLine extends StatelessWidget {
  const AnswerReviewLine({
    super.key,
    required this.question,
    required this.childAnswer,
    required this.correct,
    this.fontSize = 16,
  });

  final Question question;
  final int? childAnswer;
  final bool correct;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.leafDeep : AppColors.coralDeep;
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(color: color);

    if (correct) return Text('إجابة صحيحة', style: style);

    final mixed = question.mixedNumber;
    if (mixed == null) {
      return Text(
        'إجابتك: ${question.choiceText(childAnswer)} • '
        'الصحيحة: ${question.answerText}',
        style: style,
      );
    }

    MixedNumber? chosen;
    final index = childAnswer;
    if (index != null && index >= 0 && index < mixed.choices.length) {
      chosen = mixed.choices[index];
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        Text('إجابتك:', style: style),
        if (chosen == null)
          Text('—', style: style)
        else
          _fraction(chosen, color),
        Text('• الصحيحة:', style: style),
        _fraction(mixed.correctAnswer, color),
      ],
    );
  }

  Widget _fraction(MixedNumber number, Color color) {
    return MixedNumberWidget(
      whole: number.whole,
      numerator: number.numerator,
      denominator: number.denominator,
      fontSize: fontSize,
      textColor: color,
    );
  }
}
