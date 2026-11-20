import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/app/providers.dart';
import 'package:math_heroes/app/theme.dart';
import 'package:math_heroes/core/curriculum/grade04_p2_unit6_bank.dart';
import 'package:math_heroes/core/services/audio_service.dart';
import 'package:math_heroes/core/services/tts_service.dart';
import 'package:math_heroes/features/quiz/quiz_screen.dart';
import 'package:math_heroes/shared/models/enums.dart';
import 'package:math_heroes/shared/models/exam_config.dart';
import 'package:math_heroes/shared/models/question.dart';
import 'package:math_heroes/shared/models/quiz_launch_data.dart';

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

const _plainQuestion = Question(
  id: 'plain-1',
  kind: QuestionKind.addition,
  tokens: [2, '+', 3, '=', null],
  correctAnswer: 5,
  choices: [5, 6, 7, 8],
  explanation: '٢ + ٣ = ٥',
);

Future<void> _pumpQuiz(WidgetTester tester, Question question) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

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
            config: const ExamConfig(
              section: MathSection.mixed,
              title: 'اختبار الكسور العشرية',
              questionCount: 1,
              answerMode: AnswerMode.multipleChoice,
              topicIds: ['g4_p2_t11'],
            ),
            questions: [question, _plainQuestion],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('long word problems shrink the prompt so choices stay visible',
      (tester) async {
    final authored = Unit6QuestionBank.questions
        .firstWhere((question) => question.prompt.trim().length > 70)
        .toQuestion();

    await _pumpQuiz(tester, authored);

    final prompt = tester.widget<Text>(find.text(authored.promptText!));
    expect(
      prompt.style?.fontSize,
      lessThanOrEqualTo(24),
      reason: 'long prompts must not use the display size',
    );

    // Every choice of the question is still built and tappable.
    for (final label in authored.choiceTexts!) {
      expect(find.text(label), findsOneWidget, reason: 'missing choice $label');
    }
  });

  testWidgets('short prompts keep the large display size', (tester) async {
    await _pumpQuiz(tester, _plainQuestion);

    final prompt = tester.widget<Text>(find.text(_plainQuestion.displayPrompt));
    expect(prompt.style?.fontSize, greaterThanOrEqualTo(32));
  });
}
