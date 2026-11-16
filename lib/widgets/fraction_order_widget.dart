import 'package:flutter/material.dart';

import '../core/utils/fraction_order_generator.dart';
import '../core/utils/mixed_number_generator.dart';
import 'mixed_number_widget.dart';

/// Visual prompt for "order these fractions" questions: the four fractions
/// are drawn with real fraction bars and the asked-about fraction is
/// highlighted. When [showResult] is true the sorted chain is shown instead.
class FractionOrderPrompt extends StatelessWidget {
  const FractionOrderPrompt({
    super.key,
    required this.question,
    this.fontSize = 26,
    this.textColor = const Color(0xFF2B2D42),
    this.highlightColor = const Color(0xFFE8F4FF),
    this.showResult = false,
  });

  final FractionOrderQuestion question;
  final double fontSize;
  final Color textColor;
  final Color highlightColor;
  final bool showResult;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: fontSize * 0.62,
      fontWeight: FontWeight.w700,
      color: textColor.withValues(alpha: 0.72),
      fontFamily: 'Tajawal',
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            showResult ? 'الترتيب التصاعدي:' : 'رتّب تصاعديًا:',
            style: labelStyle,
          ),
          const SizedBox(height: 10),
          if (showResult)
            _chain()
          else ...[
            _row([
              for (var i = 0; i < question.fractions.length; i++) ...[
                if (i > 0) _separator('،'),
                _term(
                  question.fractions[i],
                  highlighted: i == question.targetIndex,
                ),
              ],
            ]),
            const SizedBox(height: 12),
            _row([
              Text('ما ترتيب', style: labelStyle),
              const SizedBox(width: 8),
              _term(question.target, highlighted: true),
              const SizedBox(width: 8),
              Text('؟', style: labelStyle),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _chain() {
    final ascending = question.ascending;
    return _row([
      for (var i = 0; i < ascending.length; i++) ...[
        if (i > 0) _separator('<'),
        _term(ascending[i]),
      ],
    ]);
  }

  Widget _row(List<Widget> children) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 6,
      children: children,
    );
  }

  Widget _separator(String symbol) {
    return Text(
      symbol,
      style: TextStyle(
        fontSize: fontSize * 0.85,
        fontWeight: FontWeight.w800,
        color: textColor,
        fontFamily: 'Tajawal',
      ),
    );
  }

  Widget _term(MixedNumber number, {bool highlighted = false}) {
    final term = MixedNumberWidget(
      whole: number.whole,
      numerator: number.numerator,
      denominator: number.denominator,
      fontSize: fontSize,
      textColor: textColor,
    );
    if (!highlighted) return term;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: term,
    );
  }
}
