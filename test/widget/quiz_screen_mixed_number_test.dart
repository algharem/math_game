import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/app/providers.dart';
import 'package:math_heroes/app/theme.dart';
import 'package:math_heroes/core/services/audio_service.dart';
import 'package:math_heroes/core/services/tts_service.dart';
import 'package:math_heroes/core/utils/mixed_number_generator.dart';
import 'package:math_heroes/features/quiz/quiz_screen.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';
import 'package:math_heroes/shared/models/question.dart';
import 'package:math_heroes/shared/models/quiz_launch_data.dart';
import 'package:math_heroes/shared/widgets/app_widgets.dart';
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
}
