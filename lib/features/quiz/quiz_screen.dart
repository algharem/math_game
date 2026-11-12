import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/quiz_builder_service.dart';
import '../../core/services/topic_question_factory.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../core/utils/id_generator.dart';
import '../../core/utils/number_parser.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_models.dart';
import '../../shared/models/question.dart';
import '../../shared/models/quiz_launch_data.dart';
import '../../shared/models/reward_rules.dart';
import '../../shared/widgets/app_widgets.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.launchData});

  final QuizLaunchData launchData;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final List<ExamAnswer> _answers = [];
  final TextEditingController _answerController = TextEditingController();
  late final DateTime _startedAt;
  late DateTime _questionStartedAt;
  Timer? _timer;
  int? _remainingSeconds;
  int _index = 0;
  int? _selectedChoice;
  String _typedAnswer = '';
  bool _submitting = false;
  bool _dialogOpen = false;

  /// Mutable copy of the launch questions. In adaptive topic exams the
  /// up-coming slot's question gets swapped between difficulty tiers.
  late final List<Question> _questions = List.of(_launch.questions);

  /// Adaptive pass 1: per-tier spare pools; [_slotTiers] remembers each
  /// question slot's tier so swapped-back questions return home.
  Map<TopicStrength, List<Question>> _adaptiveQueues = const {};
  List<TopicStrength> _slotTiers = const [];

  QuizLaunchData get _launch => widget.launchData;
  Question get _question => _questions[_index];

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _questionStartedAt = _startedAt;
    _initAdaptive();
    final duration = _launch.config.durationSeconds;
    if (duration != null) {
      _remainingSeconds = duration;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _submitting) return;
        final remaining = _remainingSeconds ?? 0;
        if (remaining <= 1) {
          setState(() => _remainingSeconds = 0);
          _finish(force: true);
        } else {
          setState(() => _remainingSeconds = remaining - 1);
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakQuestion());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  /// Adaptive pass 1: the launch questions are the easy-tier pool. The
  /// medium/hard pools wait in queues and upcoming slots swap tiers based
  /// on recent accuracy (before answering question 3 onward).
  void _initAdaptive() {
    final config = _launch.config;
    if (!config.isAdaptiveTopicExam) return;
    final tiers = QuizBuilderService.generateAdaptiveTiers(config);
    final easy = List.of(tiers[TopicStrength.easy] ?? const <Question>[]);
    final count = config.questionCount.clamp(1, easy.length);
    // Replace the cross-screen easy questions with this session's pool so
    // all tiers come from one coherent generation.
    _questions
      ..clear()
      ..addAll(easy.take(count));
    easy.removeRange(0, count);
    _adaptiveQueues = {
      TopicStrength.easy: easy,
      TopicStrength.medium: List.of(
        tiers[TopicStrength.medium] ?? const <Question>[],
      ),
      TopicStrength.hard: List.of(
        tiers[TopicStrength.hard] ?? const <Question>[],
      ),
    };
    _slotTiers = List.filled(_questions.length, TopicStrength.easy);
  }

  TopicStrength? _nextTier(TopicStrength current, {required bool harder}) {
    final values = TopicStrength.values;
    final next = current.index + (harder ? 1 : -1);
    return next >= 0 && next < values.length ? values[next] : null;
  }

  /// Swap the upcoming slot to an easier/harder question when the recent
  /// accuracy justifies it. Fired after every recorded answer.
  void _adjustNextQuestion() {
    if (_adaptiveQueues.isEmpty || _answers.isEmpty) return;
    final slot = _index + 1;
    if (slot >= _questions.length) return;
    final recent =
        _answers.length < 3 ? _answers : _answers.sublist(_answers.length - 3);
    if (recent.length < 2) return;
    final ratio =
        recent.where((answer) => answer.isCorrect).length / recent.length;
    final current = _slotTiers[slot];
    TopicStrength? target;
    if (ratio >= 0.67) {
      target = _nextTier(current, harder: true);
    } else if (ratio <= 0.16) {
      target = _nextTier(current, harder: false);
    }
    if (target == null || target == current) return;
    final queue = _adaptiveQueues[target];
    if (queue == null || queue.isEmpty) return;
    _adaptiveQueues[current]!.add(_questions[slot]);
    _questions[slot] = queue.removeAt(0);
    _slotTiers[slot] = target;
  }

  Future<void> _speakQuestion() async {
    if (!mounted) return;
    await ref.read(ttsServiceProvider).speak(_question.readAloudText);
  }

  void _selectChoice(int choice) {
    if (_submitting) return;
    setState(() => _selectedChoice = choice);
    ref.read(audioServiceProvider).play(SoundEffect.tap);
  }

  void _appendDigit(String digit) {
    if (_submitting) return;
    final next = NumberParser.appendDigit(_typedAnswer, digit);
    setState(() {
      _typedAnswer = next;
      _answerController.text = next;
      _answerController.selection = TextSelection.collapsed(
        offset: _answerController.text.length,
      );
    });
    ref.read(audioServiceProvider).play(SoundEffect.tap);
  }

  void _backspace() {
    if (_submitting) return;
    final next = NumberParser.removeLastDigit(_typedAnswer);
    setState(() {
      _typedAnswer = next;
      _answerController.text = next;
    });
  }

  void _clearAnswer() {
    if (_submitting) return;
    setState(() {
      _typedAnswer = '';
      _answerController.clear();
    });
  }

  bool get _canConfirm {
    if (_launch.config.answerMode == AnswerMode.multipleChoice) {
      return _selectedChoice != null;
    }
    return _typedAnswer.trim().isNotEmpty;
  }

  void _confirmAnswer() {
    if (!_canConfirm || _submitting) return;
    final answer = _launch.config.answerMode == AnswerMode.multipleChoice
        ? _selectedChoice
        : NumberParser.parseInt(_typedAnswer);
    if (answer == null) {
      showAppSnack(context, 'اكتب الإجابة أولًا.', isError: true);
      return;
    }
    final elapsed = DateTime.now().difference(_questionStartedAt).inSeconds;
    _answers.add(
      ExamAnswer(
        question: _question,
        childAnswer: answer,
        isCorrect: _question.isCorrect(answer),
        timeSpentSeconds: elapsed.clamp(0, 3600),
      ),
    );
    ref.read(audioServiceProvider).play(SoundEffect.tap);
    if (_index >= _questions.length - 1) {
      _finish();
      return;
    }
    _adjustNextQuestion();
    setState(() {
      _index++;
      _selectedChoice = null;
      _typedAnswer = '';
      _answerController.clear();
      _questionStartedAt = DateTime.now();
    });
    _speakQuestion();
  }

  Future<void> _finish({bool force = false}) async {
    if (_submitting) return;
    _submitting = true;
    _timer?.cancel();
    final now = DateTime.now();
    if (force) {
      for (var index = _answers.length; index < _questions.length; index++) {
        _answers.add(
          ExamAnswer(
            question: _questions[index],
            childAnswer: null,
            isCorrect: false,
            timeSpentSeconds: 0,
          ),
        );
      }
    }
    final total = _questions.length;
    final correct = _answers.where((answer) => answer.isCorrect).length;
    final wrong = _answers
        .where((answer) => !answer.isCorrect && answer.childAnswer != null)
        .length;
    final unanswered =
        _answers.where((answer) => answer.childAnswer == null).length;
    final answered = total - unanswered;
    final stars = RewardRules.starsFor(correct, total);
    final gems = RewardRules.gemsFor(correct, total);
    final points = answered == 0
        ? 0
        : RewardRules.pointsFor(
            correct: correct,
            total: total,
            isDaily: _launch.config.isDaily,
          );
    final result = ExamResultData(
      sessionId: IdGenerator.next(),
      profileId: ref.read(activeProfileProvider)?.id ?? '',
      config: _launch.config,
      total: total,
      correct: correct,
      wrong: wrong,
      unanswered: unanswered,
      stars: stars,
      gems: gems,
      points: points,
      durationSeconds: now.difference(_startedAt).inSeconds,
      startedAt: _startedAt,
      finishedAt: now,
      answers: List.unmodifiable(_answers),
    );
    if (!mounted) return;
    context.pushReplacement(
      '/results',
      extra: ResultArgs(result: result, launchData: _launch),
    );
  }

  Future<void> _confirmLeave() async {
    if (_dialogOpen || _submitting) return;
    _dialogOpen = true;
    final leave = await showConfirmDialog(
      context,
      title: 'إنهاء التمرين؟',
      message:
          'ستُحسب الأسئلة المتبقية غير مجابة، وسيظهر تقريرك الحالي. هل تريد المتابعة؟',
      confirmLabel: 'إنهاء وعرض النتيجة',
      cancelLabel: 'متابعة التمرين',
    );
    _dialogOpen = false;
    if (leave) {
      await _finish(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _launch.config;
    final progress =
        _questions.isEmpty ? 0.0 : (_index + 1) / _questions.length;
    final isMultipleChoice = config.answerMode == AnswerMode.multipleChoice;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmLeave();
      },
      child: PlayfulScaffold(
        accent: AppColors.sky,
        appBar: AppBar(
          title: Text(config.title),
          leading: IconButton(
            tooltip: 'إنهاء التمرين',
            onPressed: _confirmLeave,
            icon: const Icon(Icons.close_rounded),
          ),
          actions: [
            if (_remainingSeconds != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _TimerPill(seconds: _remainingSeconds!),
              ),
            IconButton(
              tooltip: 'اسمع السؤال',
              onPressed: _speakQuestion,
              icon: const Icon(Icons.volume_up_rounded),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'السؤال ${ArabicNumbers.formatInt(_index + 1)} من ${ArabicNumbers.formatInt(_questions.length)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Spacer(),
                  Text(
                    config.difficulty.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ProgressPill(value: progress, color: AppColors.sky),
              const SizedBox(height: 18),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 26,
                ),
                color: Colors.white,
                borderColor: AppColors.skySoft,
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        _question.equationText,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.skyDeep,
                                  fontSize: 42,
                                ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر الإجابة الصحيحة',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                    ),
                    if (_question.topicLabel != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _question.topicLabel!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.skyDeep,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (isMultipleChoice)
                _ChoiceGrid(
                  choices: _question.choices,
                  selected: _selectedChoice,
                  onSelected: _selectChoice,
                )
              else
                _TypedAnswer(
                  controller: _answerController,
                  answer: _typedAnswer,
                  onDigit: _appendDigit,
                  onBackspace: _backspace,
                  onClear: _clearAnswer,
                ),
              const SizedBox(height: 20),
              PressButton(
                onPressed: _canConfirm ? _confirmAnswer : null,
                expanded: true,
                minHeight: 58,
                color: AppColors.leafDeep,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _index == _questions.length - 1
                          ? Icons.flag_rounded
                          : Icons.arrow_back_rounded,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _index == _questions.length - 1
                          ? 'إنهاء وعرض النتيجة'
                          : 'تأكيد الإجابة',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final urgent = seconds <= 15;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: urgent ? AppColors.coralSoft : AppColors.skySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 17,
            color: urgent ? AppColors.coralDeep : AppColors.skyDeep,
          ),
          const SizedBox(width: 4),
          Text(
            ArabicNumbers.formatClock(seconds),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: urgent ? AppColors.coralDeep : AppColors.skyDeep,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceGrid extends StatelessWidget {
  const _ChoiceGrid({
    required this.choices,
    required this.selected,
    required this.onSelected,
  });

  final List<int> choices;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.9,
      children: [
        for (final choice in choices)
          _ChoiceButton(
            value: choice,
            selected: selected == choice,
            onTap: () => onSelected(choice),
          ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: selected ? AppColors.sky : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? AppColors.sky : AppColors.border,
          width: selected ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.sky.withValues(alpha: selected ? 0.22 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Center(
            child: Text(
              ArabicNumbers.formatInt(value),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: selected ? Colors.white : AppColors.ink,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypedAnswer extends StatelessWidget {
  const _TypedAnswer({
    required this.controller,
    required this.answer,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  final TextEditingController controller;
  final String answer;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          readOnly: true,
          showCursor: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.skyDeep,
                letterSpacing: 4,
              ),
          decoration: const InputDecoration(
            hintText: '؟',
            prefixIcon: Icon(Icons.edit_rounded),
          ),
        ),
        const SizedBox(height: 14),
        NumericKeypad(
          onDigit: onDigit,
          onBackspace: onBackspace,
          onClear: onClear,
        ),
        if (answer.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'استخدم لوحة الأرقام لكتابة الإجابة',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
          ),
      ],
    );
  }
}
