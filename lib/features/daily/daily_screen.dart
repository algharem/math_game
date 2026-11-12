import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../core/utils/date_keys.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_config.dart';
import '../../shared/models/reward_rules.dart';
import '../../shared/models/stats_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../practice/practice_setup.dart';

class DailyScreen extends ConsumerStatefulWidget {
  const DailyScreen({super.key});

  @override
  ConsumerState<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends ConsumerState<DailyScreen> {
  bool _claiming = false;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeProfileProvider);
    final dailyAsync = ref.watch(dailyStatusProvider);
    final daily = dailyAsync.valueOrNull ?? DailyStatus.empty;
    final labels = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

    return PlayfulScaffold(
      accent: AppColors.sun,
      appBar: AppBar(
        title: const Text('التحدي اليومي'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: dailyAsync.isLoading
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              children: [
                MascotBubble(
                  asset: daily.completedToday
                      ? AppAssets.mascotCelebrating
                      : AppAssets.mascotEncouraging,
                  message: daily.completedToday
                      ? 'أحسنت! يمكنك إعادة التحدي كما تريد، والمكافأة اليومية تُحتسب مرة واحدة.'
                      : 'تحدي اليوم عشر أسئلة مختلطة. هل تقبل التحدي؟',
                  onSpeak: () => ref.read(ttsServiceProvider).speak(
                        daily.completedToday
                            ? 'أحسنت! يمكنك إعادة التحدي كما تريد، والمكافأة اليومية تحتسب مرة واحدة.'
                            : 'تحدي اليوم عشر أسئلة مختلطة. هل تقبل التحدي؟',
                      ),
                ),
                const SizedBox(height: 18),
                AppCard(
                  color: AppColors.sunSoft,
                  borderColor: AppColors.sunDeep.withValues(alpha: 0.25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.coral,
                            size: 42,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سلسلة ${ArabicNumbers.formatInt(daily.streak)} أيام',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(
                                  daily.completedToday
                                      ? 'تحدي اليوم مكتمل — يمكنك الإعادة'
                                      : 'أكمل تحدي اليوم لتحافظ على السلسلة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.mutedForeground,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (daily.completedToday)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.leafDeep,
                              size: 34,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final active = daily.weekDays[index];
                          return Column(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: active ? AppColors.leaf : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: active
                                        ? AppColors.leaf
                                        : AppColors.border,
                                  ),
                                ),
                                child: active
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 19,
                                        color: Colors.white,
                                      )
                                    : Text(labels[index]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                labels[index],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'مكافآت الأسبوع',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: SevenDayRewards.days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final reward = SevenDayRewards.days[index];
                    final current = reward.day == daily.rewardDayIndex;
                    final claimed = reward.day < daily.rewardDayIndex ||
                        (daily.rewardClaimedToday && current);
                    return Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: current ? AppColors.skySoft : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: current
                              ? AppColors.sky
                              : Theme.of(context).colorScheme.outline,
                          width: current ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'اليوم ${ArabicNumbers.formatInt(reward.day)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            claimed
                                ? Icons.check_circle_rounded
                                : Icons.card_giftcard_rounded,
                            color: claimed ? AppColors.leaf : AppColors.sunDeep,
                            size: 25,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '+${ArabicNumbers.formatInt(reward.stars)} ★',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.sunDeep,
                                  fontSize: 12,
                                ),
                          ),
                          Text(
                            '+${ArabicNumbers.formatInt(reward.gems)} ◆',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.skyDeep,
                                      fontSize: 10,
                                    ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                if (daily.completedToday) ...[
                  AppCard(
                    color: AppColors.leafSoft,
                    borderColor: AppColors.leaf.withValues(alpha: 0.2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.leafDeep,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'أكملت تحدي اليوم. يمكنك إعادته لتحسين نتيجتك، والمكافأة اليومية تُحتسب مرة واحدة فقط.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                PressButton(
                  onPressed: profile == null ? null : _startDaily,
                  expanded: true,
                  color: AppColors.coral,
                  minHeight: 58,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        daily.completedToday
                            ? Icons.replay_rounded
                            : Icons.local_fire_department_rounded,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        daily.completedToday
                            ? 'أعد تحدي اليوم'
                            : 'ابدأ تحدي اليوم',
                      ),
                    ],
                  ),
                ),
                if (daily.canClaimReward) ...[
                  const SizedBox(height: 10),
                  PressButton(
                    onPressed: _claiming || profile == null ? null : _claim,
                    expanded: true,
                    color: AppColors.leafDeep,
                    minHeight: 58,
                    child: _claiming
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.card_giftcard_rounded),
                              SizedBox(width: 8),
                              Text('استلم مكافأة السلسلة'),
                            ],
                          ),
                  ),
                ],
              ],
            ),
    );
  }

  void _startDaily() {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    final settings = ref.read(settingsProvider);
    final config = ExamConfig(
      section: MathSection.daily,
      title: 'تحدي اليوم',
      questionCount: 10,
      difficulty: Difficulty.easy,
      source: ExamSource.daily,
      answerMode: AnswerMode.multipleChoice,
      dailyDateKey: DateKeys.today(),
      durationSeconds: settings.timersEnabled ? 120 : null,
      schoolGrade: profile.schoolGrade,
    );
    launchQuiz(context, ref, config);
  }

  Future<void> _claim() async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    setState(() => _claiming = true);
    try {
      final reward = await ref
          .read(databaseProvider)
          .claimSevenDayReward(profile.id, DateKeys.today());
      if (!mounted) return;
      if (reward == null) {
        showAppSnack(context, 'المكافأة مستلمة بالفعل.', isError: true);
      } else {
        ref.read(audioServiceProvider).play(SoundEffect.celebration);
        ref.invalidate(dailyStatusProvider);
        ref.invalidate(profileStatsProvider);
        ref.invalidate(profilesProvider);
        await ref.read(activeProfileProvider.notifier).refreshActiveProfile();
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('مكافأة رائعة!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.sunDeep,
                  size: 58,
                ),
                const SizedBox(height: 14),
                Text(
                  'حصلت على ${ArabicNumbers.formatInt(reward.stars)} نجوم و${ArabicNumbers.formatInt(reward.gems)} جوهرة.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('رائع'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        showAppSnack(
          context,
          'تعذر استلام المكافأة. حاول مرة أخرى.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }
}
