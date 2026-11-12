import 'grade_05.dart';
import 'grade_curriculum.dart';

/// Lookup for per-grade curricula. Grades without an extracted syllabus
/// return null → the engine falls back to the existing heuristic caps.
class CurriculumRegistry {
  CurriculumRegistry._();

  static final Map<int, GradeCurriculum> _byGrade = _build();

  static Map<int, GradeCurriculum> _build() {
    return {
      5: grade05Curriculum,
    };
  }

  static GradeCurriculum? forGrade(int grade) {
    final capped = grade.clamp(1, 9).toInt();
    return _byGrade[capped];
  }

  static bool hasGrade(int grade) => forGrade(grade) != null;
}
