/// Arabic number spelling (up to hundreds of millions), following the
/// Yemeni textbook convention, e.g. ٣٤٥٦ = «ثلاثة آلاف وأربعمائة وستة وخمسون».
///
/// Only needed for the *question side* of number-words MCQs (children pick
/// the numeral), so a compact segment-based formatter is enough.
class ArabicNumberWords {
  ArabicNumberWords._();

  static const List<String> _ones = [
    '',
    'واحد',
    'اثنان',
    'ثلاثة',
    'أربعة',
    'خمسة',
    'ستة',
    'سبعة',
    'ثمانية',
    'تسعة',
    'عشرة',
    'أحد عشر',
    'اثنا عشر',
    'ثلاثة عشر',
    'أربعة عشر',
    'خمسة عشر',
    'ستة عشر',
    'سبعة عشر',
    'ثمانية عشر',
    'تسعة عشر',
  ];

  static const List<String> _tens = [
    '',
    '',
    'عشرون',
    'ثلاثون',
    'أربعون',
    'خمسون',
    'ستون',
    'سبعون',
    'ثمانون',
    'تسعون',
  ];

  static const List<String> _hundreds = [
    '',
    'مائة',
    'مائتان',
    'ثلاثمائة',
    'أربعمائة',
    'خمسمائة',
    'ستمائة',
    'سبعمائة',
    'ثمانمائة',
    'تسعمائة',
  ];

  /// Renders the number in Arabic words. Returns null for unsupported
  /// values (negative or above 999,999,999).
  static String? format(int value) {
    if (value < 0 || value > 999999999) return null;
    if (value == 0) return 'صفر';

    final parts = <String>[];

    final millions = value ~/ 1000000;
    final remainder = value % 1000000;
    if (millions > 0) parts.add(_millionPhrase(millions));

    final thousands = remainder ~/ 1000;
    final ones = remainder % 1000;
    if (thousands > 0) parts.add(_thousandPhrase(thousands));
    if (ones > 0) {
      parts.add(ones < 100 ? _onesPhrase(ones) : _composite(ones));
    }

    return parts.join(' و');
  }

  /// Same as [format] but tolerates clamping: falls back to the capped
  /// value when out of range.
  static String formatOrClamp(int value, {int max = 999999999}) {
    final safe = value.clamp(0, max).toInt();
    return format(safe) ?? '$safe';
  }

  static String _millionPhrase(int millions) {
    if (millions == 1) return 'مليون';
    if (millions == 2) return 'مليونان';
    if (millions <= 10) return '${_ones[millions]} ملايين';
    return '${_composite(millions)} مليون';
  }

  static String _thousandPhrase(int thousands) {
    if (thousands == 1) return 'ألف';
    if (thousands == 2) return 'ألفان';
    if (thousands <= 10) return '${_ones[thousands]} آلاف';
    return '${_composite(thousands)} ألف';
  }

  static String _composite(int value) {
    final hundreds = value ~/ 100;
    final rest = value % 100;
    final parts = <String>[];
    if (hundreds > 0) parts.add(_hundreds[hundreds]);
    if (rest > 0) parts.add(_onesPhrase(rest));
    return parts.join(' و');
  }

  static String _onesPhrase(int value) {
    if (value <= 19) return _ones[value];
    final ones = value % 10;
    final tens = value ~/ 10;
    if (ones == 0) return _tens[tens];
    return '${_ones[ones]} و${_tens[tens]}';
  }
}
