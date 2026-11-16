import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/quiz_builder_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_models.dart';
import '../../shared/models/quiz_launch_data.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../widgets/fraction_order_widget.dart';
import '../../widgets/mixed_number_widget.dart';
import '../login/login_screen.dart';

class RetryScreen extends ConsumerWidget {
  const RetryScreen({super.key, required this.args});

  final RetryArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth == null) return const LoginScreen();
    final result = args.resultArgs.result;
    final isLevel = result.levelId != null;
    final mistakes = result.mistakes;
    return PlayfulScaffold(
      accent: AppColors.coral,
      appBar: AppBar(
        title: Text(args.onlyMistakes ? 'مراجعة الأخطاء' : 'إعادة المحاولة'),
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
            asset: mistakes.isEmpty
                ? AppAssets.mascotCelebrating
                : AppAssets.mascotEncouraging,
            message: mistakes.isEmpty
                ? 'لا توجد أخطاء لمراجعتها. يمكنك إعادة الاختبار لتحدٍّ جديد!'
                : 'الأخطاء فرص للتعلم. راجعها ثم جرّب مرة أخرى.',
            onSpeak: () => ref.read(ttsServiceProvider).speak(
                  mistakes.isEmpty
                      ? 'لا توجد أخطاء لمراجعتها. يمكنك إعادة الاختبار لتحدٍّ جديد!'
                      : 'الأخطاء فرص للتعلم. راجعها ثم جرّب مرة أخرى.',
                ),
          ),
          const SizedBox(height: 18),
          if (mistakes.isNotEmpty) ...[
            Text(
              'أخطاء تحتاج إلى تدريب',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            for (final answer in mistakes)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: answer.question.isMixedNumber
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerStart,
                                    child: MixedNumberExpression(
                                      question: answer.question.mixedNumber!,
                                      fontSize: 22,
                                      textColor: AppColors.skyDeep,
                                      showResult: true,
                                    ),
                                  )
                                : answer.question.isFractionOrder
                                    ? FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: FractionOrderPrompt(
                                          question:
                                              answer.question.fractionOrder!,
                                          fontSize: 18,
                                          textColor: AppColors.skyDeep,
                                          highlightColor: AppColors.skySoft,
                                          showResult: true,
                                        ),
                                      )
                                    : Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          answer.question.equationText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                          ),
                          if (!answer.question.isVisual)
                            Text(
                              'الصحيحة: ${answer.question.answerText}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: AppColors.leafDeep,
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        answer.question.explanation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            PressButton(
              onPressed: () => _startMistakes(context, ref, mistakes),
              expanded: true,
              color: AppColors.coral,
              minHeight: 56,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.replay_rounded),
                  const SizedBox(width: 8),
                  Text(
                    'تدرّب على ${ArabicNumbers.formatInt(mistakes.length)} أسئلة',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          PressButton(
            onPressed: () => _startFull(context, ref),
            expanded: true,
            color: AppColors.sky,
            minHeight: 56,
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
            onPressed: () => context.go(isLevel ? '/levels' : '/home'),
            icon: Icon(isLevel ? Icons.route_rounded : Icons.home_rounded),
            label: Text(
              isLevel ? 'العودة إلى المستويات' : 'العودة للرئيسية',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startMistakes(
    BuildContext context,
    WidgetRef ref,
    List<ExamAnswer> mistakes,
  ) async {
    final original = args.resultArgs.result.config;
    final config = original.copyWith(
      source: ExamSource.retry,
      title: 'مراجعة الأخطاء',
      questionCount: mistakes.length,
      clearDuration: true,
    );
    await _markLevelStarted(ref);
    if (!context.mounted) return;
    _launch(
      context,
      ref,
      QuizLaunchData(
        config: config,
        questions:
            mistakes.map((answer) => answer.question).toList(growable: false),
      ),
    );
  }

  Future<void> _startFull(BuildContext context, WidgetRef ref) async {
    final original = args.resultArgs.result.config;
    final config = original.copyWith(
      source: ExamSource.retry,
      title: original.title,
      clearDuration: true,
    );
    final questions = QuizBuilderService.generate(config);
    if (questions.isEmpty) {
      showAppSnack(context, 'تعذر تجهيز الأسئلة. حاول مرة أخرى.',
          isError: true);
      return;
    }
    await _markLevelStarted(ref);
    if (!context.mounted) return;
    _launch(
      context,
      ref,
      QuizLaunchData(config: config, questions: questions),
    );
  }

  Future<void> _markLevelStarted(WidgetRef ref) async {
    final levelId = args.resultArgs.result.levelId;
    final profile = ref.read(activeProfileProvider);
    if (levelId == null || profile == null) return;
    await ref.read(databaseProvider).markLevelStarted(
          profileId: profile.id,
          levelId: levelId,
        );
    ref.invalidate(studentLevelOverviewProvider(profile.id));
  }

  void _launch(BuildContext context, WidgetRef ref, QuizLaunchData data) {
    ref.read(audioServiceProvider).play(SoundEffect.tap);
    context.push('/quiz', extra: data);
  }
}
