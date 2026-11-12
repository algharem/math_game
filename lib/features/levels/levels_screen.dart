import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/quiz_builder_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/auth_models.dart';
import '../../shared/models/learning_levels.dart';
import '../../shared/models/level_overview.dart';
import '../../shared/models/quiz_launch_data.dart';
import '../../shared/widgets/app_widgets.dart';
import '../login/login_screen.dart';

class LevelsScreen extends ConsumerWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth == null) return const LoginScreen();
    final profile = ref.watch(activeProfileProvider);
    if (profile == null) {
      return PlayfulScaffold(
        appBar: AppBar(title: const Text('المستويات التعليمية')),
        body: EmptyState(
          title: 'لا يوجد طالب نشط',
          message: 'سجّل الدخول واختر طالباً للمتابعة.',
          icon: Icons.school_outlined,
          action: PressButton(
            onPressed: () => context.go('/login'),
            child: const Text('تسجيل الدخول'),
          ),
        ),
      );
    }

    final overviewAsync = ref.watch(studentLevelOverviewProvider(profile.id));
    return PlayfulScaffold(
      accent: AppColors.leaf,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المستويات التعليمية'),
            Text(
              '${profile.name} • ${schoolGradeLabel(profile.schoolGrade)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
          ],
        ),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: overviewAsync.when(
        loading: () => const LoadingView(message: 'نفتح خريطة المستويات...'),
        error: (error, stackTrace) => ErrorRetryView(
          message: 'تعذر تحميل المستويات.',
          onRetry: () =>
              ref.invalidate(studentLevelOverviewProvider(profile.id)),
        ),
        data: (overview) => _LevelsBody(
          overview: overview,
          onStart: (view) => _startLevel(context, ref, view),
          onDetails: (view) => _showDetails(context, ref, overview, view),
        ),
      ),
    );
  }

  Future<void> _startLevel(
    BuildContext context,
    WidgetRef ref,
    StudentLevelView view,
  ) async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    final database = ref.read(databaseProvider);
    final config = LevelCatalog.examConfigFor(
      levelId: view.level.id,
      levelNumber: view.level.levelNumber,
      title: view.level.title,
      section: LevelCatalog.sectionNameFor(view.level.levelNumber),
      difficulty: view.level.difficulty,
      questionCount: view.level.questionCount,
      durationSeconds: view.level.timeLimitSeconds,
      schoolGrade: profile.schoolGrade,
    );
    final questions = QuizBuilderService.generate(config);
    if (questions.isEmpty) {
      showAppSnack(context, 'تعذر تجهيز أسئلة المستوى.', isError: true);
      return;
    }
    await database.markLevelStarted(
      profileId: profile.id,
      levelId: view.level.id,
    );
    ref.invalidate(studentLevelOverviewProvider(profile.id));
    ref.read(audioServiceProvider).play(SoundEffect.tap);
    if (!context.mounted) return;
    context.push(
      '/quiz',
      extra: QuizLaunchData(config: config, questions: questions),
    );
  }

  Future<void> _showDetails(
    BuildContext context,
    WidgetRef ref,
    StudentLevelOverview overview,
    StudentLevelView view,
  ) async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    final history = await ref.read(databaseProvider).getExamHistoryForLevel(
          profileId: profile.id,
          levelId: view.level.id,
        );
    if (!context.mounted) return;
    final shouldStart = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final level = view.level;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        level.title,
                        style: Theme.of(sheetContext).textTheme.headlineSmall,
                      ),
                    ),
                    _StatusChip(status: view.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'المستوى ${ArabicNumbers.formatInt(level.levelNumber)} • ${LevelCatalog.difficultyLabelFor(level.difficulty)}',
                  style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.quiz_rounded,
                      label:
                          '${ArabicNumbers.formatInt(level.questionCount)} أسئلة',
                    ),
                    _InfoChip(
                      icon: Icons.flag_rounded,
                      label:
                          'النجاح ${ArabicNumbers.formatInt(level.passingScore)}٪',
                    ),
                    if (level.timeLimitSeconds != null)
                      _InfoChip(
                        icon: Icons.timer_rounded,
                        label: ArabicNumbers.formatDuration(
                          level.timeLimitSeconds!,
                        ),
                      ),
                    _InfoChip(
                      icon: Icons.stars_rounded,
                      label:
                          'أفضل نتيجة ${ArabicNumbers.formatInt(view.bestScore)}٪',
                    ),
                    _InfoChip(
                      icon: Icons.replay_rounded,
                      label:
                          '${ArabicNumbers.formatInt(view.attempts)} محاولات',
                    ),
                    if (view.completedAt != null)
                      _InfoChip(
                        icon: Icons.event_available_rounded,
                        label: ArabicNumbers.formatDateTime(view.completedAt!),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'المهارات',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  level.topics,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Text(
                  'هدف المستوى',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  level.objectives,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Text(
                  'آخر المحاولات',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (history.isEmpty)
                  Text(
                    'لم تُسجّل محاولات لهذا المستوى بعد.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  )
                else
                  for (final exam in history.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.history_rounded,
                            size: 18,
                            color: AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ArabicNumbers.formatDateTime(exam.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Text(
                            '${ArabicNumbers.formatInt(exam.correct)}/${ArabicNumbers.formatInt(exam.total)}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: AppColors.leafDeep),
                          ),
                        ],
                      ),
                    ),
                const SizedBox(height: 18),
                PressButton(
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                  expanded: true,
                  color: AppColors.leafDeep,
                  minHeight: 56,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow_rounded),
                      const SizedBox(width: 8),
                      Text(view.completed ? 'أعد المستوى' : 'ابدأ المستوى'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (shouldStart == true && context.mounted) {
      await _startLevel(context, ref, view);
    }
  }
}

class _LevelsBody extends StatelessWidget {
  const _LevelsBody({
    required this.overview,
    required this.onStart,
    required this.onDetails,
  });

  final StudentLevelOverview overview;
  final ValueChanged<StudentLevelView> onStart;
  final ValueChanged<StudentLevelView> onDetails;

  @override
  Widget build(BuildContext context) {
    final views = overview.views;
    final current = overview.currentView;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                AppCard(
                  color: AppColors.leafSoft,
                  borderColor: AppColors.leaf.withValues(alpha: 0.25),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          ArabicNumbers.formatInt(
                              overview.profile.currentLevel),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppColors.leafDeep,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              current?.level.title ?? 'أكملت جميع المستويات',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'أكملت ${ArabicNumbers.formatInt(overview.completedCount)} من ${ArabicNumbers.formatInt(overview.totalLevels)} مستوى',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                            ),
                            const SizedBox(height: 7),
                            ProgressPill(
                              value: overview.completionRatio,
                              color: AppColors.leaf,
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 17,
                      color: AppColors.mutedForeground,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'اضغط على أي مستوى للبدء مباشرة. اضغط مطولاً لعرض التفاصيل.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: const [
                    _Legend(color: AppColors.leaf, label: 'مكتمل'),
                    _Legend(color: AppColors.sun, label: 'الحالي'),
                    _Legend(color: AppColors.border, label: 'متاح'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;
              final columns = width > 700 ? 6 : (width > 500 ? 5 : 4);
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 9,
                  crossAxisSpacing: 9,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final view = views[index];
                    return _LevelTile(
                      view: view,
                      onTap: () => onStart(view),
                      onLongPress: () => onDetails(view),
                    );
                  },
                  childCount: views.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.view,
    required this.onTap,
    required this.onLongPress,
  });

  final StudentLevelView view;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final config = switch (view.status) {
      LearningLevelStatus.completed => (
          background: AppColors.leafSoft,
          border: AppColors.leaf,
          foreground: AppColors.leafDeep,
        ),
      LearningLevelStatus.current => (
          background: AppColors.sunSoft,
          border: AppColors.sun,
          foreground: AppColors.sunDeep,
        ),
      LearningLevelStatus.available => (
          background: Colors.white,
          border: AppColors.border,
          foreground: AppColors.ink,
        ),
    };
    return Semantics(
      button: true,
      label:
          'المستوى ${view.level.levelNumber}، ${view.level.title}، أفضل نتيجة ${view.bestScore}٪',
      child: Material(
        color: config.background,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: config.border, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (view.completed)
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.leafDeep,
                      )
                    else if (view.status == LearningLevelStatus.current)
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.sunDeep,
                      ),
                    if (view.completed ||
                        view.status == LearningLevelStatus.current)
                      const SizedBox(width: 3),
                    Text(
                      ArabicNumbers.formatInt(view.level.levelNumber),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: config.foreground,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  view.level.title.split('—').last.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 9,
                      ),
                ),
                const Spacer(),
                Text(
                  view.attempts == 0
                      ? 'جديد'
                      : '${ArabicNumbers.formatInt(view.bestScore)}٪',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: config.foreground,
                        fontSize: 10,
                      ),
                ),
                Text(
                  '${ArabicNumbers.formatInt(view.attempts)} محاولة',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 8,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final LearningLevelStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (status) {
      LearningLevelStatus.completed => (
          'مكتمل',
          AppColors.leafDeep,
          AppColors.leafSoft,
        ),
      LearningLevelStatus.current => (
          'المستوى الحالي',
          AppColors.sunDeep,
          AppColors.sunSoft,
        ),
      LearningLevelStatus.available => (
          'متاح',
          AppColors.mutedForeground,
          AppColors.muted,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.skySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.skyDeep),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
