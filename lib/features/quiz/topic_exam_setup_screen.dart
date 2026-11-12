import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/quiz_builder_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/curriculum_topic.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/exam_config.dart';
import '../../shared/models/quiz_launch_data.dart';
import '../../shared/widgets/app_widgets.dart';

/// Async load of the curriculum topics for one (grade, part) pair, served
/// from the seeded `curriculumTopics` table.
final _gradeTopicsProvider = FutureProvider.autoDispose
    .family<List<CurriculumTopic>, (int, int)>((ref, key) async {
  final (grade, part) = key;
  final database = ref.watch(databaseProvider);
  final rows = await database.getCurriculumTopics(grade: grade, part: part);
  return rows
      .map(
        (row) => CurriculumTopic(
          id: row.id,
          grade: row.grade,
          part: row.part,
          title: row.title,
          unitName: row.unitName,
          pageReference: row.pageReference,
          generationReady: row.generationReady,
        ),
      )
      .toList(growable: false);
});

/// Exam configuration screen: semester part, topic checklist, exam mode,
/// question count / timer and difficulty — all strictly topic-driven.
class TopicExamSetupScreen extends ConsumerStatefulWidget {
  const TopicExamSetupScreen({super.key});

  @override
  ConsumerState<TopicExamSetupScreen> createState() =>
      _TopicExamSetupScreenState();
}

class _TopicExamSetupScreenState extends ConsumerState<TopicExamSetupScreen> {
  int _part = 1;
  ExamMode _mode = ExamMode.quickPractice;
  int _questionCount = 8;
  int _durationMinutes = 20;
  String _difficultyLevel = 'medium';
  final Set<String> _selectedTopicIds = <String>{};
  bool _selectionLoadedFor = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureSelectionLoaded();
  }

  Future<void> _ensureSelectionLoaded() async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null || _selectionLoadedFor) return;
    _selectionLoadedFor = true;
    final saved = await ref.read(databaseProvider).getTopicSelection(
          profileId: profile.id,
          grade: profile.schoolGrade,
          part: _part,
        );
    if (!mounted) return;
    setState(() {
      _selectedTopicIds
        ..clear()
        ..addAll(saved);
    });
  }

  void _switchPart(int part) {
    if (part == _part) return;
    setState(() => _part = part);
    _selectionLoadedFor = false;
    _ensureSelectionLoaded();
  }

  void _setMode(ExamMode mode) {
    setState(() {
      _mode = mode;
      _questionCount = _questionCount.clamp(_minCount, _maxCount);
    });
  }

  int get _minCount => switch (_mode) {
        ExamMode.quickPractice => 5,
        ExamMode.adaptiveExam => 10,
        _ => 15,
      };

  int get _maxCount => switch (_mode) {
        ExamMode.quickPractice => 10,
        _ => 20,
      };

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeProfileProvider);
    final grade = profile?.schoolGrade ?? 1;
    final topicsAsync = ref.watch(_gradeTopicsProvider((grade, _part)));
    return PlayfulScaffold(
      accent: AppColors.sky,
      appBar: AppBar(
        title: const Text('إعداد الامتحان'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: topicsAsync.when(
        loading: () => const LoadingView(message: 'جارٍ تحميل المواضيع…'),
        error: (_, __) => ErrorRetryView(
          message: 'تعذر تحميل قائمة المواضيع.',
          onRetry: () => ref.invalidate(_gradeTopicsProvider((grade, _part))),
        ),
        data: (topics) => _buildBody(context, grade, topics),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    int grade,
    List<CurriculumTopic> topics,
  ) {
    // Drop stale selections (seed changed) but keep the rest so switching
    // parts back and forth preserves what the family checked.
    _selectedTopicIds.removeWhere(
      (id) => !topics.any((topic) => topic.id == id),
    );
    final readyCount = topics.where((topic) => topic.generationReady).length;
    final canStart = _selectedTopicIds.isNotEmpty &&
        readyCount > 0 &&
        _hasReadyTopic(topics);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        MascotBubble(
          asset: AppAssets.mascotEncouraging,
          message:
              'اختر الموضوعات التي درستها وسأسألك عنها فقط. بالتوفيق بطلنا!',
          onSpeak: () => ref.read(ttsServiceProvider).speak(
                'اختر الموضوعات التي درستها وسأسألك عنها فقط. بالتوفيق بطلنا!',
              ),
        ),
        const SizedBox(height: 18),
        Text(
          'الصف ${ArabicNumbers.formatInt(grade)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
              ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final part in const [1, 2])
              ChoiceChip(
                label: Text(
                  part == 1
                      ? 'الجزء الأول (الفصل الأول)'
                      : 'الجزء الثاني (الفصل الثاني)',
                ),
                selected: _part == part,
                onSelected: (_) => _switchPart(part),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          borderColor: AppColors.sky.withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'الموضوعات ($readyCount متاح)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: readyCount == 0
                        ? null
                        : () => setState(() {
                              _selectedTopicIds
                                ..clear()
                                ..addAll(
                                  topics
                                      .where((topic) => topic.generationReady)
                                      .map((topic) => topic.id),
                                );
                            }),
                    child: const Text('تحديد الكل'),
                  ),
                  TextButton(
                    onPressed: _selectedTopicIds.isEmpty
                        ? null
                        : () => setState(() => _selectedTopicIds.clear()),
                    child: const Text('إلغاء الكل'),
                  ),
                ],
              ),
              const Divider(height: 20),
              ...topics.map(_topicTile),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader('نمط الامتحان'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final mode in ExamMode.values)
              ChoiceChip(
                label: Text(mode.label),
                selected: _mode == mode,
                onSelected: (_) => _setMode(mode),
              ),
          ],
        ),
        Text(
          _mode.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
              ),
        ),
        const SizedBox(height: 16),
        _SectionHeader('مستوى الصعوبة'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final level in ExamFilterConfig.difficultyLevels)
              ChoiceChip(
                label: Text(_difficultyLabel(level)),
                selected: _difficultyLevel == level,
                onSelected: (_) => setState(() => _difficultyLevel = level),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          'عدد الأسئلة (${ArabicNumbers.formatInt(_questionCount)})',
        ),
        Slider(
          value: _questionCount.toDouble(),
          min: _minCount.toDouble(),
          max: _maxCount.toDouble(),
          divisions: _maxCount - _minCount,
          label: ArabicNumbers.formatInt(_questionCount),
          onChanged: (value) => setState(() => _questionCount = value.round()),
        ),
        if (_mode == ExamMode.timedExam) ...[
          _SectionHeader(
            'زمن الامتحان (${ArabicNumbers.formatInt(_durationMinutes)} دقيقة)',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final minutes in const [5, 10, 15, 20, 30, 45])
                ChoiceChip(
                  label: Text('${ArabicNumbers.formatInt(minutes)} د'),
                  selected: _durationMinutes == minutes,
                  onSelected: (_) => setState(() => _durationMinutes = minutes),
                ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        _StartButton(
          enabled: canStart,
          onPressed: () => _startExam(topics),
        ),
      ],
    );
  }

  bool _hasReadyTopic(List<CurriculumTopic> topics) {
    return _selectedTopicIds.any((id) {
      final topic = topics.where((candidate) => candidate.id == id).firstOrNull;
      return topic?.generationReady ?? false;
    });
  }

  Future<void> _startExam(List<CurriculumTopic> topics) async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null || !_hasReadyTopic(topics)) return;
    // Only generation-ready topics ever reach the engine.
    final topicIds = _selectedTopicIds
        .where(
          (id) =>
              topics.any((topic) => topic.id == id && topic.generationReady),
        )
        .toList(growable: false);
    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'امتحان حسب المواضيع المختارة',
      questionCount: _questionCount,
      durationSeconds:
          _mode == ExamMode.timedExam ? _durationMinutes * 60 : null,
      source: ExamSource.exam,
      schoolGrade: profile.schoolGrade,
      topicIds: topicIds,
      bookPart: _part,
      examMode: _mode,
      topicDifficultyLevel: _difficultyLevel,
    );
    await ref.read(databaseProvider).saveTopicSelection(
          profileId: profile.id,
          grade: profile.schoolGrade,
          part: _part,
          topicIds: topicIds,
        );
    if (!mounted) return;
    ref.read(audioServiceProvider).play(SoundEffect.tap);
    final questions = _mode == ExamMode.adaptiveExam
        ? QuizBuilderService.generateAdaptivePool(config)
            .take(config.questionCount)
            .toList(growable: false)
        : QuizBuilderService.generate(config);
    if (questions.isEmpty) {
      showAppSnack(
        context,
        'تعذر تجهيز الأسئلة. حاول مرة أخرى.',
        isError: true,
      );
      return;
    }
    context.push(
      '/quiz',
      extra: QuizLaunchData(config: config, questions: questions),
    );
  }

  Widget _topicTile(CurriculumTopic topic) {
    final enabled = topic.generationReady;
    final checked = _selectedTopicIds.contains(topic.id);
    final subtitle = <String>[
      topic.unitName,
      if (topic.pageReference != null)
        'ص ${ArabicNumbers.formatInt(topic.pageReference!)}',
    ].join(' • ');
    return CheckboxListTile(
      value: checked,
      // Unavailable topics stay visible but cannot be checked («قريباً»).
      onChanged: enabled
          ? (value) => setState(() {
                if (value == true) {
                  _selectedTopicIds.add(topic.id);
                } else {
                  _selectedTopicIds.remove(topic.id);
                }
              })
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      controlAffinity: ListTileControlAffinity.trailing,
      dense: true,
      title: Text(
        topic.title,
        style: TextStyle(
          fontSize: 14,
          color: enabled ? null : AppColors.mutedForeground,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      secondary: enabled
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.sun.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'قريباً',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.sunDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }

  String _difficultyLabel(String level) => switch (level) {
        'easy' => 'سهل',
        'medium' => 'متوسط',
        'hard' => 'صعب',
        _ => 'متنوع',
      };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PressButton(
      onPressed: enabled ? onPressed : null,
      expanded: true,
      color: enabled ? AppColors.leaf : AppColors.muted,
      foregroundColor: enabled ? Colors.white : AppColors.mutedForeground,
      child: const Text('ابدأ الامتحان'),
    );
  }
}
