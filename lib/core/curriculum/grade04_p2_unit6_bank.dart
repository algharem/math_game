import '../../shared/models/enums.dart';
import '../../shared/models/question.dart';

/// One textbook-verified authored question for Grade 4, Part 2, Unit 6.
///
/// The fields mirror the data requested for the bank: unique id, grade/part,
/// unit, lesson, sub-skill, 1–100 difficulty, Arabic prompt, type, choices,
/// correct answer, worked explanation, printed page and verification status.
/// Answers are stored as indices into [choices] so decimal values such as
/// `١٫٢٥` survive the app's integer-based answer engine; the shared widgets
/// render [choices] through [Question.choiceText].
class AuthoredUnit6Question {
  const AuthoredUnit6Question({
    required this.id,
    required this.topicId,
    required this.lessonName,
    required this.skill,
    required this.difficultyRank,
    required this.questionTypeLabel,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    required this.sourcePage,
    this.verificationStatus = Unit6QuestionBank.verifiedStatus,
  });

  final String id;
  final String topicId;
  final String lessonName;
  final String skill;
  final int difficultyRank;
  final String questionTypeLabel;
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final int sourcePage;
  final String verificationStatus;

  QuestionKind get kind {
    switch (questionTypeLabel) {
      case 'صح وخطأ':
        return QuestionKind.shapeFacts;
      case 'مقارنة وترتيب':
        return QuestionKind.compareNumbers;
      case 'قراءة وكتابة':
        return QuestionKind.numberWords;
      case 'مسألة لفظية':
        return QuestionKind.wordProblem;
      default:
        return QuestionKind.fractionOps;
    }
  }

  String get correctAnswer => choices[correctIndex];

  Question toQuestion() {
    final indices = List<int>.generate(choices.length, (index) => index);
    return Question(
      id: id,
      kind: kind,
      tokens: [prompt],
      correctAnswer: correctIndex,
      choices: indices,
      explanation: explanation,
      spokenText: prompt,
      topicId: topicId,
      topicLabel: 'الوحدة السادسة: الكسور العشرية • $lessonName — $skill',
      promptText: prompt,
      correctAnswerText: correctAnswer,
      choiceTexts: choices,
      difficultyRank: difficultyRank,
      sourcePage: sourcePage,
      verificationStatus: verificationStatus,
      lessonName: lessonName,
      skill: skill,
      questionTypeLabel: questionTypeLabel,
      factKey: id,
    );
  }
}

/// Static, fully verified question bank for Unit 6 «الكسور العشرية».
///
/// Source: `source_pdfs/grade_04/g04_math_p2__1oA8lfPyUp3enLnknwriMCx_7bxEFo_pW.pdf`
/// (Yemeni Ministry of Education, Grade 4 Part 2). Printed pages ٤١–٧٢
/// correspond to PDF pages ٥٥–٨٦. Lesson order and page numbers come from
/// the book's table of contents and the page headers, not from estimates.
class Unit6QuestionBank {
  Unit6QuestionBank._();

  static const String verifiedStatus =
      'موثّق من الكتاب المطبوع لوزارة التربية والتعليم اليمنية';

  /// Lesson ids in textbook order, starting with the three titles confirmed
  /// at the start of the unit.
  static const List<String> lessonIds = [
    'g4_p2_t6',
    'g4_p2_t7',
    'g4_p2_t8',
    'g4_p2_t9',
    'g4_p2_t10',
    'g4_p2_t11',
    'g4_p2_t12',
    'g4_p2_t13',
    'g4_p2_t14',
  ];

  static const String unitName = 'الوحدة السادسة: الكسور العشرية';

  static const Map<String, String> lessonNames = {
    'g4_p2_t6': 'الأجزاء من عشرة',
    'g4_p2_t7': 'الأجزاء من مائة',
    'g4_p2_t8': 'الأعداد الكسرية في صورة كسور عشرية',
    'g4_p2_t9': 'مقارنة وترتيب الكسور العشرية',
    'g4_p2_t10': 'جمع الكسور العشرية',
    'g4_p2_t11': 'طرح الكسور العشرية',
    'g4_p2_t12': 'تدريبات ومسائل على الجمع والطرح',
    'g4_p2_t13': 'مسائل تطبيقية',
    'g4_p2_t14': 'اختبار الوحدة',
  };

  static const List<AuthoredUnit6Question> questions = [
    // ── ١. الأجزاء من عشرة (ص ٤١–٤٢) ───────────────────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_b01',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'تحديد قيمة جزء من عشرة',
      difficultyRank: 10,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'أي كسر عشري يمثل جزءاً واحداً من عشرة؟',
      choices: ['٠٫١', '٠٫٠١', '١٫٠', '٠٫٩'],
      correctIndex: 0,
      explanation: 'نقسم الوحدة إلى ١٠ أجزاء متساوية، فيكون الجزء الواحد ١/١٠. '
          'نكتب ١/١٠ على صورة كسر عشري ٠٫١، وتسمى النقطة فاصلة عشرية.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_b02',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'القيمة المنزلية للأجزاء من عشرة',
      difficultyRank: 18,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'ما قيمة الرقم ٤ في الكسر العشري ٠٫٤؟',
      choices: ['٤ أجزاء من عشرة', '٤ أحاد', '٤ أجزاء من مائة', '٤ عشرات'],
      correctIndex: 0,
      explanation:
          'الرقم الذي يأتي مباشرة بعد الفاصلة العشرية يقع في منزلة الأجزاء من عشرة. '
          'إذن ٤ في ٠٫٤ تعني ٤ أجزاء من عشرة.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_b03',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'كتابة الأجزاء من عشرة بالأرقام',
      difficultyRank: 22,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب بالأرقام: ثلاثة من عشرة.',
      choices: ['٠٫٣', '٠٫٠٣', '٣٫٠', '٣٠'],
      correctIndex: 0,
      explanation: 'ثلاثة من عشرة تعني ٣ أجزاء من أصل ١٠ أجزاء، أي ٣/١٠. '
          'نكتبها كسراً عشرياً ٠٫٣.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_b04',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'قراءة الكسر العشري',
      difficultyRank: 27,
      questionTypeLabel: 'صح وخطأ',
      prompt: 'الكسر العشري ٠٫٧ يُقرأ: سبعة من عشرة.',
      choices: ['صحيح', 'خطأ'],
      correctIndex: 0,
      explanation: 'الرقم ٧ بعد الفاصلة العشرية يدل على ٧ أجزاء من عشرة، '
          'لذلك تُقرأ ٠٫٧: سبعة من عشرة. العبارة صحيحة.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_m01',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'تحديد الأجزاء الملونة',
      difficultyRank: 40,
      questionTypeLabel: 'اختيار متعدد',
      prompt:
          'شكل مقسم إلى ١٠ أجزاء متساوية، لُوّن منه ٦ أجزاء. ما الكسر العشري الذي يمثل الجزء الملون؟',
      choices: ['٠٫٦', '٠٫٠٦', '٦٫٠', '٠٫٥'],
      correctIndex: 0,
      explanation: 'الجزء الملون ٦ من ١٠، أي ٦/١٠. '
          'نكتب ٦/١٠ ككسر عشري ٠٫٦.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_m02',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'تحويل الكسر العادي إلى كسر عشري',
      difficultyRank: 48,
      questionTypeLabel: 'تحويل',
      prompt: 'اكتب الكسر ٨/١٠ في صورة كسر عشري.',
      choices: ['٠٫٨', '٠٫٠٨', '٨٫٠', '٠٫٧'],
      correctIndex: 0,
      explanation: 'مقام الكسر ١٠، لذلك يكون البسط في منزلة الأجزاء من عشرة. '
          '٨/١٠ = ٠٫٨.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_m03',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'ربط عشرة أجزاء بالوحدة الكاملة',
      difficultyRank: 56,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'ما الكسر العشري الذي يمثل ١٠ أجزاء من عشرة؟',
      choices: ['١٫٠', '٠٫١', '٠٫٠١', '١٠٫٠'],
      correctIndex: 0,
      explanation: '١٠/١٠ = ١ وحدة كاملة. '
          'نكتب الوحدة الكاملة مع صفر في منزلة الأجزاء من عشرة: ١٫٠.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_m04',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'القيمة المنزلية',
      difficultyRank: 63,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'في العدد ٠٫٩، في أي منزلة يقع الرقم ٩؟',
      choices: ['الأجزاء من عشرة', 'الأحاد', 'الأجزاء من مائة', 'العشرات'],
      correctIndex: 0,
      explanation: 'أول رقم بعد الفاصلة العشرية هو منزلة الأجزاء من عشرة، '
          'ويليه الأجزاء من مائة.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_h01',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'جمع أجزاء ملونة وقراءتها',
      difficultyRank: 75,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'لوّن سامي ٣ أجزاء من شكل مقسم إلى ١٠ أجزاء بالأزرق، ثم لوّن جزأين آخرين بالأخضر. ما الكسر العشري للجزء الملون كله؟',
      choices: ['٠٫٥', '٠٫٣', '٠٫٢', '٠٫٣٢'],
      correctIndex: 0,
      explanation: 'نجمع الأجزاء الملونة: ٣ + ٢ = ٥ أجزاء من ١٠. '
          'إذن الكسر ٥/١٠، وكسره العشري ٠٫٥.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_h02',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'إكمال عدد ناقص',
      difficultyRank: 82,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٠٫٦ = ___ من عشرة.',
      choices: ['٦', '٦٠', '٠٫٦', '١٠'],
      correctIndex: 0,
      explanation: 'الرقم ٦ بعد الفاصلة العشرية يعني ٦ أجزاء من عشرة. '
          'إذن ٠٫٦ = ٦ من عشرة.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_h03',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'تطبيق الأجزاء من عشرة على الطول',
      difficultyRank: 88,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'شريط طوله ١ متر قُسّم إلى ١٠ أجزاء متساوية. استخدم منها ٤ أجزاء. ما طول ما استخدمه ككسر عشري من المتر؟',
      choices: ['٠٫٤', '٠٫٠٤', '٤٫٠', '٠٫٦'],
      correctIndex: 0,
      explanation: 'كل جزء من الشريط يساوي ١/١٠ من المتر. '
          '٤ أجزاء تساوي ٤/١٠ = ٠٫٤ من المتر.',
      sourcePage: 41,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t6_h04',
      topicId: 'g4_p2_t6',
      lessonName: 'الأجزاء من عشرة',
      skill: 'تفسير الأجزاء المتبقية',
      difficultyRank: 94,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'شكل مقسم إلى ١٠ أجزاء متساوية. لوّن تلميذ جزأين، ثم لوّن ٥ أجزاء أخرى. كم جزءاً بقي دون تلوين، وما كسره العشري؟',
      choices: [
        '٣ أجزاء، ٠٫٣',
        '٧ أجزاء، ٠٫٧',
        '٥ أجزاء، ٠٫٥',
        '٣ أجزاء، ٠٫٠٣'
      ],
      correctIndex: 0,
      explanation: 'المجموع الملون ٢ + ٥ = ٧ أجزاء. '
          'المتبقي ١٠ - ٧ = ٣ أجزاء، أي ٣/١٠ = ٠٫٣.',
      sourcePage: 42,
    ),

    // ── ٢. الأجزاء من مائة (ص ٤٢–٤٣) ───────────────────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_b01',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'علاقة السنتيمتر بالمتر',
      difficultyRank: 12,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'السنتيمتر الواحد يساوي كم جزءاً من المتر؟',
      choices: [
        '١/١٠٠ من المتر',
        '١/١٠ من المتر',
        '١/١٠٠٠ من المتر',
        '١٠/١٠ من المتر'
      ],
      correctIndex: 0,
      explanation:
          'المتر ١٠٠ سنتيمتر، لذلك السنتيمتر جزء واحد من ١٠٠ جزء من المتر، أي ١/١٠٠.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_b02',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'كتابة الأجزاء من مائة',
      difficultyRank: 20,
      questionTypeLabel: 'تحويل',
      prompt: 'كيف نكتب ١/١٠٠ على صورة كسر عشري؟',
      choices: ['٠٫٠١', '٠٫١', '١٫٠٠', '٠٫٠٠١'],
      correctIndex: 0,
      explanation:
          'مقام الكسر ١٠٠، فيكون الرقم ١ في منزلة الأجزاء من مائة: ٠٫٠١، ويُقرأ واحداً من مائة.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_b03',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'القيمة المنزلية للأجزاء من مائة',
      difficultyRank: 25,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'ما قيمة الرقم ٥ في الكسر العشري ٠٫٠٥؟',
      choices: [
        '٥ أجزاء من مائة',
        '٥ أجزاء من عشرة',
        '٥ أحاد',
        '٥٠ جزءاً من مائة'
      ],
      correctIndex: 0,
      explanation:
          'الرقم الثاني بعد الفاصلة العشرية يقع في منزلة الأجزاء من مائة، إذن ٥ تعني ٥ أجزاء من مائة.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_b04',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'قراءة الكسر العشري',
      difficultyRank: 28,
      questionTypeLabel: 'صح وخطأ',
      prompt: 'يُقرأ الكسر العشري ٠٫٠١: واحداً من مائة.',
      choices: ['صحيح', 'خطأ'],
      correctIndex: 0,
      explanation:
          'الرقم ١ في منزلة الأجزاء من مائة، لذلك نقرأ ٠٫٠١: واحداً من مائة. العبارة صحيحة.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_m01',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'تحديد الأجزاء الملونة من مائة',
      difficultyRank: 42,
      questionTypeLabel: 'اختيار متعدد',
      prompt:
          'مربع كبير مقسم إلى ١٠٠ مربع صغير، لُوّن ١٨ مربعاً منه. ما الكسر العشري للجزء الملون؟',
      choices: ['٠٫١٨', '٠٫٠١٨', '٠٫٨١', '١٨٫٠'],
      correctIndex: 0,
      explanation: 'الجزء الملون ١٨ من ١٠٠، أي ١٨/١٠٠. '
          'نكتبه ٠٫١٨، ويُقرأ ثمانية عشر من مائة.',
      sourcePage: 43,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_m02',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'كتابة الأجزاء من مائة بالأرقام',
      difficultyRank: 50,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب بالأرقام: ستة من مائة.',
      choices: ['٠٫٠٦', '٠٫٦', '٠٫٠٠٦', '٦٫٠'],
      correctIndex: 0,
      explanation: 'ستة من مائة تعني ٦/١٠٠. '
          'نضع ٦ في منزلة الأجزاء من مائة فتصبح ٠٫٠٦.',
      sourcePage: 43,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_m03',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'تحويل الكسر إلى كسر عشري',
      difficultyRank: 58,
      questionTypeLabel: 'تحويل',
      prompt: 'اكتب الكسر ٦٥/١٠٠ في صورة كسر عشري.',
      choices: ['٠٫٦٥', '٠٫٠٦٥', '٦٫٥', '٠٫٥٦'],
      correctIndex: 0,
      explanation:
          'بما أن المقام ١٠٠، نضع الرقمين ٦ و٥ بعد الفاصلة العشرية: ٠٫٦٥.',
      sourcePage: 43,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_m04',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'ربط الكسر العشري بالسنتيمتر',
      difficultyRank: 64,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'كم سنتيمتراً يساوي ٠٫٠٧ من المتر؟',
      choices: ['٧ سنتيمترات', '٧٠ سنتيمتراً', '٠٫٧ سنتيمتر', '٧ أمتار'],
      correctIndex: 0,
      explanation: 'كل سنتيمتر يساوي ٠٫٠١ من المتر. '
          'إذن ٠٫٠٧ من المتر = ٧ أجزاء من مائة = ٧ سنتيمترات.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_h01',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'تطبيق على طول المتر',
      difficultyRank: 76,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'متر مقسّم إلى ١٠٠ سنتيمتر. استخدم منها ٣٥ سنتيمتراً. ما الكسر العشري لما استخدمته من المتر؟',
      choices: ['٠٫٣٥', '٠٫٠٣٥', '٣٫٥', '٠٫٥٣'],
      correctIndex: 0,
      explanation: '٣٥ سنتيمتراً = ٣٥/١٠٠ من المتر. '
          'نكتبها ٠٫٣٥.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_h02',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'إكمال كسر عشري',
      difficultyRank: 84,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٠٫٠٩ = ___/١٠٠.',
      choices: ['٩', '٩٠', '٠٫٠٩', '١٠٠'],
      correctIndex: 0,
      explanation: 'الرقم ٩ في منزلة الأجزاء من مائة يعني ٩ أجزاء من ١٠٠، '
          'أي ٩/١٠٠ = ٠٫٠٩.',
      sourcePage: 42,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_h03',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'جمع أجزاء ملونة من مائة',
      difficultyRank: 90,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'شكل من ١٠٠ مربع صغير، لُوّن ٢٤ مربعاً بالأحمر و١٦ مربعاً بالأصفر. ما الكسر العشري للجزء الملون كله؟',
      choices: ['٠٫٤٠', '٠٫٠٤', '٠٫٤٤', '٤٠٫٠'],
      correctIndex: 0,
      explanation: 'الملون ٢٤ + ١٦ = ٤٠ مربعاً من ١٠٠. '
          'إذن الكسر ٤٠/١٠٠، وكسره العشري ٠٫٤٠ (يساوي ٠٫٤).',
      sourcePage: 43,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t7_h04',
      topicId: 'g4_p2_t7',
      lessonName: 'الأجزاء من مائة',
      skill: 'إيجاد المتبقي من المتر',
      difficultyRank: 96,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'من متر قماش طوله ١٠٠ سنتيمتر، أخذت سيدة ٢٥ سنتيمتراً ثم ٣٠ سنتيمتراً. كم سنتيمتراً بقي، وما كسره العشري من المتر؟',
      choices: [
        '٤٥ سنتيمتراً، ٠٫٤٥',
        '٤٥ سنتيمتراً، ٠٫٠٤٥',
        '٥٥ سنتيمتراً، ٠٫٥٥',
        '٤٥ سنتيمتراً، ٤٫٥'
      ],
      correctIndex: 0,
      explanation: 'المستخدم ٢٥ + ٣٠ = ٥٥ سنتيمتراً. '
          'المتبقي ١٠٠ - ٥٥ = ٤٥ سنتيمتراً، أي ٤٥/١٠٠ = ٠٫٤٥ من المتر.',
      sourcePage: 43,
    ),

    // ── ٣. الأعداد الكسرية في صورة كسور عشرية (ص ٤٤–٤٨) ───────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_b01',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'كتابة عدد كسري ككسر عشري',
      difficultyRank: 12,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب بالأرقام: واحد صحيح وثلاثة من عشرة.',
      choices: ['١٫٣', '١٫٠٣', '١٣٫٠', '٠٫١٣'],
      correctIndex: 0,
      explanation:
          'الوحدة الكاملة تكتب قبل الفاصلة، و٣ أجزاء من عشرة بعدها: ١٫٣.',
      sourcePage: 44,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_b02',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'قراءة الكسر العشري',
      difficultyRank: 20,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'كيف يُقرأ الكسر العشري ١٫٢٥؟',
      choices: [
        'واحد صحيح وخمسة وعشرون من مائة',
        'واحد صحيح واثنان وخمسون من مائة',
        'واحد وعشرون وخمسة من عشرة',
        'اثنا عشر وخمسة من مائة',
      ],
      correctIndex: 0,
      explanation: 'ما قبل الفاصلة وحدة كاملة، وبعدها ٢٥ جزءاً من مائة. '
          'لذلك نقرأ ١٫٢٥: واحد صحيح وخمسة وعشرون من مائة.',
      sourcePage: 45,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_b03',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'تحليل العدد الكسري',
      difficultyRank: 26,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'يتكوّن العدد ٢٫٧ من وحدتين و...',
      choices: ['٧ أجزاء من عشرة', '٧ أجزاء من مائة', '٧ عشرات', '٧ وحدات'],
      correctIndex: 0,
      explanation:
          'الرقم ٧ مباشرة بعد الفاصلة العشرية يقع في منزلة الأجزاء من عشرة.',
      sourcePage: 44,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_b04',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'قراءة الأعداد الكسرية',
      difficultyRank: 29,
      questionTypeLabel: 'صح وخطأ',
      prompt: '١٫٠٤ = واحد صحيح وأربعة من مائة.',
      choices: ['صحيح', 'خطأ'],
      correctIndex: 0,
      explanation:
          'الصفر في منزلة الأجزاء من عشرة، والرقم ٤ في منزلة الأجزاء من مائة. '
          'إذن ١٫٠٤ = واحد صحيح وأربعة من مائة.',
      sourcePage: 45,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_m01',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'تحويل عدد كسري إلى كسر عشري',
      difficultyRank: 40,
      questionTypeLabel: 'تحويل',
      prompt: 'اكتب ٣ و٤/١٠ في صورة كسر عشري.',
      choices: ['٣٫٤', '٣٫٠٤', '٣٤٫٠', '٠٫٣٤'],
      correctIndex: 0,
      explanation: 'الوحدات ٣ قبل الفاصلة، و٤ أجزاء من عشرة بعدها: ٣٫٤.',
      sourcePage: 45,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_m02',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'تحويل عدد كسري إلى كسر عشري',
      difficultyRank: 48,
      questionTypeLabel: 'تحويل',
      prompt: 'اكتب ١٧ و٣٥/١٠٠ في صورة كسر عشري.',
      choices: ['١٧٫٣٥', '١٧٫٠٣٥', '١٧٣٥٫٠', '١٧٫٥٣'],
      correctIndex: 0,
      explanation: 'نضع ١٧ قبل الفاصلة، ثم ٣٥ بعدها لأن المقام ١٠٠: ١٧٫٣٥.',
      sourcePage: 45,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_m03',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'تحويل الكسر العشري إلى كسر عادي',
      difficultyRank: 56,
      questionTypeLabel: 'تحويل',
      prompt: 'حوّل ٤٫٠٦ إلى عدد كسري مكتوب ككسر عادي.',
      choices: ['٤ و٦/١٠٠', '٤ و٦/١٠', '٤٦/١٠', '٤ و٦٠/١٠٠'],
      correctIndex: 0,
      explanation: 'قبل الفاصلة ٤ وحدات، وبعدها ٦ في منزلة الأجزاء من مائة. '
          'إذن ٤٫٠٦ = ٤ و٦/١٠٠.',
      sourcePage: 47,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_m04',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'إكمال عدد كسري',
      difficultyRank: 62,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٥٫٢ = ٥ و___ من عشرة.',
      choices: ['٢', '٢٠', '٥', '١٠'],
      correctIndex: 0,
      explanation: 'الرقم ٢ بعد الفاصلة في منزلة الأجزاء من عشرة، '
          'لذلك ٥٫٢ = ٥ و٢ من عشرة.',
      sourcePage: 44,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_h01',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'تطبيق على القياس',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'ارتفاع طفل ١ متر و٢٤ سنتيمتراً. اكتب ارتفاعه ككسر عشري من المتر.',
      choices: ['١٫٢٤', '١٫٠٢٤', '١٢٫٤', '١٫٤٢'],
      correctIndex: 0,
      explanation: 'المتر وحدة كاملة، و٢٤ سنتيمتراً = ٢٤/١٠٠ من المتر. '
          'إذن الارتفاع ١٫٢٤ متر.',
      sourcePage: 45,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_h02',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'القراءة بالكلمات',
      difficultyRank: 82,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب ١٢٫٥ بالكلمات، ثم اختر قراءتها الصحيحة.',
      choices: [
        'اثنا عشر وخمسة من عشرة',
        'واحد واثنان وخمسة من مائة',
        'اثنا عشر وخمسة من مائة',
        'مائة واثنان وخمسة من عشرة',
      ],
      correctIndex: 0,
      explanation: 'قبل الفاصلة ١٢ وحدة، وبعدها ٥ أجزاء من عشرة. '
          'تُقرأ ١٢٫٥: اثنا عشر وخمسة من عشرة.',
      sourcePage: 45,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_h03',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'القيمة المنزلية في عدد كسري',
      difficultyRank: 88,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'في العدد ٣٫٤٧، ما الفرق بين قيمة الرقم ٤ وقيمة الرقم ٧؟',
      choices: ['٠٫٣٣', '٠٫٣', '٣٣', '٠٫٠٣٣'],
      correctIndex: 0,
      explanation: 'الرقم ٤ في منزلة الأجزاء من عشرة قيمته ٠٫٤، '
          'والرقم ٧ في منزلة الأجزاء من مائة قيمته ٠٫٠٧. '
          'الفرق ٠٫٤ - ٠٫٠٧ = ٠٫٣٣.',
      sourcePage: 47,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t8_h04',
      topicId: 'g4_p2_t8',
      lessonName: 'الأعداد الكسرية في صورة كسور عشرية',
      skill: 'ربط الوحدات بالسنتيمترات',
      difficultyRank: 95,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'لدى سيدة ٢ متر و٥ سنتيمترات من القماش. عبرّي عن الطول ككسر عشري من المتر، ثم اذكري قراءته.',
      choices: [
        '٢٫٠٥ — متران وخمسة من مائة',
        '٢٫٥ — متران وخمسة من عشرة',
        '٢٫٠٠٥ — متران وخمسة من ألف',
        '٢٥٫٠ — خمسة وعشرون متراً',
      ],
      correctIndex: 0,
      explanation: '٥ سنتيمترات = ٥/١٠٠ من المتر، فتكتب ٠٫٠٥. '
          'الطول ٢٫٠٥ متر، ويُقرأ متران وخمسة من مائة.',
      sourcePage: 45,
    ),

    // ── ٤. مقارنة وترتيب الكسور العشرية (ص ٤٩–٥٥) ─────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_b01',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'مقارنة أجزاء من عشرة',
      difficultyRank: 12,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'أي الكسرين أكبر: ٠٫٧ أم ٠٫٤؟',
      choices: ['٠٫٧', '٠٫٤', 'متساويان', 'لا يمكن مقارنتهما'],
      correctIndex: 0,
      explanation: 'نقارن الأجزاء من عشرة: ٧ أكبر من ٤، إذن ٠٫٧ أكبر من ٠٫٤.',
      sourcePage: 50,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_b02',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'الأصفار على يمين الكسر العشري',
      difficultyRank: 20,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'ضع الرمز المناسب في الفراغ: ٠٫٥ ◻ ٠٫٥٠',
      choices: ['=', '>', '<', '≠'],
      correctIndex: 0,
      explanation: 'إضافة صفر إلى يمين الكسر العشري لا تغير قيمته. '
          '٠٫٥ = ٠٫٥٠ لأن كليهما خمسة أجزاء من عشرة.',
      sourcePage: 50,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_b03',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'تساوي الكسور العشرية',
      difficultyRank: 26,
      questionTypeLabel: 'صح وخطأ',
      prompt: '٠٫٣ = ٠٫٣٠. هل العبارة صحيحة؟',
      choices: ['صحيح', 'خطأ'],
      correctIndex: 0,
      explanation: '٠٫٣ تعني ٣ أجزاء من عشرة، و٠٫٣٠ تعني ٣٠ جزءاً من مائة، '
          'وهما نفس القيمة. العبارة صحيحة.',
      sourcePage: 50,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_b04',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'مقارنة أجزاء من مائة',
      difficultyRank: 29,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'أي العددين أصغر: ٠٫٠٩ أم ٠٫١؟',
      choices: ['٠٫٠٩', '٠٫١', 'متساويان', 'لا يمكن مقارنتهما'],
      correctIndex: 0,
      explanation: 'نكتب ٠٫١ على صورة ٠٫١٠ حتى تتساوى المنازل. '
          'نقارن الأجزاء من مائة: ٩ < ١٠، إذن ٠٫٠٩ أصغر.',
      sourcePage: 51,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_m01',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'مقارنة عددين كسريين',
      difficultyRank: 40,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'قارن بين ١٫٥ و١٫٥٤، واختر الإجابة الصحيحة.',
      choices: ['١٫٥٤ أكبر', '١٫٥ أكبر', 'متساويان', '١٫٥٤ أصغر'],
      correctIndex: 0,
      explanation:
          'نكتب ١٫٥ = ١٫٥٠. الآحاد متساوية والأجزاء من عشرة متساوية (٥). '
          'نقارن الأجزاء من مائة: ٤ > ٠، إذن ١٫٥٤ أكبر.',
      sourcePage: 51,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_m02',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'الترتيب التصاعدي',
      difficultyRank: 48,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'رتّب تصاعدياً: ٠٫٦، ٠٫٥٦، ٠٫٦٥.',
      choices: [
        '٠٫٥٦، ٠٫٦، ٠٫٦٥',
        '٠٫٦، ٠٫٥٦، ٠٫٦٥',
        '٠٫٦٥، ٠٫٦، ٠٫٥٦',
        '٠٫٥٦، ٠٫٦٥، ٠٫٦',
      ],
      correctIndex: 0,
      explanation: 'نكتب ٠٫٦ = ٠٫٦٠. الأجزاء من عشرة: ٥ ثم ٦ ثم ٦، '
          'وبين الأخيرين ٦٠ < ٦٥. الترتيب: ٠٫٥٦، ٠٫٦، ٠٫٦٥.',
      sourcePage: 52,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_m03',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'الترتيب التنازلي',
      difficultyRank: 56,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'رتّب تنازلياً: ١٫٠٨، ١٫٨، ١٫٥.',
      choices: [
        '١٫٨، ١٫٥، ١٫٠٨',
        '١٫٠٨، ١٫٥، ١٫٨',
        '١٫٥، ١٫٨، ١٫٠٨',
        '١٫٨، ١٫٠٨، ١٫٥',
      ],
      correctIndex: 0,
      explanation: 'الوحدات متساوية. نقارن الأجزاء من عشرة: ٨ > ٥ > ٠. '
          'التنازلي: ١٫٨، ١٫٥، ١٫٠٨.',
      sourcePage: 53,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_m04',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'تبرير التساوي',
      difficultyRank: 64,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'لماذا يتساوى ٢٫٣ مع ٢٫٣٠؟',
      choices: [
        'لأن إضافة صفر بعد آخر رقم لا يغير القيمة',
        'لأن ٣٠أكبر من ٣',
        'لأن الفاصلة تحركت',
        'لأن الوحدات اختلفت',
      ],
      correctIndex: 0,
      explanation: 'الصفر المضاف في آخر منزلة عشرية لا يضيف أي قيمة، '
          'لذلك ٢٫٣ = ٢٫٣٠.',
      sourcePage: 50,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_h01',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'مقارنة في مسألة لفظية',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'كتابان: وزن الأول ٠٫٧٥ كيلو جرام، ووزن الثاني ٠٫٨ كيلو جرام. أيّ الكتابين أخف؟',
      choices: [
        'الكتاب الأول',
        'الكتاب الثاني',
        'متساويان',
        'لا يمكن تحديد ذلك'
      ],
      correctIndex: 0,
      explanation: 'نكتب ٠٫٨ = ٠٫٨٠. نقارن الأجزاء من عشرة: ٧ < ٨. '
          'إذن ٠٫٧٥ < ٠٫٨، والكتاب الأول أخف.',
      sourcePage: 55,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_h02',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'إكمال رمز مقارنة برقم ناقص',
      difficultyRank: 82,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٠٫٤٥ < ٠٫٤◻. ما الرقم الناقص؟',
      choices: ['٦', '٤', '٣', '٠'],
      correctIndex: 0,
      explanation: 'الأجزاء من عشرة متساوية (٤)، فنقارن الأجزاء من مائة. '
          'أصغر رقم يجعل ٠٫٤◻ أكبر من ٠٫٤٥ هو ٦، لأن ٦ > ٥.',
      sourcePage: 54,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_h03',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'ترتيب مبني على بيانات جدول',
      difficultyRank: 88,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt:
          'أطوال ثلاثة تلاميذ: ١٫٢ متر، ١٫٠٩ متر، ١٫١٥ متر. رتّب الأطوال تنازلياً.',
      choices: [
        '١٫٢، ١٫١٥، ١٫٠٩',
        '١٫٠٩، ١٫١٥، ١٫٢',
        '١٫١٥، ١٫٢، ١٫٠٩',
        '١٫٢، ١٫٠٩، ١٫١٥',
      ],
      correctIndex: 0,
      explanation: 'الوحدات متساوية. الأجزاء من عشرة: ٢، ١، ١. '
          'ثم نقارن ١٫١٥ و١٫٠٩ في الأجزاء من مائة: ٥ > ٠. '
          'التنازلي: ١٫٢، ١٫١٥، ١٫٠٩.',
      sourcePage: 55,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t9_h04',
      topicId: 'g4_p2_t9',
      lessonName: 'مقارنة وترتيب الكسور العشرية',
      skill: 'ترتيب مع أصفار نهاية',
      difficultyRank: 96,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'رتّب تنازلياً: ٠٫٩، ٠٫٨٩، ٠٫٩٠، ٠٫٨٨.',
      choices: [
        '٠٫٩، ٠٫٩٠، ٠٫٨٩، ٠٫٨٨',
        '٠٫٩٠، ٠٫٨٩، ٠٫٩، ٠٫٨٨',
        '٠٫٨٨، ٠٫٨٩، ٠٫٩، ٠٫٩٠',
        '٠٫٩، ٠٫٨٨، ٠٫٨٩، ٠٫٩٠',
      ],
      correctIndex: 0,
      explanation:
          '٠٫٩ = ٠٫٩٠، وكلاهما أكبر من ٠٫٨٩ لأن ٩ أجزاء من عشرة أكبر من ٨. '
          'ثم ٠٫٨٩ > ٠٫٨٨. التنازلي: ٠٫٩، ٠٫٩٠، ٠٫٨٩، ٠٫٨٨.',
      sourcePage: 54,
    ),

    // ── ٥. جمع الكسور العشرية (ص ٥٦–٥٩) ───────────────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_b01',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع أجزاء من عشرة',
      difficultyRank: 12,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ٠٫٣ + ٠٫٤ =',
      choices: ['٠٫٧', '١٫٧', '٠٫١', '٠٫٣٤'],
      correctIndex: 0,
      explanation:
          'نضع الفاصلتين تحت بعضهما، ثم نجمع ٣ + ٤ = ٧ أجزاء من عشرة: ٠٫٧.',
      sourcePage: 56,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_b02',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع عددين كسريين',
      difficultyRank: 20,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ١٫٢ + ٢٫٥ =',
      choices: ['٣٫٧', '٣٫١٧', '٣٫٧٧', '٢٫٧'],
      correctIndex: 0,
      explanation: 'الأحاد ١ + ٢ = ٣، والأجزاء من عشرة ٢ + ٥ = ٧. '
          'الناتج ٣٫٧.',
      sourcePage: 56,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_b03',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع أجزاء من مائة',
      difficultyRank: 26,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ٠٫٠٥ + ٠٫٠٣ =',
      choices: ['٠٫٠٨', '٠٫٨', '٠٫٠٥٣', '٠٫٠٢'],
      correctIndex: 0,
      explanation:
          '٥ أجزاء من مائة + ٣ أجزاء من مائة = ٨ أجزاء من مائة، أي ٠٫٠٨.',
      sourcePage: 56,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_b04',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'خطوة محاذاة الفواصل',
      difficultyRank: 29,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'عند جمع كسرين عشريين نكتبهما رأسياً بحيث تقع...',
      choices: [
        'الفاصلتان العشريتان تحت بعضهما',
        'أكبر رقم في الأعلى',
        'الأرقام من اليسار',
        'الفاصلة في نهاية العدد',
      ],
      correctIndex: 0,
      explanation:
          'محاذاة الفاصلتين تضمن محاذاة كل منزلة مع مثيلتها قبل بدء الجمع من اليمين.',
      sourcePage: 56,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_m01',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع بمنازل مختلفة',
      difficultyRank: 40,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ١٫٤٦ + ٢٫٣ =',
      choices: ['٣٫٧٦', '٣٫٤٩', '٣٫٧٧', '٣٫٦٦'],
      correctIndex: 0,
      explanation: 'نكتب ٢٫٣ = ٢٫٣٠. الأجزاء من مائة ٦ + ٠ = ٦، '
          'الأجزاء من عشرة ٤ + ٣ = ٧، والأحاد ١ + ٢ = ٣. الناتج ٣٫٧٦.',
      sourcePage: 57,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_m02',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'الجمع مع الحمل',
      difficultyRank: 48,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ٠٫٨ + ٠٫٧ =',
      choices: ['١٫٥', '٠٫١٥', '١٫٥٥', '٠٫٨٧'],
      correctIndex: 0,
      explanation:
          '٨ أجزاء من عشرة + ٧ أجزاء من عشرة = ١٥ جزءاً = وحدة و٥ أجزاء من عشرة، أي ١٫٥.',
      sourcePage: 57,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_m03',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'مسألة جمع لفظية',
      difficultyRank: 56,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'اشترى أحمد ١٫٥ كيلو جرام من العنب، ووضعه في صندوق يزن وهو فارغ ٠٫٤ كيلو جرام. ما الوزن الكلي؟',
      choices: [
        '١٫٩ كيلو جرام',
        '١٫٥٤ كيلو جرام',
        '١٫١ كيلو جرام',
        '١٩٫٠ كيلو جرام'
      ],
      correctIndex: 0,
      explanation:
          'الوزن الكلي = وزن العنب + وزن الصندوق = ١٫٥ + ٠٫٤ = ١٫٩ كيلو جرام.',
      sourcePage: 59,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_m04',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع عدد صحيح وكسر عشري',
      difficultyRank: 64,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ٣٫٠٧ + ١٫٨ =',
      choices: ['٤٫٨٧', '٤٫١٥', '٣٫٨٧', '٥٫٨٧'],
      correctIndex: 0,
      explanation:
          'نكتب ١٫٨ = ١٫٨٠. ٧ + ٠ = ٧، ٠ + ٨ = ٨، ٣ + ١ = ٤. الناتج ٤٫٨٧.',
      sourcePage: 57,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_h01',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'مسألة جمع متعددة الخطوات',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'قطعتا قماش طول الأولى ٢٫٤ متر والثانية ٣٫٨٥ متر. ما مجموع طول القطعتين؟',
      choices: ['٦٫٢٥ متر', '٦٫٣٥ متر', '٥٫٢٥ متر', '٦٫٢٤ متر'],
      correctIndex: 0,
      explanation: 'نكتب ٢٫٤ = ٢٫٤٠. الأجزاء من مائة ٠ + ٥ = ٥، '
          'من عشرة ٤ + ٨ = ١٢ نكتب ٢ ونحمل ١، '
          'الأحاد ٢ + ٣ + ١ = ٦. الناتج ٦٫٢٥ متر.',
      sourcePage: 59,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_h02',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'إيجاد الطرف الناقص',
      difficultyRank: 82,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٠٫٦ + ___ = ١٫٢.',
      choices: ['٠٫٦', '١٫٢', '١٫٨', '٠٫٠٦'],
      correctIndex: 0,
      explanation: 'العدد الناقص = ١٫٢ - ٠٫٦ = ٠٫٦. '
          'للتحقق: ٠٫٦ + ٠٫٦ = ١٫٢.',
      sourcePage: 59,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_h03',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع ثلاثة أعداد كسرية',
      difficultyRank: 88,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'باع تاجر ٣٫٥ كيلو جرام من الأرز في اليوم الأول، و٤٫٢٥ في الثاني، و٢٫٧٥ في الثالث. كم كيلو جراماً باع في الأيام الثلاثة؟',
      choices: [
        '١٠٫٥ كيلو جرام',
        '١٠٫٥٥ كيلو جرام',
        '٩٫٥ كيلو جرام',
        '١٠٫٦ كيلو جرام'
      ],
      correctIndex: 0,
      explanation:
          '٣٫٥ + ٤٫٢٥ = ٧٫٧٥، ثم ٧٫٧٥ + ٢٫٧٥ = ١٠٫٥٠ = ١٠٫٥ كيلو جرام.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t10_h04',
      topicId: 'g4_p2_t10',
      lessonName: 'جمع الكسور العشرية',
      skill: 'جمع عدد صحيح وكسرين',
      difficultyRank: 95,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اجمع: ٥ + ٠٫٧٥ + ٢٫٤ =',
      choices: ['٨٫١٥', '٨٫١٦', '٧٫١٥', '٨٫٢٥'],
      correctIndex: 0,
      explanation: 'نكتب الأعداد بمنازل متساوية: ٥٫٠٠ + ٠٫٧٥ + ٢٫٤٠. '
          'الأجزاء من مائة ٧٥، ومن عشرة ٤ + ٧ = ١١ نكتب ١ ونحمل ١، '
          'الأحاد ٥ + ٠ + ٢ + ١ = ٨. الناتج ٨٫١٥.',
      sourcePage: 57,
    ),

    // ── ٦. طرح الكسور العشرية (ص ٦٠–٦٣) ───────────────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_b01',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'طرح أجزاء من عشرة',
      difficultyRank: 12,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اطرح: ٠٫٩ - ٠٫٤ =',
      choices: ['٠٫٥', '٠٫٥٥', '٠٫١٣', '٠٫٩٤'],
      correctIndex: 0,
      explanation: 'نحاذي الفاصلتين، ثم ٩ - ٤ = ٥ أجزاء من عشرة: ٠٫٥.',
      sourcePage: 60,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_b02',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'طرح عددين كسريين',
      difficultyRank: 20,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اطرح: ٢٫٨ - ١٫٣ =',
      choices: ['١٫٥', '١٫٥٥', '١٫٤', '٢٫٨٣'],
      correctIndex: 0,
      explanation: 'الأجزاء من عشرة ٨ - ٣ = ٥، والأحاد ٢ - ١ = ١. الناتج ١٫٥.',
      sourcePage: 60,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_b03',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'طرح أجزاء من مائة',
      difficultyRank: 26,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اطرح: ٠٫٠٩ - ٠٫٠٣ =',
      choices: ['٠٫٠٦', '٠٫٦', '٠٫٠٩٣', '٠٫٠٣'],
      correctIndex: 0,
      explanation:
          '٩ أجزاء من مائة - ٣ أجزاء من مائة = ٦ أجزاء من مائة، أي ٠٫٠٦.',
      sourcePage: 60,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_b04',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'التحقق من ناتج الطرح',
      difficultyRank: 29,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'للتحقق من صحة ناتج الطرح نستخدم...',
      choices: ['العملية العكسية وهي الجمع', 'الضرب', 'القسمة', 'المقارنة فقط'],
      correctIndex: 0,
      explanation:
          'نجمع الناتج مع المطروح؛ فإذا حصلنا على المطروح منه كان الجواب صحيحاً.',
      sourcePage: 61,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_m01',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'الطرح مع الاستلاف',
      difficultyRank: 40,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اطرح: ٣٫٥ - ١٫٧ =',
      choices: ['١٫٨', '١٫٨٨', '٢٫٨', '١٫٧'],
      correctIndex: 0,
      explanation: 'لا يمكن طرح ٧ من ٥، فنستلف من الأحاد: ١٥ - ٧ = ٨، '
          'ويبقى ٢ - ١ = ١. الناتج ١٫٨.',
      sourcePage: 61,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_m02',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'طرح بمنازل مختلفة',
      difficultyRank: 48,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'اطرح: ٥٫٠٦ - ٢٫٣ =',
      choices: ['٢٫٧٦', '٢٫٧٧', '٢٫٧٦٦', '٣٫٧٦'],
      correctIndex: 0,
      explanation: 'نكتب ٢٫٣ = ٢٫٣٠. في الأجزاء من مائة: ٦ - ٠ = ٦. '
          'في الأجزاء من عشرة: ٠ - ٣ نستلف من الأحاد فتصبح ١٠ - ٣ = ٧. '
          'في الأحاد: ٤ - ٢ = ٢. الناتج ٢٫٧٦.',
      sourcePage: 61,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_m03',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'مسألة طرح لفظية',
      difficultyRank: 56,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'قطعة قماش طولها ٥٫٢٥ متر، استخدم منها ٢٫٧٥ متر. كم بقي من القماش؟',
      choices: ['٢٫٥٠ متر', '٢٫٠٥ متر', '٢٫٥٥ متر', '٣٫٥ متر'],
      correctIndex: 0,
      explanation: '٥٫٢٥ - ٢٫٧٥ = ٢٫٥٠ متر، أي ٢٫٥ متر. '
          'للتحقق: ٢٫٥٠ + ٢٫٧٥ = ٥٫٢٥.',
      sourcePage: 63,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_m04',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'طرح من عدد صحيح',
      difficultyRank: 64,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد الفرق: ١٠ - ٣٫٤ =',
      choices: ['٦٫٦', '٦٫٦٦', '٧٫٦', '٦٫٣٤'],
      correctIndex: 0,
      explanation: 'نكتب ١٠ = ١٠٫٠. نستلف: ١٠ - ٤ = ٦ في الأجزاء من عشرة، '
          'ويبقى ٩ - ٣ = ٦ في الأحاد. الناتج ٦٫٦.',
      sourcePage: 61,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_h01',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'مسألة طرح لفظية',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'وزن محمد ٤٥٫٧ كيلو جرام، ووزن علي ٣٩٫٨ كيلو جرام. ما الفرق بين وزنيهما؟',
      choices: [
        '٥٫٩ كيلو جرام',
        '٥٫٩٥ كيلو جرام',
        '٦٫٩ كيلو جرام',
        '٥٫٨ كيلو جرام'
      ],
      correctIndex: 0,
      explanation: 'الأجزاء من عشرة: ٧ - ٨ نستلف من الأحاد فتصبح ١٧ - ٨ = ٩. '
          'الأحاد: ٤ - ٩ نستلف من العشرات فتصبح ١٤ - ٩ = ٥. '
          'العشرات: ٣ - ٣ = ٠. الناتج ٥٫٩ كيلو جرام، '
          'وللتحقق: ٣٩٫٨ + ٥٫٩ = ٤٥٫٧.',
      sourcePage: 63,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_h02',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'إيجاد المطروح الناقص',
      difficultyRank: 82,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٨٫٤ - ___ = ٣٫٩.',
      choices: ['٤٫٥', '٤٫٥٥', '٥٫٤', '٤٫٤'],
      correctIndex: 0,
      explanation: 'العدد الناقص = ٨٫٤ - ٣٫٩ = ٤٫٥. '
          'للتحقق: ٨٫٤ - ٤٫٥ = ٣٫٩.',
      sourcePage: 63,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_h03',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'طرح متتالٍ في مسألة',
      difficultyRank: 88,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'سلك كهرباء طوله ٤٫١٠ متر. استخدم كهربائي ١٫٨٥ متر، ثم استخدم ٠٫٧ متر. كم بقي من السلك؟',
      choices: ['١٫٥٥ متر', '١٫٥٦ متر', '٢٫٢٥ متر', '١٫٤٥ متر'],
      correctIndex: 0,
      explanation: 'المستخدم ١٫٨٥ + ٠٫٧ = ٢٫٥٥ متر. '
          'المتبقي ٤٫١٠ - ٢٫٥٥ = ١٫٥٥ متر.',
      sourcePage: 64,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t11_h04',
      topicId: 'g4_p2_t11',
      lessonName: 'طرح الكسور العشرية',
      skill: 'التحقق بالعملية العكسية',
      difficultyRank: 95,
      questionTypeLabel: 'اختيار متعدد',
      prompt: 'طرح تلميذ: ٦٫٢ - ٢٫٨٥ = ٣٫٣٥. أي ناتج يتحقق به من صحة إجابته؟',
      choices: [
        '٣٫٣٥ + ٢٫٨٥ = ٦٫٢٠',
        '٣٫٣٥ + ٢٫٨٥ = ٦٫٢٥',
        '٣٫٣٥ - ٢٫٨٥ = ٠٫٥',
        '٦٫٢ + ٢٫٨٥ = ٩٫٠٥'
      ],
      correctIndex: 0,
      explanation: 'نجمع الناتج مع المطروح: ٣٫٣٥ + ٢٫٨٥ = ٦٫٢٠ = ٦٫٢، '
          'وهو المطروح منه، إذن الجواب صحيح.',
      sourcePage: 61,
    ),

    // ── ٧. تدريبات ومسائل على الجمع والطرح (ص ٦٤–٦٦) ──────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_b01',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'جمع وطرح متتاليان',
      difficultyRank: 12,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد الناتج: ٢٫٥ + ١٫٢ - ٠٫٧ =',
      choices: ['٣٫٠', '٣٫٣٠', '٣٫٧', '٢٫٥'],
      correctIndex: 0,
      explanation: '٢٫٥ + ١٫٢ = ٣٫٧، ثم ٣٫٧ - ٠٫٧ = ٣٫٠.',
      sourcePage: 64,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_b02',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'إيجاد الطرف المضاف',
      difficultyRank: 20,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'ما العدد الذي إذا أضيف إلى ١٫٥ نحصل على ٤٫٢؟',
      choices: ['٢٫٧', '٢٫٧٧', '٢٫٦', '٥٫٧'],
      correctIndex: 0,
      explanation: 'العدد = ٤٫٢ - ١٫٥ = ٢٫٧. للتحقق: ١٫٥ + ٢٫٧ = ٤٫٢.',
      sourcePage: 66,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_b03',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'طرح كسرين عشريين',
      difficultyRank: 26,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد: ٦٫٨ - ٢٫٣ =',
      choices: ['٤٫٥', '٤٫٥٥', '٤٫٦', '٢٫٣'],
      correctIndex: 0,
      explanation: '٨ - ٣ = ٥ أجزاء من عشرة، و٦ - ٢ = ٤ أحاد. الناتج ٤٫٥.',
      sourcePage: 65,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_b04',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'التحقق من ناتج طرح',
      difficultyRank: 29,
      questionTypeLabel: 'صح وخطأ',
      prompt: '٥٫٠ - ١٫٥ = ٤٫٥. هل العبارة صحيحة؟',
      choices: ['خطأ', 'صحيح'],
      correctIndex: 0,
      explanation: '٥٫٠ - ١٫٥ = ٣٫٥، لأن ٣٫٥ + ١٫٥ = ٥٫٠. '
          'إذن العبارة غير صحيحة.',
      sourcePage: 66,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_m01',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'عملية مختلطة',
      difficultyRank: 40,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد: ٣٫٧٥ + ٢٫٤ - ١٫١٥ =',
      choices: ['٥٫٠', '٥٫٠٥', '٥٫١', '٤٫٠'],
      correctIndex: 0,
      explanation: '٣٫٧٥ + ٢٫٤ = ٦٫١٥، ثم ٦٫١٥ - ١٫١٥ = ٥٫٠.',
      sourcePage: 65,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_m02',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'مسألة لفظية متعددة الخطوات',
      difficultyRank: 48,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'اشترت سيدة قطعة قماش طولها ٤٫٢٥ متر، فقطعت منها ١٫٨ متر ثم ٠٫٩ متر. كم بقي من القماش؟',
      choices: ['١٫٥٥ متر', '١٫٥٦ متر', '١٫٥ متر', '٢٫٤٥ متر'],
      correctIndex: 0,
      explanation: 'المجموع المقطوع ١٫٨ + ٠٫٩ = ٢٫٧ متر. '
          'المتبقي ٤٫٢٥ - ٢٫٧ = ١٫٥٥ متر.',
      sourcePage: 66,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_m03',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'إيجاد المطروح الناقص',
      difficultyRank: 56,
      questionTypeLabel: 'أكمل الناقص',
      prompt: 'أكمل: ٧٫٤ - ___ = ٢٫٨.',
      choices: ['٤٫٦', '٤٫٦٦', '٤٫٥', '٥٫٤'],
      correctIndex: 0,
      explanation: 'العدد الناقص = ٧٫٤ - ٢٫٨ = ٤٫٦، لأن ٧٫٤ - ٤٫٦ = ٢٫٨.',
      sourcePage: 66,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_m04',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'عملية داخل قوسين',
      difficultyRank: 64,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد ناتج: ١٠٫٥ - (٣٫٢ + ٢٫٩) =',
      choices: ['٤٫٤', '٤٫٤٤', '٤٫٥', '٥٫٤'],
      correctIndex: 0,
      explanation: 'نحسب ما داخل القوسين أولاً: ٣٫٢ + ٢٫٩ = ٦٫١. '
          'ثم ١٠٫٥ - ٦٫١ = ٤٫٤.',
      sourcePage: 65,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_h01',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'مسألة لفظية بطرح',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'وزن سلة فواكه ١٧٫٤ كيلو جرام، منها عنب يزن ٦٫٥ كيلو جرام. ما وزن التفاح في السلة؟',
      choices: [
        '١٠٫٩ كيلو جرام',
        '١٠٫٩٥ كيلو جرام',
        '١١٫٩ كيلو جرام',
        '١٠٫٨ كيلو جرام'
      ],
      correctIndex: 0,
      explanation:
          'وزن التفاح = وزن السلة - وزن العنب = ١٧٫٤ - ٦٫٥ = ١٠٫٩ كيلو جرام.',
      sourcePage: 66,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_h02',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'مسألة لفظية بجمع ثم طرح',
      difficultyRank: 82,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'مع عبد الله ٤٫٦٠ متر من الشريط اللاصق. استخدم ١٫١٥ متر لتجليد كتبه، و١٫٧٠ متر لتجليد دفاتره. كم بقي معه؟',
      choices: ['١٫٧٥ متر', '١٫٧٦ متر', '١٫٨٥ متر', '٢٫٧٥ متر'],
      correctIndex: 0,
      explanation: 'المستخدم ١٫١٥ + ١٫٧٠ = ٢٫٨٥ متر. '
          'المتبقي ٤٫٦٠ - ٢٫٨٥ = ١٫٧٥ متر.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_h03',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'جمع الفرق مع عدد',
      difficultyRank: 88,
      questionTypeLabel: 'مسألة لفظية',
      prompt: 'أضف الكسر ١٫٠٥ إلى الفرق بين الكسرين ٨٫٩ و٣٫٤٥. ما الناتج؟',
      choices: ['٦٫٥', '٦٫٥٥', '٦٫٦', '٥٫٤٥'],
      correctIndex: 0,
      explanation: 'الفرق ٨٫٩ - ٣٫٤٥ = ٥٫٤٥. '
          'ثم ٥٫٤٥ + ١٫٠٥ = ٦٫٥٠ = ٦٫٥.',
      sourcePage: 66,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t12_h04',
      topicId: 'g4_p2_t12',
      lessonName: 'تدريبات ومسائل على الجمع والطرح',
      skill: 'مسألة حركة متعددة الخطوات',
      difficultyRank: 95,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'قطار قطع ٢٫٧٥ كيلو متر، ثم ٣٫٤ كيلو متر، ثم عاد ١٫٢ كيلو متر. كم أصبح بعده عن نقطة البداية؟',
      choices: [
        '٤٫٩٥ كيلو متر',
        '٤٫٩٦ كيلو متر',
        '٤٫٧٥ كيلو متر',
        '٥٫٩٥ كيلو متر'
      ],
      correctIndex: 0,
      explanation: 'المسافة قبل العودة ٢٫٧٥ + ٣٫٤ = ٦٫١٥ كيلو متر. '
          'بعد العودة ٦٫١٥ - ١٫٢ = ٤٫٩٥ كيلو متر.',
      sourcePage: 66,
    ),

    // ── ٨. مسائل تطبيقية (ص ٦٧–٧٠) ────────────────────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_b01',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'قراءة المعطيات وطرح المرحلة الأولى',
      difficultyRank: 12,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'طريق طوله ٧١ كيلو متراً، قطع متسابق ١٧٫٨ كيلو متر في المرحلة الأولى. ما طول المرحلة الثانية؟',
      choices: [
        '٥٣٫٢ كيلو متر',
        '٥٣٫٢٥ كيلو متر',
        '٥٢٫٢ كيلو متر',
        '٨٨٫٨ كيلو متر'
      ],
      correctIndex: 0,
      explanation: 'المعطى: الطريق ٧١ كم والمرحلة الأولى ١٧٫٨ كم. '
          'المطلوب المرحلة الثانية = ٧١٫٠ - ١٧٫٨ = ٥٣٫٢ كيلو متر.',
      sourcePage: 67,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_b02',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'إيجاد وزن المحتوى',
      difficultyRank: 20,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'قارورة زيت تزن وهي فارغة ١٫٧٥ كيلو جرام، وتزن وهي مملوءة ٤٫٥ كيلو جرام. ما وزن الزيت وحده؟',
      choices: [
        '٢٫٧٥ كيلو جرام',
        '٢٫٧٦ كيلو جرام',
        '٢٫٦٥ كيلو جرام',
        '٦٫٢٥ كيلو جرام'
      ],
      correctIndex: 0,
      explanation:
          'وزن الزيت = وزن القارورة مملوءة - وزنها فارغة = ٤٫٥ - ١٫٧٥ = ٢٫٧٥ كيلو جرام.',
      sourcePage: 69,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_b03',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'اختيار خطة الحل',
      difficultyRank: 26,
      questionTypeLabel: 'اختيار متعدد',
      prompt:
          'طريق مقسوم إلى مرحلتين، نعرف طوله الكامل وطول المرحلة الأولى. ما العملية التي نستخدمها لإيجاد المرحلة الثانية؟',
      choices: ['الطرح', 'الجمع', 'الضرب', 'القسمة'],
      correctIndex: 0,
      explanation:
          'المرحلة الثانية = الطول الكامل - المرحلة الأولى، لذلك نستخدم الطرح.',
      sourcePage: 67,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_b04',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'مراجعة الحل',
      difficultyRank: 29,
      questionTypeLabel: 'صح وخطأ',
      prompt:
          'للتحقق من طول المرحلة الثانية نجمع طول المرحلتين الأولى والثانية.',
      choices: ['صحيح', 'خطأ'],
      correctIndex: 0,
      explanation:
          'لأن الجمع عملية عكسية للطرح، يجب أن يعطي مجموع المرحلتين طول الطريق الكامل.',
      sourcePage: 68,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_m01',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'مسألة ثلاثة طوابق',
      difficultyRank: 40,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'منزل من ثلاثة طوابق ارتفاعه ١١٫١ متر. ارتفاع الطابق الأول ٤٫٧٥ متر، والثاني ٣٫٨٥ متر. ما ارتفاع الطابق الثالث؟',
      choices: ['٢٫٥ متر', '٢٫٠٥ متر', '٢٫٦ متر', '٣٫٥ متر'],
      correctIndex: 0,
      explanation: 'ارتفاع الطابقين ٤٫٧٥ + ٣٫٨٥ = ٨٫٦٠ متر. '
          'الثالث ١١٫١ - ٨٫٦ = ٢٫٥ متر.',
      sourcePage: 68,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_m02',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'مسألة ثلاث قطع',
      difficultyRank: 50,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'قطعة قماش طولها ١٠٫١٨ متر، قُطعت إلى ثلاث قطع: الأولى ٧٫٩ متر والثانية ١٫٧٥ متر. ما طول القطعة الثالثة؟',
      choices: ['٠٫٥٣ متر', '٠٫٥٥ متر', '٠٫٦٣ متر', '١٫٥٣ متر'],
      correctIndex: 0,
      explanation: 'القطعتان الأولى والثانية ٧٫٩ + ١٫٧٥ = ٩٫٦٥ متر. '
          'الثالثة ١٠٫١٨ - ٩٫٦٥ = ٠٫٥٣ متر.',
      sourcePage: 69,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_m03',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'جمع ثلاث قراءات',
      difficultyRank: 58,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'باع تاجر ٥٠٫٥ كيلو جرام أرزاً في اليوم الأول، و٣٠٫٧٥ في اليوم الثاني، و٢٧٫٥ في اليوم الثالث. كم باع في الأيام الثلاثة؟',
      choices: [
        '١٠٨٫٧٥ كيلو جرام',
        '١٠٨٫٧٦ كيلو جرام',
        '١٠٨٫٥ كيلو جرام',
        '١٠٧٫٧٥ كيلو جرام'
      ],
      correctIndex: 0,
      explanation: '٥٠٫٥ + ٣٠٫٧٥ = ٨١٫٢٥، ثم ٨١٫٢٥ + ٢٧٫٥ = ١٠٨٫٧٥ كيلو جرام.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_m04',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'إيجاد الباقي',
      difficultyRank: 64,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'اشترى رجل صندوق عنب يزن ١٨٫٨ كيلو جرام، وأعطى أسرة أخيه ٥٫١٥ كيلو جرام. كم كيلو جراماً بقي لديه؟',
      choices: [
        '١٣٫٦٥ كيلو جرام',
        '١٣٫٦٦ كيلو جرام',
        '١٣٫٧٥ كيلو جرام',
        '١٢٫٦٥ كيلو جرام'
      ],
      correctIndex: 0,
      explanation: 'الباقي ١٨٫٨ - ٥٫١٥ = ١٣٫٦٥ كيلو جرام. '
          'للتحقق: ١٣٫٦٥ + ٥٫١٥ = ١٨٫٨.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_h01',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'سباق وزمن أقل',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'في سباق للجري، قطع متسابق المسافة في ٤٫٦ دقيقة، وقطع الثاني المسافة نفسها بزمن يقل عن الأول بمقدار ١٫٤ دقيقة. ما زمن المتسابق الثاني؟',
      choices: ['٣٫٢ دقيقة', '٣٫٢٥ دقيقة', '٣٫٤ دقيقة', '٦٫٠ دقيقة'],
      correctIndex: 0,
      explanation:
          'زمن الثاني = زمن الأول - مقدار النقص = ٤٫٦ - ١٫٤ = ٣٫٢ دقيقة.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_h02',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'مصروف متعدد',
      difficultyRank: 82,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'مع سارة ٤٠٫٦٠ سنتيمتراً من الشريط. استخدمت ١٢٫١٥ سنتيمتراً لتجليد كتبها، و١٨٫٧٠ لتجليد دفاترها. كم بقي معها؟',
      choices: [
        '٩٫٧٥ سنتيمتراً',
        '٩٫٧٦ سنتيمتراً',
        '٩٫٨٥ سنتيمتراً',
        '١٠٫٧٥ سنتيمتراً'
      ],
      correctIndex: 0,
      explanation: 'المستخدم ١٢٫١٥ + ١٨٫٧٠ = ٣٠٫٨٥ سنتيمتراً. '
          'المتبقي ٤٠٫٦٠ - ٣٠٫٨٥ = ٩٫٧٥ سنتيمتراً.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_h03',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'بيع على دفعات',
      difficultyRank: 88,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'اشترى تاجر ٥٠٫٥ كيلو جرام أرزاً، فباع ٣٠٫٧٥ كيلو جرام في اليوم الأول و١٢٫٥ كيلو جرام في اليوم الثاني. كم بقي عنده؟',
      choices: [
        '٧٫٢٥ كيلو جرام',
        '٧٫٢٦ كيلو جرام',
        '٧٫٣٥ كيلو جرام',
        '٨٫٢٥ كيلو جرام'
      ],
      correctIndex: 0,
      explanation: 'المباع ٣٠٫٧٥ + ١٢٫٥ = ٤٣٫٢٥ كيلو جرام. '
          'الباقي ٥٠٫٥ - ٤٣٫٢٥ = ٧٫٢٥ كيلو جرام.',
      sourcePage: 70,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t13_h04',
      topicId: 'g4_p2_t13',
      lessonName: 'مسائل تطبيقية',
      skill: 'مسألة متعددة الخطوات بمقارنة',
      difficultyRank: 96,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'ارتفاع منزل ١١٫١ متر. ارتفاع الطابق الأول ٤٫٧٥ متر، والطابق الثاني أطول من الأول بـ٠٫٤ متر. ما ارتفاع الطابق الثالث؟',
      choices: ['١٫٢ متر', '١٫٢٥ متر', '١٫٣ متر', '٢٫٢ متر'],
      correctIndex: 0,
      explanation: 'الثاني ٤٫٧٥ + ٠٫٤ = ٥٫١٥ متر. '
          'الأول والثاني ٤٫٧٥ + ٥٫١٥ = ٩٫٩٠ متر. '
          'الثالث ١١٫١ - ٩٫٩ = ١٫٢ متر.',
      sourcePage: 68,
    ),

    // ── ٩. اختبار الوحدة (ص ٧١–٧٢) ────────────────────────────────
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_b01',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'كتابة عدد كسري بالأرقام',
      difficultyRank: 12,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب بالأرقام: ثمانية عشر صحيح وسبعة من عشرة.',
      choices: ['١٨٫٧', '١٨٫٠٧', '١٨٧٫٠', '٠٫١٨٧'],
      correctIndex: 0,
      explanation: '١٨ وحدة كاملة قبل الفاصلة، و٧ أجزاء من عشرة بعدها: ١٨٫٧.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_b02',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'كتابة عدد كسري بالأرقام',
      difficultyRank: 20,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب بالأرقام: تسعة صحيح وخمسة وثلاثون من مائة.',
      choices: ['٩٫٣٥', '٩٫٠٣٥', '٩٣٫٥', '٩٫٥٣'],
      correctIndex: 0,
      explanation: '٩ وحدات قبل الفاصلة، و٣٥ جزءاً من مائة بعدها: ٩٫٣٥.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_b03',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'كتابة عدد كسري بالأرقام',
      difficultyRank: 26,
      questionTypeLabel: 'قراءة وكتابة',
      prompt: 'اكتب بالأرقام: خمسة صحيح وستون من مائة.',
      choices: ['٥٫٦٠', '٥٫٠٦', '٥٫٦٥', '٥٦٫٠'],
      correctIndex: 0,
      explanation: '٥ وحدات و٦٠ جزءاً من مائة، فنكتب ٥٫٦٠ (وهي تساوي ٥٫٦).',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_b04',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'قراءة الكسر العشري',
      difficultyRank: 29,
      questionTypeLabel: 'صح وخطأ',
      prompt: '١٫٣ تعني واحداً صحيحاً وثلاثة من عشرة.',
      choices: ['صحيح', 'خطأ'],
      correctIndex: 0,
      explanation:
          'الوحدة قبل الفاصلة، والرقم ٣ بعدها في منزلة الأجزاء من عشرة. العبارة صحيحة.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_m01',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'مقارنة كسرين عشريين',
      difficultyRank: 40,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'ضع الرمز المناسب: ٣٫٥ ◻ ٣٫٥٠',
      choices: ['=', '>', '<', '≠'],
      correctIndex: 0,
      explanation:
          'إضافة صفر في آخر الكسر العشري لا تغيّر قيمته، لذا ٣٫٥ = ٣٫٥٠.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_m02',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'الترتيب التنازلي',
      difficultyRank: 48,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'رتّب تنازلياً: ٢٫٤، ٢٫٠٤، ٢٫٤٠.',
      choices: [
        '٢٫٤، ٢٫٤٠، ٢٫٠٤',
        '٢٫٠٤، ٢٫٤، ٢٫٤٠',
        '٢٫٤٠، ٢٫٠٤، ٢٫٤',
        '٢٫٠٤، ٢٫٤٠، ٢٫٤',
      ],
      correctIndex: 0,
      explanation:
          '٢٫٤ = ٢٫٤٠، وكلاهما أكبر من ٢٫٠٤ لأن ٤ أجزاء من عشرة أكبر من ٠. '
          'التنازلي: ٢٫٤، ٢٫٤٠، ٢٫٠٤.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_m03',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'جمع الكسور العشرية',
      difficultyRank: 56,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد ناتج الجمع: ٣٫٧٥ + ٢٫٤ =',
      choices: ['٦٫١٥', '٦٫١٦', '٦٫٢٥', '٥٫١٥'],
      correctIndex: 0,
      explanation:
          'نكتب ٢٫٤ = ٢٫٤٠. ٥ + ٠ = ٥، ٧ + ٤ = ١١ نكتب ١ ونحمل ١، ٣ + ٢ + ١ = ٦. الناتج ٦٫١٥.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_m04',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'طرح الكسور العشرية',
      difficultyRank: 64,
      questionTypeLabel: 'عملية حسابية',
      prompt: 'أوجد ناتج الطرح: ٨٫٢ - ٣٫٦٥ =',
      choices: ['٤٫٥٥', '٤٫٥٦', '٤٫٦٥', '٥٫٥٥'],
      correctIndex: 0,
      explanation:
          'نكتب ٨٫٢ = ٨٫٢٠. في الأجزاء من مائة: ٠ - ٥ نستلف من الأجزاء من عشرة فتصبح ١٠ - ٥ = ٥. '
          'في الأجزاء من عشرة: ١ - ٦ نستلف من الأحاد فتصبح ١١ - ٦ = ٥. '
          'في الأحاد: ٧ - ٣ = ٤. الناتج ٤٫٥٥، '
          'وللتحقق: ٤٫٥٥ + ٣٫٦٥ = ٨٫٢٠.',
      sourcePage: 72,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_h01',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'مسألة كيس الدقيق',
      difficultyRank: 74,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'كيس دقيق وزنه ٢٥ كيلو جراماً. استهلكت أسرة ١٣٫٧٥ كيلو جرام في الشهر الأول، واستهلكت الباقي في الشهر الثاني. كم استهلكت في الشهر الثاني؟',
      choices: [
        '١١٫٢٥ كيلو جرام',
        '١١٫٢٦ كيلو جرام',
        '١١٫٣٥ كيلو جرام',
        '١٢٫٢٥ كيلو جرام'
      ],
      correctIndex: 0,
      explanation:
          'الباقي ٢٥٫٠٠ - ١٣٫٧٥ = ١١٫٢٥ كيلو جرام، وهو ما استهلك في الشهر الثاني.',
      sourcePage: 72,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_h02',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'مقارنة في مسألة',
      difficultyRank: 82,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'اشترى تلميذ كتابين: وزن الأول ٠٫٧٥ كيلو جرام، ووزن الثاني ٠٫٨ كيلو جرام. ما الفرق بين وزنيهما؟',
      choices: [
        '٠٫٠٥ كيلو جرام',
        '٠٫٥ كيلو جرام',
        '٠٫٠٤ كيلو جرام',
        '٠٫١٥ كيلو جرام'
      ],
      correctIndex: 0,
      explanation: 'نكتب ٠٫٨ = ٠٫٨٠. الفرق ٠٫٨٠ - ٠٫٧٥ = ٠٫٠٥ كيلو جرام.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_h03',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'ترتيب أربعة أعداد',
      difficultyRank: 88,
      questionTypeLabel: 'مقارنة وترتيب',
      prompt: 'رتّب تصاعدياً: ١٫٠٩، ١٫٢، ١٫١٥، ١٫٠٥.',
      choices: [
        '١٫٠٥، ١٫٠٩، ١٫١٥، ١٫٢',
        '١٫٠٩، ١٫٠٥، ١٫١٥، ١٫٢',
        '١٫٢، ١٫١٥، ١٫٠٩، ١٫٠٥',
        '١٫٠٥، ١٫١٥، ١٫٠٩، ١٫٢',
      ],
      correctIndex: 0,
      explanation: 'الوحدات متساوية. نرتب الأجزاء من عشرة ثم مائة: '
          '١٫٠٥ < ١٫٠٩ < ١٫١٥ < ١٫٢.',
      sourcePage: 71,
    ),
    AuthoredUnit6Question(
      id: 'g4p2u6_t14_h04',
      topicId: 'g4_p2_t14',
      lessonName: 'اختبار الوحدة',
      skill: 'دمج مفاهيم الوحدة',
      difficultyRank: 96,
      questionTypeLabel: 'مسألة لفظية',
      prompt:
          'لدى تلميذ ١٠ أجزاء من عشرة و٢٥ جزءاً من مائة. اكتب العدد الذي يمثلها ككسر عشري، ثم احسب فرقه عن العدد ٢.',
      choices: [
        '١٫٢٥ والفرق ٠٫٧٥',
        '١٫٢٥ والفرق ٠٫٧٦',
        '١٫٠٢٥ والفرق ٠٫٩٧٥',
        '١٫٢٥ والفرق ٠٫٨٥'
      ],
      correctIndex: 0,
      explanation:
          '١٠ أجزاء من عشرة = وحدة كاملة ١٫٠، و٢٥ جزءاً من مائة = ٠٫٢٥. '
          'المجموع ١٫٢٥. الفرق ٢٫٠٠ - ١٫٢٥ = ٠٫٧٥.',
      sourcePage: 71,
    ),
  ];

  static List<AuthoredUnit6Question> forLesson(
    String topicId, {
    int? minDifficulty,
    int? maxDifficulty,
  }) {
    return questions.where((question) {
      if (question.topicId != topicId) return false;
      if (minDifficulty != null && question.difficultyRank < minDifficulty) {
        return false;
      }
      if (maxDifficulty != null && question.difficultyRank > maxDifficulty) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }

  /// Difficulty envelope attached to the app's existing TopicStrength tiers.
  static (int, int) bandForStrength({required bool easy, required bool hard}) {
    if (easy) return (1, 30);
    if (hard) return (71, 100);
    return (31, 70);
  }
}
