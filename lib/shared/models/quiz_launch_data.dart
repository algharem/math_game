import 'exam_config.dart';
import 'question.dart';

class QuizLaunchData {
  const QuizLaunchData({
    required this.config,
    required this.questions,
  });

  final ExamConfig config;
  final List<Question> questions;
}
