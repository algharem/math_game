import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_config.dart';
import '../../shared/widgets/app_widgets.dart';
import 'practice_setup.dart';

class ArithmeticScreen extends ConsumerWidget {
  const ArithmeticScreen({super.key, required this.section});

  final MathSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isAddition = section == MathSection.addition;
    final color = isAddition ? AppColors.coral : AppColors.purple;
    final symbol = isAddition ? '+' : '−';
    return PlayfulScaffold(
      accent: color,
      appBar: AppBar(
        title: Text(isAddition ? 'الجمع' : 'الطرح'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          MascotBubble(
            asset: AppAssets.mascotHappy,
            message: isAddition
                ? 'اجمع الأعداد خطوة بخطوة. يمكنك استخدام أصابعك أو الرسم!'
                : 'اطرح العدد الصغير من الكبير. تذكّر أن الطرح يعني كم بقي!',
            onSpeak: () => ref.read(ttsServiceProvider).speak(
                  isAddition
                      ? 'اجمع الأعداد خطوة بخطوة. يمكنك استخدام أصابعك أو الرسم!'
                      : 'اطرح العدد الصغير من الكبير. تذكّر أن الطرح يعني كم بقي!',
                ),
          ),
          const SizedBox(height: 18),
          AppCard(
            color: color.withValues(alpha: 0.08),
            borderColor: color.withValues(alpha: 0.22),
            child: Column(
              children: [
                OperatorBadge(symbol: symbol, color: color, size: 76),
                const SizedBox(height: 14),
                Text(
                  isAddition ? 'مغامرة الجمع' : 'مغامرة الطرح',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  isAddition
                      ? 'اجمع الأعداد واكتشف الناتج.'
                      : 'اختر الفرق بين الأعداد.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 18),
                PressButton(
                  onPressed: () => _openSetup(
                    context,
                    ref,
                    settings.defaultDifficulty,
                    settings.timersEnabled,
                  ),
                  expanded: true,
                  color: color,
                  minHeight: 58,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow_rounded),
                      const SizedBox(width: 8),
                      Text(isAddition ? 'ابدأ الجمع' : 'ابدأ الطرح'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isAddition
                      ? Icons.tips_and_updates_rounded
                      : Icons.lightbulb_rounded,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isAddition
                        ? 'جرّب تجميع الأعداد: ٧ + ٣ = ١٠، ثم أضف الباقي بسهولة.'
                        : 'للطرح، فكّر: ما العدد الذي إذا أضفته إلى الصغير يعطينا الكبير؟',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSetup(
    BuildContext context,
    WidgetRef ref,
    Difficulty difficulty,
    bool timersEnabled,
  ) async {
    final isAddition = section == MathSection.addition;
    final config = await showPracticeSetup(
      context,
      initial: ExamConfig(
        section: section,
        title: isAddition ? 'تمرين الجمع' : 'تمرين الطرح',
        questionCount: 10,
        difficulty: difficulty,
        source: ExamSource.practice,
        schoolGrade: ref.read(activeProfileProvider)?.schoolGrade ?? 1,
        durationSeconds: timersEnabled ? 90 : null,
      ),
      allowQuestionCount: true,
    );
    if (config != null && context.mounted) {
      launchQuiz(context, ref, config);
    }
  }
}
