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

class MixedScreen extends ConsumerWidget {
  const MixedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return PlayfulScaffold(
      accent: AppColors.purple,
      appBar: AppBar(
        title: const Text('اختبر نفسك'),
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
            asset: AppAssets.mascotEncouraging,
            message:
                'اختبار مختلط يجمع الضرب والقسمة والجمع والطرح. أرِني ما تعلمته!',
            onSpeak: () => ref.read(ttsServiceProvider).speak(
                  'اختبار مختلط يجمع الضرب والقسمة والجمع والطرح. أرِني ما تعلمته!',
                ),
          ),
          const SizedBox(height: 18),
          AppCard(
            color: AppColors.purpleSoft,
            borderColor: AppColors.purple.withValues(alpha: 0.2),
            child: Column(
              children: [
                const OperatorBadge(
                  symbol: '★',
                  color: AppColors.purple,
                  size: 76,
                ),
                const SizedBox(height: 14),
                Text(
                  'التحدي المختلط',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'أسئلة متنوعة تقيس كل مهاراتك.',
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
                  color: AppColors.purple,
                  minHeight: 58,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded),
                      SizedBox(width: 8),
                      Text('ابدأ الاختبار'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _SkillCard(
                  symbol: '×',
                  label: 'الضرب',
                  color: AppColors.sky,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SkillCard(
                  symbol: '÷',
                  label: 'القسمة',
                  color: AppColors.leaf,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SkillCard(
                  symbol: '+',
                  label: 'الجمع',
                  color: AppColors.coral,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SkillCard(
                  symbol: '−',
                  label: 'الطرح',
                  color: AppColors.purple,
                ),
              ),
            ],
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
        section: MathSection.mixed,
        title: 'التحدي المختلط',
        questionCount: 10,
        difficulty: difficulty,
        source: ExamSource.exam,
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

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.symbol,
    required this.label,
    required this.color,
  });

  final String symbol;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      borderColor: color.withValues(alpha: 0.2),
      child: Column(
        children: [
          Text(
            symbol,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
