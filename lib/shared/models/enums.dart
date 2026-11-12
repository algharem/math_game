enum MathSection {
  multiplication,
  division,
  addition,
  subtraction,
  mixed,
  daily,
}

extension MathSectionX on MathSection {
  String get key => name;

  String get label {
    switch (this) {
      case MathSection.multiplication:
        return 'جدول الضرب';
      case MathSection.division:
        return 'القسمة';
      case MathSection.addition:
        return 'الجمع';
      case MathSection.subtraction:
        return 'الطرح';
      case MathSection.mixed:
        return 'اختبر نفسك';
      case MathSection.daily:
        return 'التحدي اليومي';
    }
  }

  String get shortLabel {
    switch (this) {
      case MathSection.multiplication:
        return 'الضرب';
      case MathSection.division:
        return 'القسمة';
      case MathSection.addition:
        return 'الجمع';
      case MathSection.subtraction:
        return 'الطرح';
      case MathSection.mixed:
        return 'مختلط';
      case MathSection.daily:
        return 'يومي';
    }
  }

  String get symbol {
    switch (this) {
      case MathSection.multiplication:
        return '×';
      case MathSection.division:
        return '÷';
      case MathSection.addition:
        return '+';
      case MathSection.subtraction:
        return '−';
      case MathSection.mixed:
        return '؟';
      case MathSection.daily:
        return '★';
    }
  }

  bool get isArithmetic =>
      this == MathSection.addition || this == MathSection.subtraction;
}

enum QuestionKind {
  multiplicationResult,
  multiplicationMissingFirst,
  multiplicationMissingSecond,
  divisionQuotient,
  divisionDivisor,
  divisionDividend,
  addition,
  subtraction,
  mixedExpression,
  // Curriculum-driven number-sense kinds (textbook "الجملة العددية"):
  numberWords,
  expandedForm,
  compareNumbers,
  rounding,
  // Topic-driven kinds for the exam platform:
  placeValueSplit,
  primeCheck,
  gcfLcm,
  geometryMeasure,
  absoluteValue,
  evaluateExpression,
  solveLinearEquation,
  linearSystem,
  quadraticRoot,
  squareRoot,
  cubeRoot,
  pythagoras,
  // Full-book-coverage kinds (every topic exam-able):
  fractionOps,
  percentCalc,
  unitConversion,
  statisticsMeasure,
  shapeFacts,
  wordProblem,
}

extension QuestionKindX on QuestionKind {
  MathSection get section {
    switch (this) {
      case QuestionKind.multiplicationResult:
      case QuestionKind.multiplicationMissingFirst:
      case QuestionKind.multiplicationMissingSecond:
        return MathSection.multiplication;
      case QuestionKind.divisionQuotient:
      case QuestionKind.divisionDivisor:
      case QuestionKind.divisionDividend:
        return MathSection.division;
      case QuestionKind.addition:
        return MathSection.addition;
      case QuestionKind.subtraction:
        return MathSection.subtraction;
      case QuestionKind.numberWords:
      case QuestionKind.expandedForm:
      case QuestionKind.compareNumbers:
      case QuestionKind.rounding:
      case QuestionKind.placeValueSplit:
      case QuestionKind.primeCheck:
      case QuestionKind.gcfLcm:
      case QuestionKind.geometryMeasure:
      case QuestionKind.absoluteValue:
      case QuestionKind.evaluateExpression:
      case QuestionKind.solveLinearEquation:
      case QuestionKind.linearSystem:
      case QuestionKind.quadraticRoot:
      case QuestionKind.squareRoot:
      case QuestionKind.cubeRoot:
      case QuestionKind.pythagoras:
      case QuestionKind.fractionOps:
      case QuestionKind.percentCalc:
      case QuestionKind.unitConversion:
      case QuestionKind.statisticsMeasure:
      case QuestionKind.shapeFacts:
      case QuestionKind.wordProblem:
      case QuestionKind.mixedExpression:
        return MathSection.mixed;
    }
  }

  bool get isMultiplication => section == MathSection.multiplication;

  bool get isDivision => section == MathSection.division;
}

enum Difficulty {
  easy,
  medium,
  hard,
  random,
}

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'سهل';
      case Difficulty.medium:
        return 'متوسط';
      case Difficulty.hard:
        return 'صعب';
      case Difficulty.random:
        return 'عشوائي';
    }
  }

  int get minimumLevel {
    switch (this) {
      case Difficulty.easy:
        return 1;
      case Difficulty.medium:
        return 2;
      case Difficulty.hard:
        return 4;
      case Difficulty.random:
        return 2;
    }
  }
}

enum AnswerMode {
  multipleChoice,
  typed,
}

extension AnswerModeX on AnswerMode {
  String get label {
    switch (this) {
      case AnswerMode.multipleChoice:
        return 'اختيار من متعدد';
      case AnswerMode.typed:
        return 'كتابة الإجابة';
    }
  }
}

enum MultiplicationFormat {
  result,
  missing,
  mixed,
}

extension MultiplicationFormatX on MultiplicationFormat {
  String get label {
    switch (this) {
      case MultiplicationFormat.result:
        return 'أوجد الناتج';
      case MultiplicationFormat.missing:
        return 'أوجد العدد الناقص';
      case MultiplicationFormat.mixed:
        return 'مختلط';
    }
  }
}

enum DivisionFormat {
  quotient,
  divisor,
  dividend,
  mixed,
}

extension DivisionFormatX on DivisionFormat {
  String get label {
    switch (this) {
      case DivisionFormat.quotient:
        return 'أوجد ناتج القسمة';
      case DivisionFormat.divisor:
        return 'أوجد المقسوم عليه';
      case DivisionFormat.dividend:
        return 'أوجد المقسوم';
      case DivisionFormat.mixed:
        return 'مختلط';
    }
  }
}

enum ExamSource {
  practice,
  exam,
  daily,
  retry,
}

enum MascotMood {
  idle,
  happy,
  encouraging,
  celebrating,
}
