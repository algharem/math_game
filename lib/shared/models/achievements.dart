import 'stats_models.dart';

class AchievementContext {
  const AchievementContext({
    required this.examsCount,
    required this.totalCorrect,
    required this.perfectExams,
    required this.divisionCorrect,
    required this.dailyStreak,
    required this.level,
    required this.totalStars,
    required this.gems,
    required this.tableMastery,
  });

  final int examsCount;
  final int totalCorrect;
  final int perfectExams;
  final int divisionCorrect;
  final int dailyStreak;
  final int level;
  final int totalStars;
  final int gems;
  final Map<int, TableMastery> tableMastery;
}

class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.condition,
    this.assetPath,
  });

  final String id;
  final String title;
  final String description;
  final bool Function(AchievementContext context) condition;
  final String? assetPath;
}

class AchievementState {
  const AchievementState({
    required this.definition,
    required this.unlocked,
    this.unlockedAt,
  });

  final AchievementDefinition definition;
  final bool unlocked;
  final DateTime? unlockedAt;
}

class AchievementEngine {
  AchievementEngine._();

  static final List<AchievementDefinition> all = [
    AchievementDefinition(
      id: 'first_exam',
      title: 'أول خطوة',
      description: 'أكمل أول اختبار لك.',
      assetPath: 'assets/images/badges/badge-first-star.png',
      condition: (context) => context.examsCount >= 1,
    ),
    AchievementDefinition(
      id: 'first_ten_correct',
      title: 'بداية قوية',
      description: 'أجب عن ١٠ أسئلة صحيحة.',
      condition: (context) => context.totalCorrect >= 10,
    ),
    AchievementDefinition(
      id: 'perfect_exam',
      title: 'دون أخطاء',
      description: 'أكمل اختبارًا كاملًا دون أي خطأ.',
      condition: (context) => context.perfectExams >= 1,
    ),
    AchievementDefinition(
      id: 'table_2_mastery',
      title: 'صديق جدول ٢',
      description: 'أتقن جدول الضرب في ٢.',
      condition: (context) => context.tableMastery[2]?.mastered == true,
    ),
    AchievementDefinition(
      id: 'table_5_mastery',
      title: 'نجم جدول ٥',
      description: 'أتقن جدول الضرب في ٥.',
      condition: (context) => context.tableMastery[5]?.mastered == true,
    ),
    AchievementDefinition(
      id: 'all_tables_mastery',
      title: 'سيد الجداول',
      description: 'أتقن جميع جداول الضرب من ١ إلى ١٢.',
      assetPath: 'assets/images/badges/badge-table-master.png',
      condition: (context) {
        for (var table = 1; table <= 12; table++) {
          if (context.tableMastery[table]?.mastered != true) return false;
        }
        return true;
      },
    ),
    AchievementDefinition(
      id: 'division_hero',
      title: 'بطل القسمة',
      description: 'أجب عن ٢٠ سؤال قسمة صحيحًا.',
      assetPath: 'assets/images/badges/badge-division-hero.png',
      condition: (context) => context.divisionCorrect >= 20,
    ),
    AchievementDefinition(
      id: 'ten_exams',
      title: 'مثابر',
      description: 'أكمل ١٠ اختبارات.',
      condition: (context) => context.examsCount >= 10,
    ),
    AchievementDefinition(
      id: 'daily_streak_3',
      title: 'شعلة الحماس',
      description: 'أكمل التحدي اليومي ٣ أيام متتالية.',
      assetPath: 'assets/images/badges/badge-streak.png',
      condition: (context) => context.dailyStreak >= 3,
    ),
    AchievementDefinition(
      id: 'daily_streak_7',
      title: 'أسبوع من الإبداع',
      description: 'أكمل التحدي اليومي ٧ أيام متتالية.',
      condition: (context) => context.dailyStreak >= 7,
    ),
    AchievementDefinition(
      id: 'level_3',
      title: 'بطل الحساب',
      description: 'اصل إلى المستوى ٣.',
      condition: (context) => context.level >= 3,
    ),
    AchievementDefinition(
      id: 'level_5',
      title: 'خبير الرياضيات',
      description: 'اصل إلى المستوى ٥.',
      condition: (context) => context.level >= 5,
    ),
    AchievementDefinition(
      id: 'star_collector',
      title: 'جامع النجوم',
      description: 'اجمع ٥٠ نجمة.',
      condition: (context) => context.totalStars >= 50,
    ),
    AchievementDefinition(
      id: 'gem_collector',
      title: 'كنز الجواهر',
      description: 'اجمع ١٠٠ جوهرة.',
      condition: (context) => context.gems >= 100,
    ),
  ];

  static List<String> newlyUnlocked(
    AchievementContext context,
    Set<String> alreadyUnlocked,
  ) {
    return all
        .where(
          (achievement) =>
              !alreadyUnlocked.contains(achievement.id) &&
              achievement.condition(context),
        )
        .map((achievement) => achievement.id)
        .toList(growable: false);
  }

  static List<AchievementState> states(
    AchievementContext context,
    Map<String, DateTime> unlockedAt,
  ) {
    return all
        .map(
          (achievement) => AchievementState(
            definition: achievement,
            unlocked: unlockedAt.containsKey(achievement.id),
            unlockedAt: unlockedAt[achievement.id],
          ),
        )
        .toList(growable: false);
  }
}
