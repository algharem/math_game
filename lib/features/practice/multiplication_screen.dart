import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_config.dart';
import '../../shared/models/stats_models.dart';
import '../../shared/widgets/app_widgets.dart';
import 'practice_setup.dart';

class MultiplicationScreen extends ConsumerWidget {
  const MultiplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masteryAsync = ref.watch(tableMasteryProvider);
    final settings = ref.watch(settingsProvider);
    final mastery = masteryAsync.valueOrNull ?? const <TableMastery>[];
    final masteredCount = mastery.where((table) => table.mastered).length;

    return PlayfulScaffold(
      appBar: AppBar(
        title: const Text('جداول الضرب'),
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
                'اختر جدولًا وابدأ التدريب. أتقنت ${ArabicNumbers.formatInt(masteredCount)} من ١٢ جدولًا!',
            onSpeak: () => ref.read(ttsServiceProvider).speak(
                  'اختر جدولًا وابدأ التدريب. أتقنت ${ArabicNumbers.formatInt(masteredCount)} من ١٢ جدولًا!',
                ),
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.skySoft,
            borderColor: AppColors.sky.withValues(alpha: 0.18),
            child: Row(
              children: [
                const OperatorBadge(symbol: '×', color: AppColors.sky),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تدريب عشوائي',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'أسئلة من جميع الجداول',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ],
                  ),
                ),
                PressButton(
                  onPressed: () => _openSetup(
                    context,
                    ref,
                    null,
                    settings.defaultDifficulty,
                    settings.timersEnabled,
                    allowCount: true,
                  ),
                  color: AppColors.sky,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  minHeight: 44,
                  child: const Text('ابدأ'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                'اختر جدولًا',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Text(
                'من ١ إلى ١٢',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.02,
            ),
            itemBuilder: (context, index) {
              final table = index + 1;
              final stats = mastery.length > index
                  ? mastery[index]
                  : TableMastery(table: table, attempts: 0, correct: 0);
              return _TableTile(
                table: table,
                stats: stats,
                onTap: () => _openSetup(
                  context,
                  ref,
                  table,
                  settings.defaultDifficulty,
                  settings.timersEnabled,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          AppCard(
            color: AppColors.sunSoft,
            borderColor: AppColors.sunDeep.withValues(alpha: 0.2),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.sunDeep,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'حيلة سريعة: ٥ × ٦ تعني ٥ مجموعات في كل مجموعة ٦. جرّب العد بالقفز!',
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
    int? table,
    Difficulty difficulty,
    bool timersEnabled, {
    bool allowCount = false,
  }) async {
    ref.read(audioServiceProvider).play(SoundEffect.tap);
    final config = await showPracticeSetup(
      context,
      initial: ExamConfig(
        section: MathSection.multiplication,
        title: table == null
            ? 'جداول الضرب المختلطة'
            : 'جدول الضرب في ${ArabicNumbers.formatInt(table)}',
        questionCount: 10,
        difficulty: difficulty,
        source: ExamSource.practice,
        schoolGrade: ref.read(activeProfileProvider)?.schoolGrade ?? 1,
        multiplicationTable: table,
        multiplicationFormat: MultiplicationFormat.mixed,
        durationSeconds: timersEnabled ? 90 : null,
      ),
      allowQuestionCount: allowCount,
      allowMultiplicationFormat: true,
    );
    if (config != null && context.mounted) {
      launchQuiz(context, ref, config);
    }
  }
}

class _TableTile extends StatelessWidget {
  const _TableTile({
    required this.table,
    required this.stats,
    required this.onTap,
  });

  final int table;
  final TableMastery stats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mastered = stats.mastered;
    return AppCard(
      onTap: onTap,
      semanticLabel: 'جدول ${ArabicNumbers.formatInt(table)}',
      padding: const EdgeInsets.all(10),
      color: mastered ? AppColors.leafSoft : Colors.white,
      borderColor:
          (mastered ? AppColors.leaf : AppColors.border).withValues(alpha: 0.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ArabicNumbers.formatInt(table),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: mastered ? AppColors.leafDeep : AppColors.skyDeep,
                    ),
              ),
              if (mastered) ...[
                const SizedBox(width: 3),
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.sunDeep,
                  size: 18,
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '×',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
          const SizedBox(height: 8),
          ProgressPill(
            value: stats.attempts == 0 ? 0 : stats.accuracy / 100,
            color: mastered ? AppColors.leaf : AppColors.sky,
            height: 6,
          ),
          const SizedBox(height: 4),
          Text(
            stats.attempts == 0
                ? 'ابدأ'
                : ArabicNumbers.formatPercent(stats.accuracy),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
