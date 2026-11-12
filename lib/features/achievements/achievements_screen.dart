import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/achievements.dart';
import '../../shared/widgets/app_widgets.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);
    final achievements =
        achievementsAsync.valueOrNull ?? const <AchievementState>[];
    final unlocked = achievements.where((item) => item.unlocked).length;

    return PlayfulScaffold(
      accent: AppColors.sun,
      appBar: AppBar(
        title: const Text('الإنجازات'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: achievementsAsync.isLoading && !achievementsAsync.hasValue
          ? const LoadingView(message: 'نفتح صندوق الأوسمة...')
          : achievementsAsync.hasError
              ? ErrorRetryView(
                  message: 'تعذر تحميل الإنجازات.',
                  onRetry: () => ref.invalidate(achievementsProvider),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  children: [
                    MascotBubble(
                      asset: AppAssets.mascotCelebrating,
                      message:
                          'جمعت ${ArabicNumbers.formatInt(unlocked)} من ${ArabicNumbers.formatInt(achievements.length)} إنجازًا. واصل التألق!',
                      onSpeak: () => ref.read(ttsServiceProvider).speak(
                            'جمعت ${ArabicNumbers.formatInt(unlocked)} من ${ArabicNumbers.formatInt(achievements.length)} إنجازًا. واصل التألق!',
                          ),
                    ),
                    const SizedBox(height: 16),
                    AppCard(
                      color: AppColors.sunSoft,
                      borderColor: AppColors.sunDeep.withValues(alpha: 0.2),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events_rounded,
                            color: AppColors.sunDeep,
                            size: 36,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'كل إنجاز يضيف لمسة إلى رحلتك. افتح المزيد بالتدريب اليومي.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (final achievement in achievements)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AchievementCard(achievement: achievement),
                      ),
                  ],
                ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final AchievementState achievement;

  @override
  Widget build(BuildContext context) {
    final definition = achievement.definition;
    final unlocked = achievement.unlocked;
    return AppCard(
      color: unlocked ? Colors.white : AppColors.muted.withValues(alpha: 0.45),
      borderColor: unlocked
          ? AppColors.sunDeep.withValues(alpha: 0.2)
          : AppColors.border,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: unlocked ? AppColors.sunSoft : AppColors.muted,
              shape: BoxShape.circle,
            ),
            child: Opacity(
              opacity: unlocked ? 1 : 0.35,
              child: definition.assetPath == null
                  ? Icon(
                      Icons.emoji_events_rounded,
                      color: unlocked
                          ? AppColors.sunDeep
                          : AppColors.mutedForeground,
                      size: 34,
                    )
                  : Image.asset(
                      definition.assetPath!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.emoji_events_rounded,
                        color: unlocked
                            ? AppColors.sunDeep
                            : AppColors.mutedForeground,
                        size: 34,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        definition.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: unlocked
                                      ? AppColors.ink
                                      : AppColors.mutedForeground,
                                ),
                      ),
                    ),
                    Icon(
                      unlocked
                          ? Icons.verified_rounded
                          : Icons.lock_outline_rounded,
                      size: 20,
                      color: unlocked
                          ? AppColors.leafDeep
                          : AppColors.mutedForeground,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  definition.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                if (unlocked && achievement.unlockedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'فُتح في ${ArabicNumbers.formatDate(achievement.unlockedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.leafDeep,
                          fontSize: 10,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
