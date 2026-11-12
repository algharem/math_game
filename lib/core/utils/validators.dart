import 'number_parser.dart';

class Validators {
  Validators._();

  static String? requiredAnswer(String? value) {
    if (value == null || value.trim().isEmpty) return 'اكتب الإجابة أولًا';
    return null;
  }

  static String? integerAnswer(String? value) {
    if (value == null || value.trim().isEmpty) return 'اكتب الإجابة أولًا';
    if (!NumberParser.isValidInteger(value)) {
      return 'الإجابة يجب أن تكون عددًا صحيحًا';
    }
    return null;
  }

  static String? profileName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'اكتب اسم البطل';
    if (name.length < 2) return 'الاسم قصير جدًا';
    if (name.length > 24) return 'الاسم طويل جدًا';
    return null;
  }

  static String? pin(String? value) {
    final pin = value?.trim() ?? '';
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      return 'الرمز يجب أن يتكون من ٤ أرقام';
    }
    return null;
  }

  static String? positiveInt(String? value) {
    final parsed = NumberParser.parseInt(value);
    if (parsed == null || parsed <= 0) return 'أدخل عددًا أكبر من صفر';
    return null;
  }
}
