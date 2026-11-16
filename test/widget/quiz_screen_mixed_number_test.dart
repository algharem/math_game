import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/app/providers.dart';
import 'package:math_heroes/app/theme.dart';
import 'package:math_heroes/core/services/audio_service.dart';
import 'package:math_heroes/core/services/tts_service.dart';
import 'package:math_heroes/core/utils/fraction_order_generator.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/features/quiz/quiz_screen.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';
import 'package:math_heroes/shared/models/question.dart';
import 'package:math_heroes/shared/models/quiz_launch_data.dart';
import 'package:math_heroes/shared/widgets/app_widgets.dart';
import 'package:math_heroes/widgets/fraction_order_widget.dart';
import 'package:math_heroes/widgets/fraction_story_widget.dart';
import 'package:math_heroes/widgets/mixed_number_widget.dart';

/// Avoids constructing plugin-backed services inside widget tests.
class _SilentAudioService implements AudioService {
  @override
  bool enabled = true;
  @override
  bool available = false;
  @override
  String? lastError;
  @override
  Future<void> initialize() async {}
  @override
  Future<void> play(SoundEffect effect, {double volume = 0.85}) async {}
  @override
  Future<void> dispose() async {}
}

class _SilentTtsService implements TtsService {
  @override
  bool initialized = false;
  @override
  bool available = false;
  @override
  bool enabled = true;
  @override
  double rate = 0.45;
  @override
  String? lastError;
  @override
  String? unavailableReason;
  @override
  Future<void> initialize({double speechRate = 0.45}) async {}
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
  @override
  Future<void> setRate(double value) async {}
  @override
  Future<void> dispose() async {}
}

Question _mixedQuestion() {
  final generated = MixedNumberGenerator(random: Random(7)).generateQuestion();
  return Question(
    id: 'mixed-1',
    kind: QuestionKind.mixedNumber,
    tokens: [generated.questionText],
    correctAnswer: generated.correctIndex,
    choices: List<int>.generate(generated.choices.length, (index) => index),
    explanation: generated.explanation,
    spokenText: generated.spokenText,
    topicId: 'g4_p2_t5',
    mixedNumber: generated,
  );
}

Question _storyQuestion() {
  final mixed = MixedNumberQuestion(
    num1: const MixedNumber(0, 2, 7),
    num2: const MixedNumber(0, 3, 7),
    operation: '+',
    choices: const [
      MixedNumber(0, 5, 7),
      MixedNumber(0, 4, 7),
      MixedNumber(0, 6, 7),
      MixedNumber(0, 1, 7),
    ],
    correctIndex: 0,
    questionText: 'أكل أحمد ٢/٧ من الكعكة، ثم أكل ٣/٧. كم أكل من الكعكة؟',
    explanation: 'نجمع البسطين: ٢ + ٣ = ٥.',
    spokenText: 'أكل أحمد ٢ على ٧ من الكعكة، ثم أكل ٣ على ٧.',
    story: const [
      FractionStoryText('أكل أحمد '),
      FractionStoryFraction(MixedNumber(0, 2, 7)),
      FractionStoryText(' من الكعكة، ثم أكل '),
      FractionStoryFraction(MixedNumber(0, 3, 7)),
      FractionStoryText('. كم أكل من الكعكة؟'),
    ],
  );
  return Question(
    id: 'story-1',
    kind: QuestionKind.wordProblem,
    tokens: [mixed.questionText],
    correctAnswer: mixed.correctIndex,
    choices: List<int>.generate(mixed.choices.length, (index) => index),
    explanation: mixed.explanation,
    spokenText: mixed.spokenText,
    topicId: 'g4_p2_t5',
    mixedNumber: mixed,
  );
}

Question _plainQuestion() {
  return const Question(
    id: 'plain-2',
    kind: QuestionKind.addition,
    tokens: [2, '+', 3, '=', null],
    correctAnswer: 5,
    choices: [5, 6, 7, 8],
    explanation: '٢ + ٣ = ٥',
  );
}

Question _orderQuestion() {
  const order = FractionOrderQuestion(
    fractions: [
      MixedNumber(0, 3, 7),
      MixedNumber(0, 1, 7),
      MixedNumber(0, 4, 7),
      MixedNumber(0, 2, 7),
    ],
    targetIndex: 0,
    questionText: 'رتّب الكسور تصاعديًا: ٣/٧، ١/٧، ٤/٧، ٢/٧ — ما ترتيب ٣/٧؟',
    explanation: 'الترتيب التصاعدي: ١/٧ < ٢/٧ < ٣/٧ < ٤/٧.',
    spokenText: 'رتّب الكسور تصاعديًا، ثم حدّد ترتيب ٣ على ٧.',
  );
  return const Question(
    id: 'order-1',
    kind: QuestionKind.fractionOps,
    tokens: ['رتّب الكسور تصاعديًا'],
    correctAnswer: 3,
    choices: [1, 2, 3, 4],
    explanation: 'الترتيب التصاعدي: ١/٧ < ٢/٧ < ٣/٧ < ٤/٧.',
    spokenText: 'رتّب الكسور تصاعديًا، ثم حدّد ترتيب ٣ على ٧.',
    topicId: 'g4_p2_t5',
    fractionOrder: order,
  );
}

void main() {
  testWidgets(
      'mixed-number question renders visually, selects, and advances even in typed mode',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'اختبار الكسور',
      questionCount: 2,
      answerMode: AnswerMode.typed,
      topicIds: const ['g4_p2_t5'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(_SilentAudioService()),
          ttsServiceProvider.overrideWithValue(_SilentTtsService()),
        ],
        child: MaterialApp(
          theme: AppTheme.build(highContrast: false, largeText: false),
          home: QuizScreen(
            launchData: QuizLaunchData(
              config: config,
              questions: [_mixedQuestion(), _plainQuestion()],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Prompt has two visual terms and the grid has four visual choices.
    expect(find.byType(MixedNumberExpression), findsOneWidget);
    expect(find.byType(MixedNumberWidget), findsNWidgets(6));
    expect(find.text('اختر الإجابة الصحيحة'), findsOneWidget);

    final confirm = find.widgetWithText(PressButton, 'تأكيد الإجابة');
    expect(confirm, findsOneWidget);
    expect(tester.widget<PressButton>(confirm).onPressed, isNull);

    // Tap the first generated choice (index 0 is the prompt's first term).
    final firstChoice = find.byType(MixedNumberWidget).at(2);
    await tester.ensureVisible(firstChoice);
    await tester.tap(firstChoice);
    await tester.pump();

    expect(tester.widget<PressButton>(confirm).onPressed, isNotNull,
        reason: 'selecting a choice must enable confirmation');

    await tester.tap(confirm);
    await tester.pumpAndSettle();

    // Advanced to the plain second question.
    expect(find.text('السؤال ٢ من ٢'), findsOneWidget);
    expect(find.byType(MixedNumberExpression), findsNothing);
    expect(find.byType(MixedNumberWidget), findsNothing);
  });

  testWidgets(
      'fraction-ordering question renders fractions and rank choices in typed mode',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'اختبار الكسور',
      questionCount: 2,
      answerMode: AnswerMode.typed,
      topicIds: const ['g4_p2_t5'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(_SilentAudioService()),
          ttsServiceProvider.overrideWithValue(_SilentTtsService()),
        ],
        child: MaterialApp(
          theme: AppTheme.build(highContrast: false, largeText: false),
          home: QuizScreen(
            launchData: QuizLaunchData(
              config: config,
              questions: [_orderQuestion(), _plainQuestion()],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FractionOrderPrompt), findsOneWidget);
    expect(find.text('رتّب تصاعديًا:'), findsOneWidget);
    // Four displayed fractions + the repeated highlighted target.
    expect(find.byType(MixedNumberWidget), findsNWidgets(5));

    final confirm = find.widgetWithText(PressButton, 'تأكيد الإجابة');
    expect(confirm, findsOneWidget);
    expect(tester.widget<PressButton>(confirm).onPressed, isNull);

    // The target 3/7 is third ascending, so ٣ is the correct rank.
    final rankChoice = find.descendant(
      of: find.byType(InkWell),
      matching: find.text('٣'),
    );
    expect(rankChoice, findsOneWidget);
    await tester.ensureVisible(rankChoice);
    await tester.tap(rankChoice);
    await tester.pump();

    expect(tester.widget<PressButton>(confirm).onPressed, isNotNull);

    await tester.tap(confirm);
    await tester.pumpAndSettle();

    expect(find.text('السؤال ٢ من ٢'), findsOneWidget);
    expect(find.byType(FractionOrderPrompt), findsNothing);
  });

  testWidgets(
      'fraction word problem shows the story and visual choices in typed mode',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final config = ExamConfig(
      section: MathSection.mixed,
      title: 'اختبار الكسور',
      questionCount: 2,
      answerMode: AnswerMode.typed,
      topicIds: const ['g4_p2_t5'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(_SilentAudioService()),
          ttsServiceProvider.overrideWithValue(_SilentTtsService()),
        ],
        child: MaterialApp(
          theme: AppTheme.build(highContrast: false, largeText: false),
          home: QuizScreen(
            launchData: QuizLaunchData(
              config: config,
              questions: [_storyQuestion(), _plainQuestion()],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FractionStoryPrompt), findsOneWidget);
    // A story prompt replaces the bare expression.
    expect(find.byType(MixedNumberExpression), findsNothing);
    expect(find.text('. كم أكل من الكعكة؟'), findsOneWidget);
    // Two inline story fractions + four visual choices.
    expect(find.byType(MixedNumberWidget), findsNWidgets(6));

    final confirm = find.widgetWithText(PressButton, 'تأكيد الإجابة');
    expect(confirm, findsOneWidget);
    expect(tester.widget<PressButton>(confirm).onPressed, isNull);

    // The first visual choice (after the two story fractions) is 5/7.
    final firstChoice = find.byType(MixedNumberWidget).at(2);
    await tester.ensureVisible(firstChoice);
    await tester.tap(firstChoice);
    await tester.pump();

    expect(tester.widget<PressButton>(confirm).onPressed, isNotNull);

    await tester.tap(confirm);
    await tester.pumpAndSettle();

    expect(find.text('السؤال ٢ من ٢'), findsOneWidget);
    expect(find.byType(FractionStoryPrompt), findsNothing);
  });
}
