import 'arabic_numbers.dart';

class NumberParser {
  NumberParser._();

  static int? parseInt(String? input) {
    if (input == null) return null;
    return ArabicNumbers.parseInt(input);
  }

  static double? parseDouble(String? input) {
    if (input == null) return null;
    return ArabicNumbers.parseDouble(input);
  }

  static bool isValidInteger(String? input) => parseInt(input) != null;

  static String sanitizeNumericInput(String input, {int maxLength = 6}) {
    final western = ArabicNumbers.toWesternDigits(input);
    final filtered = western.replaceAll(RegExp(r'[^0-9]'), '');
    final limited = filtered.length > maxLength
        ? filtered.substring(0, maxLength)
        : filtered;
    return ArabicNumbers.toArabicDigits(limited);
  }

  static String appendDigit(String current, String digit, {int maxLength = 6}) {
    final normalized = ArabicNumbers.toWesternDigits(current);
    if (normalized.length >= maxLength) return current;
    return ArabicNumbers.toArabicDigits(
        '$normalized${ArabicNumbers.toWesternDigits(digit)}');
  }

  static String removeLastDigit(String current) {
    final western = ArabicNumbers.toWesternDigits(current);
    if (western.isEmpty) return '';
    return ArabicNumbers.toArabicDigits(
      western.substring(0, western.length - 1),
    );
  }
}
