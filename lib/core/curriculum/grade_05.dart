import 'grade_curriculum.dart';

/// Grade 5 — Yemeni MoE math, parts 1+2 (`source_pdfs/grade_05`).
/// Extracted visually from both TOCs (2026-11-08); see
/// docs/curriculum_upgrade_plan.md for the source page log.
///
/// Units follow book order. Arithmetic caps reflect the book:
/// units 1–5 practice add/sub to millions, 3-digit × 1/2-digit
/// multiplication, and division by 1/2-digit divisors.
const GradeCurriculum grade05Curriculum = GradeCurriculum(
  grade: 5,
  bookLabel: 'كتاب الرياضيات — الصف الخامس (الجزء ١ و ٢)',
  units: [
    CurriculumUnit(
      number: 1,
      title: 'الأعداد ضمن مئات الملايين',
      lessons: [
        CurriculumLesson(id: '1-1', title: 'قراءة وكتابة الأعداد', page: 10),
        CurriculumLesson(
            id: '1-2', title: 'منازل الأعداد (ورقة المنازل)', page: 14),
        CurriculumLesson(id: '1-3', title: 'المقارنة والترتيب', page: 18),
        CurriculumLesson(
            id: '1-4', title: 'التقريب إلى أقرب عشرة/مئة/ألف', page: 22),
        CurriculumLesson(id: '1-5', title: 'جمع الأعداد', page: 26),
        CurriculumLesson(id: '1-6', title: 'طرح الأعداد', page: 30),
      ],
      skills: [
        CurriculumSkill.numberWords,
        CurriculumSkill.placeValue,
        CurriculumSkill.expandedForm,
        CurriculumSkill.compareNumbers,
        CurriculumSkill.rounding,
        CurriculumSkill.addition,
        CurriculumSkill.subtraction,
      ],
    ),
    CurriculumUnit(
      number: 2,
      title: 'الجمع والطرح المركّبان',
      lessons: [
        CurriculumLesson(id: '2-1', title: 'الجمع المركب', page: 38),
        CurriculumLesson(id: '2-2', title: 'الطرح المركب', page: 44),
        CurriculumLesson(id: '2-3', title: 'مسائل تطبيقية', page: 50),
      ],
      skills: [CurriculumSkill.twoStep],
    ),
    CurriculumUnit(
      number: 3,
      title: 'الضرب',
      lessons: [
        CurriculumLesson(
            id: '3-1', title: 'خصائص الضرب (التبادل والتجميع)', page: 58),
        CurriculumLesson(
            id: '3-2', title: 'الضرب على مضاعفات ١٠ و١٠٠ و١٠٠٠', page: 62),
        CurriculumLesson(id: '3-3', title: 'تقدير ناتج الضرب', page: 66),
        CurriculumLesson(id: '3-4', title: 'ضرب عدد من ٣ خانات', page: 70),
        CurriculumLesson(id: '3-5', title: 'مسائل تطبيقية', page: 76),
      ],
      skills: [CurriculumSkill.multiplication],
    ),
    CurriculumUnit(
      number: 4,
      title: 'القسمة',
      lessons: [
        CurriculumLesson(
            id: '4-1', title: 'القسمة على عدد من خانة واحدة', page: 84),
        CurriculumLesson(id: '4-2', title: 'القسمة على مضاعفات ١٠', page: 88),
        CurriculumLesson(id: '4-3', title: 'تقدير ناتج القسمة', page: 92),
        CurriculumLesson(
            id: '4-4', title: 'القسمة على عدد من خانتين', page: 96),
        CurriculumLesson(id: '4-5', title: 'مسائل تطبيقية', page: 100),
      ],
      skills: [CurriculumSkill.division],
    ),
    CurriculumUnit(
      number: 5,
      title: 'الكسور',
      lessons: [
        CurriculumLesson(id: '5-1', title: 'الأعداد الكسرية', page: 12),
        CurriculumLesson(id: '5-2', title: 'الكسور المتساوية', page: 16),
        CurriculumLesson(id: '5-3', title: 'جمع الكسور', page: 19),
        CurriculumLesson(id: '5-4', title: 'طرح الكسور', page: 24),
        CurriculumLesson(id: '5-5', title: 'تدريبات ومسائل', page: 29),
        CurriculumLesson(id: '5-6', title: 'ضرب الكسور', page: 33),
        CurriculumLesson(id: '5-7', title: 'قسمة الكسور', page: 38),
        CurriculumLesson(id: '5-8', title: 'تدريبات وتمارين', page: 43),
        CurriculumLesson(id: '5-9', title: 'مسائل تطبيقية', page: 47),
      ],
      skills: [], // Fraction operations arrive in a later pass.
    ),
    CurriculumUnit(
      number: 6,
      title: 'الأعداد الاعشرية',
      lessons: [
        CurriculumLesson(id: '6-1', title: 'قراءة وكتابة الأعداد الاعشرية'),
        CurriculumLesson(id: '6-2', title: 'مقارنة والترتيب'),
        CurriculumLesson(id: '6-3', title: 'التقريب'),
        CurriculumLesson(id: '6-4', title: 'الجمع والطرح'),
        CurriculumLesson(id: '6-5', title: 'الضرب'),
        CurriculumLesson(id: '6-6', title: 'القسمة'),
        CurriculumLesson(
            id: '6-7', title: 'التحويل بين الكسور العشرية والاعشار'),
      ],
      skills: [CurriculumSkill.compareNumbers, CurriculumSkill.rounding],
    ),
    CurriculumUnit(
      number: 7,
      title: 'الهندسة والقياس',
      lessons: [
        CurriculumLesson(id: '7-1', title: 'قياس الزوايا'),
        CurriculumLesson(id: '7-2', title: 'متوازي الأضلاع'),
        CurriculumLesson(id: '7-3', title: 'المساحة'),
      ],
      skills: [],
    ),
    CurriculumUnit(
      number: 8,
      title: 'رسم الأشكال',
      lessons: [
        CurriculumLesson(id: '8-1', title: 'رسم القطعة المستقيمة والزاوية'),
        CurriculumLesson(id: '8-2', title: 'رسم المثلث والمتوازي الأضلاع'),
      ],
      skills: [],
    ),
    CurriculumUnit(
      number: 9,
      title: 'الهندسة والقياس (٢)',
      lessons: [
        CurriculumLesson(id: '9-1', title: 'الأشكال المجسمة والانتقالات'),
      ],
      skills: [],
    ),
    CurriculumUnit(
      number: 10,
      title: 'الإحصاء والاحتمالات',
      lessons: [
        CurriculumLesson(
            id: '10-1', title: 'قراءة الجداول والتمثيلات البيانية'),
      ],
      skills: [],
    ),
  ],
  earlyRanges: GradeRanges(
    // Start of the year: consolidation of grade 4 skills.
    addition: SkillRange(min: 1, max: 100),
    subtraction: SkillRange(min: 1, max: 100),
    multiplicationFirst: SkillRange(min: 1, max: 12),
    multiplicationSecond: SkillRange(min: 1, max: 12),
    division: SkillRange(min: 2, max: 12),
    placeValueMax: 10000,
    numberWordsMax: 9999,
    compareMax: 9999,
    roundingMax: 9999,
    expandedMax: 9999,
    roundingPlaces: [10, 100],
  ),
  lateRanges: GradeRanges(
    // End of year, aligned with book caps.
    addition: SkillRange(min: 1, max: 999999),
    subtraction: SkillRange(min: 1, max: 999999),
    multiplicationFirst: SkillRange(min: 2, max: 999),
    multiplicationSecond: SkillRange(min: 2, max: 99),
    division: SkillRange(min: 2, max: 99),
    placeValueMax: 999999999,
    numberWordsMax: 99999999,
    compareMax: 9999999,
    roundingMax: 9999999,
    expandedMax: 999999,
    roundingPlaces: [10, 100, 1000],
  ),
);
