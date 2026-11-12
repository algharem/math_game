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

class DivisionScreen extends ConsumerWidget {
  const DivisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return PlayfulScaffold(
      appBar: AppBar(
        title: const Text('القسمة'),
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
            message:
                'القسمة هي عكس الضرب. إذا عرفت ٣ × ٤ = ١٢، فأنت تعرف ١٢ ÷ ٣ = ٤!',
            onSpeak: () => ref.read(ttsServiceProvider).speak(
                  'القسمة هي عكس الضرب. إذا عرفت ثلاثة ضرب أربعة يساوي اثني عشر، فأنت تعرف اثني عشر مقسومًا على ثلاثة يساوي أربعة!',
                ),
          ),
          const SizedBox(height: 18),
          AppCard(
            color: AppColors.leafSoft,
            borderColor: AppColors.leaf.withValues(alpha: 0.2),
            child: Column(
              children: [
                const OperatorBadge(
                  symbol: '÷',
                  color: AppColors.leaf,
                  size: 72,
                ),
                const SizedBox(height: 14),
                Text(
                  'تحدي القسمة',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'اختر الصعوبة وطريقة الإجابة، ثم انطلق.',
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
                  color: AppColors.leafDeep,
                  minHeight: 58,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded),
                      SizedBox(width: 8),
                      Text('ابدأ تمرين القسمة'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أنواع أسئلة القسمة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const _DivisionFormatRow(
                  equation: '١٢ ÷ ٣ = ؟',
                  label: 'أوجد ناتج القسمة',
                ),
                const SizedBox(height: 10),
                const _DivisionFormatRow(
                  equation: '١٢ ÷ ؟ = ٤',
                  label: 'أوجد المقسوم عليه',
                ),
                const SizedBox(height: 10),
                const _DivisionFormatRow(
                  equation: '؟ ÷ ٣ = ٤',
                  label: 'أوجد المقسوم',
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
    final config = await showPracticeSetup(
      context,
      initial: ExamConfig(
        section: MathSection.division,
        title: 'تمرين القسمة',
        questionCount: 10,
        difficulty: difficulty,
        source: ExamSource.practice,
        schoolGrade: ref.read(activeProfileProvider)?.schoolGrade ?? 1,
        divisionFormat: DivisionFormat.mixed,
        durationSeconds: timersEnabled ? 90 : null,
      ),
      allowDivisionFormat: true,
    );
    if (config != null && context.mounted) {
      launchQuiz(context, ref, config);
    }
  }
}

class _DivisionFormatRow extends StatelessWidget {
  const _DivisionFormatRow({required this.equation, required this.label});

  final String equation;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 128,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.leafSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            equation,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.leafDeep,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
