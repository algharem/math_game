import '../../shared/models/curriculum_topic.dart';

/// Curriculum map seed for grades 1–9 (see docs/curriculum_upgrade_plan.md).
/// Ids follow the `g{grade}_p{part}_t{n}` convention.
/// Every book topic is exam-able — the map itself (not book pages) is the
/// source of truth for generation. `generationReady` defaults to true and
/// can be flipped false to park a topic behind a «قريباً» badge.
const List<CurriculumTopic> curriculumTopicSeed = [
  // ───── GRADE 1 ─────
  CurriculumTopic(
    id: 'g1_p1_t1',
    grade: 1,
    part: 1,
    title: 'الأعداد من (0) إلى (9) — كتابة، قراءة، ومقارنة',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p1_t2',
    grade: 1,
    part: 1,
    title: 'الترتيب التصاعدي والتنازلي للأعداد حتى 9',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p1_t3',
    grade: 1,
    part: 1,
    title: 'الجمع ضمن العدد 9 (مفهوم الجمع وجداول الجمع البسيطة)',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p1_t4',
    grade: 1,
    part: 1,
    title: 'الطرح ضمن العدد 9 (مفهوم الطرح والعمليات العكسية)',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p2_t1',
    grade: 1,
    part: 2,
    title: 'الأعداد من (10) إلى (99) — العشرات والقيمة المنزلية',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p2_t2',
    grade: 1,
    part: 2,
    title: 'مقارنة الأعداد (أكبر من >، أصغر من <، يساوي =)',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p2_t3',
    grade: 1,
    part: 2,
    title: 'الجمع والطرح حتى 99 دون إعادة التجميع',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p2_t4',
    grade: 1,
    part: 2,
    title: 'الجمع والطرح حتى 99 مع إعادة التجميع البسيطة',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g1_p2_t5',
    grade: 1,
    part: 2,
    title: 'الأشكال الهندسية المستوية (المربع، المستطيل، الدائرة، المثلث)',
    unitName: 'الهندسة',
  ),
  // ───── GRADE 2 ─────
  CurriculumTopic(
    id: 'g2_p1_t1',
    grade: 2,
    part: 1,
    title: 'الأعداد حتى 999 — المئات والقيمة المنزلية',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g2_p1_t2',
    grade: 2,
    part: 1,
    title: 'قراءة، كتابة، ومقارنة الأعداد ضمن 3 أرقام',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g2_p1_t3',
    grade: 2,
    part: 1,
    title: 'الجمع حتى 999 مع إعادة التجميع (الحمل)',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g2_p1_t4',
    grade: 2,
    part: 1,
    title: 'الطرح حتى 999 مع الاستلاف وإعادة التجميع',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g2_p2_t1',
    grade: 2,
    part: 2,
    title: 'مفهوم الضرب كجمع متكرر (جداول الضرب 2، 3، 4، 5)',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g2_p2_t2',
    grade: 2,
    part: 2,
    title: 'مفهوم القسمة كمشاركة متساوية وطرح متكرر',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g2_p2_t3',
    grade: 2,
    part: 2,
    title: 'وحدات القياس البسيطة (الطول بالسنتيمتر، الوقت بالساعات)',
    unitName: 'القياس',
  ),
  CurriculumTopic(
    id: 'g2_p2_t4',
    grade: 2,
    part: 2,
    title: 'المجسمات الهندسية (المكعب، الكرة، الأسطوانة، المخروط)',
    unitName: 'الهندسة',
  ),
  // ───── GRADE 3 ─────
  CurriculumTopic(
    id: 'g3_p1_t1',
    grade: 3,
    part: 1,
    title: 'الأعداد ضمن الآلاف (1000 إلى 9999) والقيمة المنزلية',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g3_p1_t2',
    grade: 3,
    part: 1,
    title: 'الجمع والطرح للأعداد ضمن 4 أرقام',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g3_p1_t3',
    grade: 3,
    part: 1,
    title: 'جداول الضرب الكاملة (1×1 حتى 10×10) وخصائص الضرب',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g3_p1_t4',
    grade: 3,
    part: 1,
    title: 'حقائق القسمة والعلاقة بين الضرب والقسمة',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g3_p2_t1',
    grade: 3,
    part: 2,
    title: 'تطبيقات الضرب والقسمة وحل المسائل الكلامية',
    unitName: 'العمليات',
  ),
  CurriculumTopic(
    id: 'g3_p2_t2',
    grade: 3,
    part: 2,
    title: 'مفهوم الكسور البسيطة (النصف، الثلث، الربع)',
    unitName: 'الكسور',
  ),
  CurriculumTopic(
    id: 'g3_p2_t3',
    grade: 3,
    part: 2,
    title: 'تمثيل الكسور بالأشكال والتلوين والكسور المتكافئة',
    unitName: 'الكسور',
  ),
  CurriculumTopic(
    id: 'g3_p2_t4',
    grade: 3,
    part: 2,
    title: 'جمع وطرح الكسور ذات المقامات المتساوية وترتيبها',
    unitName: 'الكسور',
  ),
  // ───── GRADE 4 ─────
  CurriculumTopic(
    id: 'g4_p1_t1',
    grade: 4,
    part: 1,
    title: 'الأعداد الكبيرة وقراءتها حتى ملايين والقيمة المنزلية',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g4_p1_t2',
    grade: 4,
    part: 1,
    title: 'الجمع والطرح للأعداد الكبيرة مع إعادة التجميع',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g4_p1_t3',
    grade: 4,
    part: 1,
    title: 'التقدير والتقريب لأقرب مئة وألف',
    unitName: 'الأعداد',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g4_p2_t1',
    grade: 4,
    part: 2,
    title: 'الضرب في عدد من رقمين أو ثلاثة أرقام',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g4_p2_t2',
    grade: 4,
    part: 2,
    title: 'القسمة المطولة على عدد من رقم واحد أو رقمين',
    unitName: 'العمليات',
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g4_p2_t3',
    grade: 4,
    part: 2,
    title: 'الهندسة الأساسية (الزوايا، المتوازي والمتعامد، المضلعات)',
    unitName: 'الهندسة',
  ),
  CurriculumTopic(
    id: 'g4_p2_t4',
    grade: 4,
    part: 2,
    title: 'وحدات القياس (الطول، الكتلة، السعة، الزمن وتحويلاتها)',
    unitName: 'القياس',
  ),
  CurriculumTopic(
    id: 'g4_p2_t5',
    grade: 4,
    part: 2,
    title: 'الكسور العادية (الجمع والطرح وترتيب الكسور والمسائل الكلامية)',
    unitName: 'الكسور',
    generationReady: true,
  ),
  // ───── GRADE 5 ─────
  CurriculumTopic(
    id: 'g5_p1_t1',
    grade: 5,
    part: 1,
    title: 'نظرية الأعداد (القواسم، المضاعفات، الأولية)',
    unitName: 'المجموعات والعدد',
    pageReference: 78,
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g5_p1_t2',
    grade: 5,
    part: 1,
    title: 'القاسم المشترك الأكبر (ق.م.أ) والمضاعف المشترك الأصغر (م.م.أ)',
    unitName: 'المجموعات والعدد',
    pageReference: 82,
    generationReady: true,
  ),
  CurriculumTopic(
    id: 'g5_p1_t3',
    grade: 5,
    part: 1,
    title: 'الكسور الاعتيادية (توحيد المقامات، الجمع والطرح)',
    unitName: 'الكسور',
  ),
  CurriculumTopic(
    id: 'g5_p2_t1',
    grade: 5,
    part: 2,
    title: 'ضرب وقسمة الكسور الاعتيادية والأعداد الكسرية',
    unitName: 'الكسور',
    pageReference: 33,
  ),
  CurriculumTopic(
    id: 'g5_p2_t2',
    grade: 5,
    part: 2,
    title: 'الكسور العشرية (القيمة المنزلية والعمليات)',
    unitName: 'الأعداد العشرية',
  ),
  CurriculumTopic(
    id: 'g5_p2_t3',
    grade: 5,
    part: 2,
    title: 'النسبة والتناسب والنسبة المئوية',
    unitName: 'النسبة',
  ),
  CurriculumTopic(
    id: 'g5_p2_t4',
    grade: 5,
    part: 2,
    title: 'الهندسة والقياس (محيط ومساحة المربع والمستطيل والمثلث)',
    unitName: 'الهندسة والقياس',
    generationReady: true,
  ),
  // ───── GRADE 6 ─────
  CurriculumTopic(
      id: 'g6_p1_t1',
      grade: 6,
      part: 1,
      title: 'العمليات المتقدمة على الكسور والكسور العشرية',
      unitName: 'الكسور'),
  CurriculumTopic(
      id: 'g6_p1_t2',
      grade: 6,
      part: 1,
      title: 'النسبة والمعدل ومعدل الوحدة',
      unitName: 'النسبة'),
  CurriculumTopic(
      id: 'g6_p1_t3',
      grade: 6,
      part: 1,
      title: 'التناسب الطردي والعكسي وتطبيقات المسائل',
      unitName: 'النسبة'),
  CurriculumTopic(
      id: 'g6_p2_t1',
      grade: 6,
      part: 2,
      title: 'النسبة المئوية وتطبيقاتها التجارية (الربح، الخصم، الزكاة)',
      unitName: 'النسبة'),
  CurriculumTopic(
      id: 'g6_p2_t2',
      grade: 6,
      part: 2,
      title: 'الهندسة (محيط ومساحة الدائرة وقيمة π)',
      unitName: 'الهندسة والقياس'),
  CurriculumTopic(
      id: 'g6_p2_t3',
      grade: 6,
      part: 2,
      title: 'حجوم الأشكال ثلاثية الأبعاد (المكعب، متوازي المستطيلات)',
      unitName: 'الهندسة والقياس',
      generationReady: true),
  CurriculumTopic(
      id: 'g6_p2_t4',
      grade: 6,
      part: 2,
      title: 'الإحصاء (القطاعات الدائرية والجداول التكرارية)',
      unitName: 'الإحصاء'),
  // ───── GRADE 7 ─────
  CurriculumTopic(
      id: 'g7_p1_t1',
      grade: 7,
      part: 1,
      title: 'الأعداد الصحيحة (الموجبة والسالبة، القيمة المطلقة)',
      unitName: 'الاعداد',
      generationReady: true),
  CurriculumTopic(
      id: 'g7_p1_t2',
      grade: 7,
      part: 1,
      title: 'الجمع والطرح للأعداد الصحيحة وقواعد الإشارات',
      unitName: 'الاعداد',
      generationReady: true),
  CurriculumTopic(
      id: 'g7_p1_t3',
      grade: 7,
      part: 1,
      title: 'الضرب والقسمة للأعداد الصحيحة',
      unitName: 'الاعداد',
      generationReady: true),
  CurriculumTopic(
      id: 'g7_p1_t4',
      grade: 7,
      part: 1,
      title: 'الحدوديات والمقادير الجبرية البسيطة والتعويض',
      unitName: 'الجبر',
      generationReady: true),
  CurriculumTopic(
      id: 'g7_p2_t1',
      grade: 7,
      part: 2,
      title: 'حل المعادلات الخطية من الدرجة الأولى بمتغير واحد',
      unitName: 'الجبر',
      generationReady: true),
  CurriculumTopic(
      id: 'g7_p2_t2',
      grade: 7,
      part: 2,
      title: 'الهندسة (الزوايا المتكاملة والمتباعدة، مجموع زوايا المثلث)',
      unitName: 'الهندسة'),
  CurriculumTopic(
      id: 'g7_p2_t3',
      grade: 7,
      part: 2,
      title: 'تطابق المثلثات وحالات التطابق',
      unitName: 'الهندسة'),
  CurriculumTopic(
      id: 'g7_p2_t4',
      grade: 7,
      part: 2,
      title: 'الإحصاء والاحتمالات (الوسط الحسابي، الوسيط، المنوال)',
      unitName: 'الإحصاء'),
  // ───── GRADE 8 ─────
  CurriculumTopic(
      id: 'g8_p1_t1',
      grade: 8,
      part: 1,
      title: 'الأعداد الحقيقية (الجذور التربيعية والتكعيبية)',
      unitName: 'الاعداد',
      generationReady: true),
  CurriculumTopic(
      id: 'g8_p1_t2',
      grade: 8,
      part: 1,
      title: 'العمليات على الأعداد الحقيقية وتبسيط الجذور',
      unitName: 'الاعداد'),
  CurriculumTopic(
      id: 'g8_p1_t3',
      grade: 8,
      part: 1,
      title: 'ضرب المقادير الجبرية والتحليل بالعامل المشترك',
      unitName: 'الجبر'),
  CurriculumTopic(
      id: 'g8_p2_t1',
      grade: 8,
      part: 2,
      title: 'الهندسة التحليلية ونظرية فيثاغورس',
      unitName: 'الهندسة',
      generationReady: true),
  CurriculumTopic(
      id: 'g8_p2_t2',
      grade: 8,
      part: 2,
      title: 'تشابه المضلعات ونسب التشابه',
      unitName: 'الهندسة'),
  CurriculumTopic(
      id: 'g8_p2_t3',
      grade: 8,
      part: 2,
      title: 'هندسة الدائرة (الزوايا المركزية والمحيطية)',
      unitName: 'الهندسة'),
  CurriculumTopic(
      id: 'g8_p2_t4',
      grade: 8,
      part: 2,
      title: 'مقاييس التشتت والإحصاء',
      unitName: 'الإحصاء'),
  // ───── GRADE 9 ─────
  CurriculumTopic(
      id: 'g9_p1_t1',
      grade: 9,
      part: 1,
      title: 'تحليل المقادير الجبرية (الفرق بين مربعين والمكعبات)',
      unitName: 'الجبر'),
  CurriculumTopic(
      id: 'g9_p1_t2',
      grade: 9,
      part: 1,
      title: 'الكسور الجبرية والعمليات عليها',
      unitName: 'الجبر'),
  CurriculumTopic(
      id: 'g9_p1_t3',
      grade: 9,
      part: 1,
      title: 'حل أنظمة المعادلات الخطية بمتغيرين',
      unitName: 'الجبر',
      generationReady: true),
  CurriculumTopic(
      id: 'g9_p1_t4',
      grade: 9,
      part: 1,
      title: 'حل المعادلة التربيعية بمتغير واحد',
      unitName: 'الجبر',
      generationReady: true),
  CurriculumTopic(
      id: 'g9_p2_t1',
      grade: 9,
      part: 2,
      title: 'حساب المثلثات (النسب المثلثية وتطبيقاتها)',
      unitName: 'حساب المثلثات'),
  CurriculumTopic(
      id: 'g9_p2_t2',
      grade: 9,
      part: 2,
      title: 'مبرهنات الدائرة المتقدمة (المماس، الرباعي الدائري)',
      unitName: 'الهندسة'),
  CurriculumTopic(
      id: 'g9_p2_t3',
      grade: 9,
      part: 2,
      title: 'الإحصاء المتقدم ومقاييس النزعة والتشتت',
      unitName: 'الإحصاء'),
];

/// Map of topic id → all seed entries, ordered stable (by id).
Map<String, CurriculumTopic> buildTopicIndex(
  List<CurriculumTopic> topics,
) {
  return {
    for (final topic in topics) topic.id: topic,
  };
}

List<CurriculumTopic> topicsFor(
  List<CurriculumTopic> topics, {
  required int grade,
  required int part,
}) {
  return topics
      .where((topic) => topic.grade == grade && topic.part == part)
      .toList(growable: false);
}

List<CurriculumTopic> readyTopicsFor(
  List<CurriculumTopic> topics, {
  required int grade,
  required int part,
}) {
  return topicsFor(topics, grade: grade, part: part)
      .where((topic) => topic.generationReady)
      .toList(growable: false);
}

/// True when any selected topic can generate questions.
bool anyTopicReady(
  Map<String, CurriculumTopic> index,
  List<String> selectedTopicIds,
) {
  return selectedTopicIds.any((id) => index[id]?.generationReady ?? false);
}
