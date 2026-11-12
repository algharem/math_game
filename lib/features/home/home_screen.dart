import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/level_system.dart';
import '../../shared/models/level_overview.dart';
import '../../shared/models/reward_rules.dart';
import '../../shared/models/stats_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../login/login_screen.dart';
import '../parent/parent_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth == null) return const LoginScreen();
    if (auth.isParent) return const ParentScreen();
    final profile = ref.watch(activeProfileProvider);
    if (profile == null) return const LoginScreen();

    final statsAsync = ref.watch(profileStatsProvider);
    final dailyAsync = ref.watch(dailyStatusProvider);
    final levelsAsync = ref.watch(studentLevelOverviewProvider(profile.id));
    final stats = statsAsync.valueOrNull ?? ProfileStats.empty;
    final daily = dailyAsync.valueOrNull ?? DailyStatus.empty;
    final levels = levelsAsync.valueOrNull;
    final level = LevelSystem.fromPoints(stats.points);
    final greeting = _greeting();

    final mascotAsset = AppAssets.skinAsset(profile.equippedSkinId) ??
        (daily.completedToday
            ? AppAssets.mascotCelebrating
            : AppAssets.mascotHappy);
    return PlayfulScaffold(
      backgroundImage: AppAssets.backgroundAsset(profile.equippedBackgroundId),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            Text(profile.name),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'المستويات التعليمية',
            onPressed: () {
              ref.read(audioServiceProvider).play(SoundEffect.tap);
              context.push('/levels');
            },
            icon: const Icon(Icons.school_rounded),
          ),
          IconButton(
            tooltip: 'الإعدادات',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_rounded),
          ),
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: () => _logout(context, ref),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileStatsProvider);
          ref.invalidate(dailyStatusProvider);
          ref.invalidate(tableMasteryProvider);
          await ref.read(profileStatsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
          children: [
            MascotBubble(
              asset: mascotAsset,
              message: daily.completedToday
                  ? 'أنجزت تحدي اليوم! أنت رائع يا ${profile.name}.'
                  : 'هل أنت مستعد لمغامرة جديدة يا ${profile.name}؟',
              onSpeak: () => ref.read(ttsServiceProvider).speak(
                    daily.completedToday
                        ? 'أنجزت تحدي اليوم! أنت رائع يا ${profile.name}.'
                        : 'هل أنت مستعد لمغامرة جديدة يا ${profile.name}؟',
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatChip(
                  icon: Icons.star_rounded,
                  label: 'نجمة',
                  value: ArabicNumbers.formatInt(stats.totalStars),
                  color: AppColors.sunSoft,
                  foreground: AppColors.sunDeep,
                ),
                StatChip(
                  icon: Icons.diamond_rounded,
                  label: 'جوهرة',
                  value: ArabicNumbers.formatInt(stats.gems),
                  color: AppColors.skySoft,
                  foreground: AppColors.skyDeep,
                ),
                StatChip(
                  icon: Icons.bolt_rounded,
                  label: 'نقطة',
                  value: ArabicNumbers.formatInt(stats.points),
                  color: AppColors.leafSoft,
                  foreground: AppColors.leafDeep,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _LevelCard(level: level, points: stats.points),
            const SizedBox(height: 16),
            _LearningLevelsCard(
              overview: levels,
              onOpen: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/levels');
              },
            ),
            const SizedBox(height: 16),
            _DailyCard(
              daily: daily,
              onOpen: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/daily');
              },
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Text(
                  'اختر مغامرتك',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Text(
                  'تعلّم والعب',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AdventureTile(
              title: 'جداول الضرب',
              subtitle: 'أتقن الجداول من ١ إلى ١٢',
              symbol: '×',
              color: AppColors.sky,
              onTap: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/multiplication');
              },
            ),
            const SizedBox(height: 10),
            _AdventureTile(
              title: 'القسمة',
              subtitle: 'اكتشف العلاقة بين الضرب والقسمة',
              symbol: '÷',
              color: AppColors.leaf,
              onTap: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/division');
              },
            ),
            const SizedBox(height: 10),
            _AdventureTile(
              title: 'الجمع والطرح',
              subtitle: 'تمارين سريعة وممتعة',
              symbol: '+',
              color: AppColors.coral,
              onTap: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/addition');
              },
            ),
            const SizedBox(height: 10),
            _AdventureTile(
              title: 'اختبر نفسك',
              subtitle: 'أسئلة مختلطة من كل الأنواع',
              symbol: '★',
              color: AppColors.purple,
              onTap: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/mixed');
              },
            ),
            const SizedBox(height: 10),
            _AdventureTile(
              title: 'امتحان المواضيع',
              subtitle: 'اختر موضوعاتك من الكتاب الدراسي',
              symbol: '📋',
              color: AppColors.ink,
              onTap: () {
                ref.read(audioServiceProvider).play(SoundEffect.tap);
                context.push('/topic-exam');
              },
            ),
            const SizedBox(height: 22),
            Text(
              'المزيد',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.15,
              children: [
                _QuickAction(
                  icon: Icons.insights_rounded,
                  label: 'تقدمي',
                  color: AppColors.sky,
                  onTap: () => context.push('/stats'),
                ),
                _QuickAction(
                  icon: Icons.emoji_events_rounded,
                  label: 'الإنجازات',
                  color: AppColors.sunDeep,
                  onTap: () => context.push('/achievements'),
                ),
                _QuickAction(
                  icon: Icons.storefront_rounded,
                  label: 'متجر المكافآت',
                  color: AppColors.purple,
                  onTap: () => context.push('/store'),
                ),
                _QuickAction(
                  icon: Icons.route_rounded,
                  label: 'المستويات',
                  color: AppColors.leaf,
                  onTap: () => context.push('/levels'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton.icon(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.tune_rounded, size: 19),
                label: const Text('إعدادات التطبيق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء الخير';
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'تسجيل الخروج؟',
      message: 'هل تريد الخروج من حسابك الحالي؟',
      confirmLabel: 'تسجيل الخروج',
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(authProvider.notifier).logout();
    if (!context.mounted) return;
    context.go('/login');
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.points});

  final LevelInfo level;
  final int points;

  @override
  Widget build(BuildContext context) {
    final progress = level.progress(points);
    final remaining = level.nextLevelPoints == null
        ? 0
        : (level.nextLevelPoints! - points).clamp(0, 999999);
    return AppCard(
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      borderColor: AppColors.leafSoft,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.leafSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              ArabicNumbers.formatInt(level.level),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.leafDeep,
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
                        'المستوى ${ArabicNumbers.formatInt(level.level)} • ${level.title}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (level.nextLevelPoints != null)
                      Text(
                        'باقي ${ArabicNumbers.formatInt(remaining)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                  ],
                ),
                const SizedBox(height: 9),
                ProgressPill(value: progress, color: AppColors.leaf),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningLevelsCard extends StatelessWidget {
  const _LearningLevelsCard({required this.overview, required this.onOpen});

  final StudentLevelOverview? overview;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final current = overview?.currentView;
    final completed = overview?.completedCount ?? 0;
    final total = overview?.totalLevels ?? 100;
    final subtitle = overview == null
        ? 'نجهّز خريطة المستويات...'
        : current == null
            ? 'أكملت جميع المستويات! أنت بطل الحساب.'
            : 'أكملت ${ArabicNumbers.formatInt(completed)} من ${ArabicNumbers.formatInt(total)} • التالي: ${current.level.title}';
    return AppCard(
      onTap: onOpen,
      color: AppColors.leafSoft,
      borderColor: AppColors.leaf.withValues(alpha: 0.25),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.route_rounded,
              color: AppColors.leafDeep,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'المستويات التعليمية',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      '${ArabicNumbers.formatInt(completed)}/${ArabicNumbers.formatInt(total)}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.leafDeep,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 8),
                ProgressPill(
                  value: overview?.completionRatio ?? 0,
                  color: AppColors.leaf,
                  height: 7,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.leafDeep,
          ),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  const _DailyCard({required this.daily, required this.onOpen});

  final DailyStatus daily;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final reward = SevenDayRewards.forDay(daily.rewardDayIndex);
    final labels = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
    return AppCard(
      color: daily.completedToday ? AppColors.leafSoft : AppColors.sunSoft,
      borderColor: (daily.completedToday ? AppColors.leaf : AppColors.sunDeep)
          .withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  daily.completedToday
                      ? Icons.check_rounded
                      : Icons.local_fire_department_rounded,
                  color: daily.completedToday
                      ? AppColors.leafDeep
                      : AppColors.coral,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التحدي اليومي',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      daily.completedToday
                          ? 'أكملت تحدي اليوم'
                          : 'سلسلة ${ArabicNumbers.formatInt(daily.streak)} أيام',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    'مكافأة اليوم',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  ),
                  Text(
                    '+${ArabicNumbers.formatInt(reward.stars)} ★',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.sunDeep,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final active = daily.weekDays[index];
              return Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? AppColors.leaf : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active ? AppColors.leaf : AppColors.border,
                      ),
                    ),
                    child: active
                        ? const Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: Colors.white,
                          )
                        : Text(
                            labels[index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 14),
          PressButton(
            onPressed: onOpen,
            expanded: true,
            color: daily.completedToday ? AppColors.leafDeep : AppColors.coral,
            minHeight: 48,
            child: Text(
              daily.completedToday
                  ? (daily.canClaimReward
                      ? 'استلم مكافأة السلسلة'
                      : 'أعد التحدي اليومي')
                  : 'ابدأ التحدي اليومي',
            ),
          ),
        ],
      ),
    );
  }
}

class _AdventureTile extends StatelessWidget {
  const _AdventureTile({
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String symbol;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionTile(
      title: title,
      subtitle: subtitle,
      symbol: symbol,
      color: color,
      onTap: onTap,
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderColor: color.withValues(alpha: 0.18),
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
            child: Text(
              label,
              maxLines: 2,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
