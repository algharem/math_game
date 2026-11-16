import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/achievements.dart';
import '../../shared/models/exam_models.dart';
import '../../shared/models/reward_rules.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../widgets/fraction_order_widget.dart';
import '../../widgets/fraction_story_widget.dart';
import '../../widgets/mixed_number_widget.dart';
import '../login/login_screen.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key, required this.args});

  final ResultArgs args;

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  late Future<ExamSaveOutcome> _saveFuture;
  bool _announced = false;

  ExamResultData get _result => widget.args.result;

  @override
  void initState() {
    super.initState();
    _saveFuture = _save();
  }

  Future<ExamSaveOutcome> _save() async {
    final outcome = await ref.read(databaseProvider).saveExamResult(_result);
    if (!mounted) return outcome;
    ref.invalidate(profileStatsProvider);
    ref.invalidate(dailyStatusProvider);
    ref.invalidate(achievementsProvider);
    ref.invalidate(tableMasteryProvider);
    ref.invalidate(examHistoryProvider);
    ref.invalidate(profilesProvider);
    ref.invalidate(unlockedCosmeticsProvider);
    ref.invalidate(studentLevelOverviewProvider(_result.profileId));
    ref.invalidate(accountsProvider);
    await ref.read(activeProfileProvider.notifier).refreshActiveProfile();
    await ref.read(authProvider.notifier).refreshCurrentUser();
    if (!_announced) {
      _announced = true;
      final audio = ref.read(audioServiceProvider);
      final effect = _result.isPerfect
          ? SoundEffect.trophy
          : (_result.stars >= 3 ? SoundEffect.celebration : SoundEffect.star);
      unawaited(audio.play(effect));
      final message = _result.isPerfect
          ? 'مذهل! كل الإجابات صحيحة. أنت بطل الحساب!'
          : _result.accuracy >= 60
              ? 'أحسنت! تقدمك رائع. واصل التدريب.'
              : 'لا بأس! كل محاولة تجعلك أقوى. لنراجع الأخطاء معًا.';
      unawaited(ref.read(ttsServiceProvider).speak(message));
    }
    return outcome;
  }

  void _retrySave() {
    setState(() {
      _announced = false;
      _saveFuture = _save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    if (auth == null) return const LoginScreen();
    final isLevel = _result.levelId != null;
    final homeLabel = isLevel ? 'العودة إلى المستويات' : 'العودة للرئيسية';
    void goHome() => context.go(isLevel ? '/levels' : '/home');
    return PlayfulScaffold(
      accent: _result.isPerfect ? AppColors.leaf : AppColors.sky,
      appBar: AppBar(
        title: Text(isLevel ? 'نتيجة المستوى' : 'نتيجة التمرين'),
        leading: IconButton(
          tooltip: homeLabel,
          onPressed: goHome,
          icon: Icon(isLevel ? Icons.route_rounded : Icons.home_rounded),
        ),
      ),
      body: FutureBuilder<ExamSaveOutcome>(
        future: _saveFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: 'نحسب نتيجتك ونحفظ تقدمك...');
          }
          if (snapshot.hasError) {
            return ErrorRetryView(
              message:
                  'تعذر حفظ النتيجة. قد تكون هناك مشكلة في التخزين. حاول مرة أخرى.',
              onRetry: _retrySave,
            );
          }
          final outcome = snapshot.data!;
          return _ResultsBody(
            result: _result,
            outcome: outcome,
            onHome: goHome,
            homeLabel: homeLabel,
            onRetry: () => context.push(
              '/retry',
              extra: RetryArgs(
                resultArgs: widget.args,
                onlyMistakes: false,
              ),
            ),
            onReviewMistakes: () => context.push(
              '/retry',
              extra: RetryArgs(
                resultArgs: widget.args,
                onlyMistakes: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.result,
    required this.outcome,
    required this.onHome,
    required this.onRetry,
    required this.onReviewMistakes,
    required this.homeLabel,
  });

  final ExamResultData result;
  final ExamSaveOutcome outcome;
  final VoidCallback onHome;
  final VoidCallback onRetry;
  final VoidCallback onReviewMistakes;
  final String homeLabel;

  @override
  Widget build(BuildContext context) {
    final mood = result.isPerfect
        ? AppAssets.mascotCelebrating
        : (result.accuracy >= 60
            ? AppAssets.mascotHappy
            : AppAssets.mascotEncouraging);
    final message = result.isPerfect
        ? 'نتيجة أسطورية! كل الإجابات صحيحة.'
        : result.accuracy >= 60
            ? 'عمل رائع! أنت تتقدم بثبات.'
            : 'لنراجع الأخطاء ونحاول مرة أخرى. أنت قادر!';
    final newAchievements = <AchievementDefinition>[];
    for (final id in outcome.newAchievements) {
      for (final achievement in AchievementEngine.all) {
        if (achievement.id == id) {
          newAchievements.add(achievement);
          break;
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      children: [
        AppCard(
          color: result.isPerfect ? AppColors.leafSoft : AppColors.skySoft,
          borderColor: (result.isPerfect ? AppColors.leaf : AppColors.sky)
              .withValues(alpha: 0.22),
          child: Column(
            children: [
              Image.asset(
                mood,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.emoji_nature_rounded,
                  size: 72,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                RewardRules.performanceLabel(result.accuracy),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: result.isPerfect
                          ? AppColors.leafDeep
                          : AppColors.skyDeep,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              StarsRow(earned: result.stars, size: 36),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'إجابات صحيحة',
                value: ArabicNumbers.formatInt(result.correct),
                color: AppColors.leafDeep,
                background: AppColors.leafSoft,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Metric(
                label: 'أخطاء',
                value: ArabicNumbers.formatInt(result.wrong),
                color: AppColors.coralDeep,
                background: AppColors.coralSoft,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Metric(
                label: 'بدون إجابة',
                value: ArabicNumbers.formatInt(result.unanswered),
                color: AppColors.mutedForeground,
                background: AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'الدقة ${ArabicNumbers.formatPercent(result.accuracy)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                'الوقت ${ArabicNumbers.formatDuration(result.durationSeconds)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          color: AppColors.sunSoft,
          borderColor: AppColors.sunDeep.withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مكافآتك',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatChip(
                    icon: Icons.star_rounded,
                    label: 'نجمة',
                    value: ArabicNumbers.formatInt(outcome.stars),
                    color: Colors.white,
                    foreground: AppColors.sunDeep,
                  ),
                  StatChip(
                    icon: Icons.diamond_rounded,
                    label: 'جوهرة',
                    value: ArabicNumbers.formatInt(outcome.gems),
                    color: Colors.white,
                    foreground: AppColors.skyDeep,
                  ),
                  StatChip(
                    icon: Icons.bolt_rounded,
                    label: 'نقطة',
                    value: ArabicNumbers.formatInt(outcome.points),
                    color: Colors.white,
                    foreground: AppColors.leafDeep,
                  ),
                ],
              ),
              if (outcome.dailyRewardApplied) ...[
                const SizedBox(height: 8),
                Text(
                  'تتضمن مكافأة التحدي اليومي +${ArabicNumbers.formatInt(RewardRules.dailyBonus)} نقطة.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
              if (outcome.alreadySaved) ...[
                const SizedBox(height: 8),
                Text(
                  'كانت هذه النتيجة محفوظة مسبقًا.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ],
          ),
        ),
        if (newAchievements.isNotEmpty) ...[
          const SizedBox(height: 14),
          AppCard(
            color: AppColors.purpleSoft,
            borderColor: AppColors.purple.withValues(alpha: 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.purple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'إنجازات جديدة!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                for (final achievement in newAchievements)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.leafDeep,
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            achievement.title,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          'مراجعة الإجابات',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        for (final answer in result.answers)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ReviewCard(answer: answer),
          ),
        const SizedBox(height: 16),
        if (result.mistakes.isNotEmpty) ...[
          PressButton(
            onPressed: onReviewMistakes,
            expanded: true,
            color: AppColors.coral,
            minHeight: 54,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.replay_rounded),
                SizedBox(width: 8),
                Text('تدرّب على الأخطاء'),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        PressButton(
          onPressed: onRetry,
          expanded: true,
          color: AppColors.sky,
          minHeight: 54,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restart_alt_rounded),
              SizedBox(width: 8),
              Text('إعادة الاختبار كاملًا'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onHome,
          icon: Icon(result.levelId == null
              ? Icons.home_rounded
              : Icons.route_rounded),
          label: Text(homeLabel),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.answer});

  final ExamAnswer answer;

  @override
  Widget build(BuildContext context) {
    final correct = answer.isCorrect;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: correct ? AppColors.leafSoft : AppColors.coralSoft,
        ),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: correct ? AppColors.leafSoft : AppColors.coralSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            correct ? Icons.check_rounded : Icons.close_rounded,
            color: correct ? AppColors.leafDeep : AppColors.coralDeep,
            size: 19,
          ),
        ),
        title: answer.question.isMixedNumber
            ? answer.question.mixedNumber!.isWordProblem
                ? FractionStoryPrompt(
                    question: answer.question.mixedNumber!,
                    fontSize: 14,
                    highlightColor: AppColors.skySoft,
                    showResult: true,
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: MixedNumberExpression(
                      question: answer.question.mixedNumber!,
                      fontSize: 18,
                      showResult: true,
                    ),
                  )
            : answer.question.isFractionOrder
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionOrderPrompt(
                      question: answer.question.fractionOrder!,
                      fontSize: 16,
                      showResult: true,
                    ),
                  )
                : Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      answer.question.equationText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
        subtitle: Text(
          correct
              ? 'إجابة صحيحة'
              : 'إجابتك: ${answer.childAnswerText} • الصحيحة: ${answer.question.answerText}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: correct ? AppColors.leafDeep : AppColors.coralDeep,
              ),
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              answer.question.explanation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
