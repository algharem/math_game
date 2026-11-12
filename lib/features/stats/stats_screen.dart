import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/stats_models.dart';
import '../../shared/widgets/app_widgets.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider);
    final historyAsync = ref.watch(examHistoryProvider);
    final dailyAsync = ref.watch(dailyStatusProvider);
    final stats = statsAsync.valueOrNull ?? ProfileStats.empty;
    final history = historyAsync.valueOrNull ?? const <ExamRecord>[];
    final daily = dailyAsync.valueOrNull ?? DailyStatus.empty;

    return PlayfulScaffold(
      accent: AppColors.sky,
      appBar: AppBar(
        title: const Text('تقدمي'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: statsAsync.isLoading && !statsAsync.hasValue
          ? const LoadingView(message: 'نجمع إنجازاتك...')
          : statsAsync.hasError
              ? ErrorRetryView(
                  message: 'تعذر تحميل تقرير التقدم.',
                  onRetry: () => ref.invalidate(profileStatsProvider),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  children: [
                    MascotBubble(
                      asset: stats.examsCount == 0
                          ? AppAssets.mascotEncouraging
                          : AppAssets.mascotHappy,
                      message: stats.examsCount == 0
                          ? 'لم تبدأ مغامرتك بعد. كل بطل يبدأ بخطوة!'
                          : 'كل تمرين يجعلك أقوى يا ${profile?.name ?? 'بطل'}.',
                      onSpeak: () => ref.read(ttsServiceProvider).speak(
                            stats.examsCount == 0
                                ? 'لم تبدأ مغامرتك بعد. كل بطل يبدأ بخطوة!'
                                : 'كل تمرين يجعلك أقوى يا ${profile?.name ?? 'بطل'}.',
                          ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.8,
                      children: [
                        _StatBox(
                          icon: Icons.school_rounded,
                          label: 'اختبارات مكتملة',
                          value: ArabicNumbers.formatInt(stats.examsCount),
                          color: AppColors.sky,
                        ),
                        _StatBox(
                          icon: Icons.check_circle_rounded,
                          label: 'إجابات صحيحة',
                          value: ArabicNumbers.formatInt(stats.correctAnswers),
                          color: AppColors.leaf,
                        ),
                        _StatBox(
                          icon: Icons.track_changes_rounded,
                          label: 'الدقة',
                          value: ArabicNumbers.formatPercent(stats.accuracy),
                          color: AppColors.sunDeep,
                        ),
                        _StatBox(
                          icon: Icons.timer_rounded,
                          label: 'وقت التعلم',
                          value: ArabicNumbers.formatDuration(
                            stats.learningSeconds,
                          ),
                          color: AppColors.purple,
                        ),
                        _StatBox(
                          icon: Icons.local_fire_department_rounded,
                          label: 'سلسلة يومية',
                          value: ArabicNumbers.formatInt(daily.streak),
                          color: AppColors.coral,
                        ),
                        _StatBox(
                          icon: Icons.workspace_premium_rounded,
                          label: 'اختبارات مثالية',
                          value: ArabicNumbers.formatInt(stats.perfectExams),
                          color: AppColors.leafDeep,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'الأداء حسب المهارة',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    AppCard(
                      child: stats.subjects.isEmpty
                          ? Text(
                              'ستظهر مهاراتك هنا بعد أول تمرين.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                            )
                          : Column(
                              children: [
                                for (final section in [
                                  MathSection.multiplication,
                                  MathSection.division,
                                  MathSection.addition,
                                  MathSection.subtraction,
                                ])
                                  _SubjectRow(
                                    section: section,
                                    performance: stats.performanceFor(section),
                                  ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'آخر الاختبارات',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Spacer(),
                        Text(
                          '${ArabicNumbers.formatInt(history.length)} اختبار',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (history.isEmpty)
                      AppCard(
                        child: Text(
                          'لا يوجد سجل بعد. ابدأ أول تمرين لتظهر نتائجك هنا.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      for (final exam in history.take(20))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _HistoryCard(exam: exam),
                        ),
                    if (stats.bestAccuracy > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        'أفضل دقة: ${ArabicNumbers.formatPercent(stats.bestAccuracy)}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ],
                  ],
                ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      borderColor: color.withValues(alpha: 0.16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                      ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.section, required this.performance});

  final MathSection section;
  final SubjectPerformance? performance;

  @override
  Widget build(BuildContext context) {
    final value = performance;
    final accuracy = value?.accuracy ?? 0;
    final color = switch (section) {
      MathSection.multiplication => AppColors.sky,
      MathSection.division => AppColors.leaf,
      MathSection.addition => AppColors.coral,
      MathSection.subtraction => AppColors.purple,
      _ => AppColors.sky,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                value == null
                    ? 'لم يبدأ'
                    : ArabicNumbers.formatPercent(accuracy),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ProgressPill(value: accuracy / 100, color: color),
          if (value != null) ...[
            const SizedBox(height: 3),
            Text(
              '${ArabicNumbers.formatInt(value.answered)} سؤال • ${ArabicNumbers.formatInt(value.correct)} صحيح',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                    fontSize: 11,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.exam});

  final ExamRecord exam;

  @override
  Widget build(BuildContext context) {
    final accuracy = exam.total == 0 ? 0 : exam.correct / exam.total * 100;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.skySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              exam.section == MathSection.multiplication.name
                  ? '×'
                  : exam.section == MathSection.division.name
                      ? '÷'
                      : exam.section == MathSection.addition.name
                          ? '+'
                          : '−',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.skyDeep,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  ArabicNumbers.formatDateTime(exam.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ArabicNumbers.formatPercent(accuracy),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.leafDeep,
                    ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.sunDeep,
                    size: 15,
                  ),
                  Text(
                    ArabicNumbers.formatInt(exam.starsEarned),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
