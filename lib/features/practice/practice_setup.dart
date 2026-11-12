import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/quiz_builder_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_config.dart';
import '../../shared/models/quiz_launch_data.dart';
import '../../shared/widgets/app_widgets.dart';

Future<ExamConfig?> showPracticeSetup(
  BuildContext context, {
  required ExamConfig initial,
  bool allowQuestionCount = false,
  bool allowMultiplicationFormat = false,
  bool allowDivisionFormat = false,
  bool allowTimer = true,
}) {
  return showModalBottomSheet<ExamConfig>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _PracticeSetupSheet(
      initial: initial,
      allowQuestionCount: allowQuestionCount,
      allowMultiplicationFormat: allowMultiplicationFormat,
      allowDivisionFormat: allowDivisionFormat,
      allowTimer: allowTimer,
    ),
  );
}

void launchQuiz(
  BuildContext context,
  WidgetRef ref,
  ExamConfig config,
) {
  final questions = QuizBuilderService.generate(config);
  if (questions.isEmpty) {
    showAppSnack(context, 'تعذر تجهيز الأسئلة. حاول مرة أخرى.', isError: true);
    return;
  }
  ref.read(audioServiceProvider).play(SoundEffect.tap);
  context.push(
    '/quiz',
    extra: QuizLaunchData(config: config, questions: questions),
  );
}

class _PracticeSetupSheet extends StatefulWidget {
  const _PracticeSetupSheet({
    required this.initial,
    required this.allowQuestionCount,
    required this.allowMultiplicationFormat,
    required this.allowDivisionFormat,
    required this.allowTimer,
  });

  final ExamConfig initial;
  final bool allowQuestionCount;
  final bool allowMultiplicationFormat;
  final bool allowDivisionFormat;
  final bool allowTimer;

  @override
  State<_PracticeSetupSheet> createState() => _PracticeSetupSheetState();
}

class _PracticeSetupSheetState extends State<_PracticeSetupSheet> {
  late ExamConfig _config = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'جهّز التمرين',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              _config.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            const SizedBox(height: 20),
            _Label('مستوى الصعوبة'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final difficulty in Difficulty.values)
                  ChoiceChip(
                    label: Text(difficulty.label),
                    selected: _config.difficulty == difficulty,
                    onSelected: (_) =>
                        setState(() => _config = _config.copyWith(
                              difficulty: difficulty,
                            )),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            _Label('طريقة الإجابة'),
            Wrap(
              spacing: 8,
              children: [
                for (final mode in AnswerMode.values)
                  ChoiceChip(
                    label: Text(mode.label),
                    selected: _config.answerMode == mode,
                    onSelected: (_) => setState(
                      () => _config = _config.copyWith(answerMode: mode),
                    ),
                  ),
              ],
            ),
            if (widget.allowQuestionCount) ...[
              const SizedBox(height: 18),
              _Label('عدد الأسئلة'),
              Wrap(
                spacing: 8,
                children: [
                  for (final count in [5, 10, 15, 20])
                    ChoiceChip(
                      label: Text(ArabicNumbers.formatInt(count)),
                      selected: _config.questionCount == count,
                      onSelected: (_) => setState(
                        () => _config = _config.copyWith(questionCount: count),
                      ),
                    ),
                ],
              ),
            ],
            if (widget.allowMultiplicationFormat) ...[
              const SizedBox(height: 18),
              _Label('نوع السؤال'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final format in MultiplicationFormat.values)
                    ChoiceChip(
                      label: Text(format.label),
                      selected: _config.multiplicationFormat == format,
                      onSelected: (_) => setState(
                        () => _config = _config.copyWith(
                          multiplicationFormat: format,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (widget.allowDivisionFormat) ...[
              const SizedBox(height: 18),
              _Label('نوع السؤال'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final format in DivisionFormat.values)
                    ChoiceChip(
                      label: Text(format.label),
                      selected: _config.divisionFormat == format,
                      onSelected: (_) => setState(
                        () => _config = _config.copyWith(
                          divisionFormat: format,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (widget.allowTimer) ...[
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('تفعيل المؤقت'),
                subtitle: const Text('دقيقة ونصف للتمرين'),
                value: _config.durationSeconds != null,
                onChanged: (value) => setState(
                  () => _config = value
                      ? _config.copyWith(durationSeconds: 90)
                      : _config.copyWith(clearDuration: true),
                ),
              ),
            ],
            const SizedBox(height: 18),
            PressButton(
              onPressed: () => Navigator.of(context).pop(_config),
              expanded: true,
              minHeight: 58,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded),
                  SizedBox(width: 8),
                  Text('ابدأ التمرين'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
