class ArabicNumbers {
  ArabicNumbers._();

  static const List<String> _arabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  static const Map<String, String> _toArabic = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
    '۰': '٠',
    '۱': '١',
    '۲': '٢',
    '۳': '٣',
    '۴': '٤',
    '۵': '٥',
    '۶': '٦',
    '۷': '٧',
    '۸': '٨',
    '۹': '٩',
  };

  static const Map<String, String> _toWestern = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  static const String arabicDecimalSeparator = '٫';
  static const String arabicThousandsSeparator = '٬';

  static String toArabicDigits(Object? value) {
    if (value == null) return '';
    final buffer = StringBuffer();
    for (final rune in value.toString().runes) {
      final char = String.fromCharCode(rune);
      if (_arabicDigits.contains(char)) {
        buffer.write(char);
      } else if (_toArabic.containsKey(char)) {
        buffer.write(_toArabic[char]);
      } else if (char == '.') {
        buffer.write(arabicDecimalSeparator);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  static String toWesternDigits(Object? value) {
    if (value == null) return '';
    final buffer = StringBuffer();
    for (final rune in value.toString().runes) {
      final char = String.fromCharCode(rune);
      final mapped = _toWestern[char];
      if (mapped != null) {
        buffer.write(mapped);
      } else if (char == arabicDecimalSeparator) {
        buffer.write('.');
      } else if (char == arabicThousandsSeparator) {
        buffer.write(',');
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  static String normalize(String input) {
    final western = toWesternDigits(input);
    return western.replaceAll(',', '').trim();
  }

  static int? parseInt(String input) {
    final normalized = normalize(input);
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
  }

  static double? parseDouble(String input) {
    final normalized = normalize(input);
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  static String formatInt(int value, {bool grouping = false}) {
    final sign = value < 0 ? '-' : '';
    final absolute = value.abs().toString();
    final grouped = grouping ? _groupDigits(absolute) : absolute;
    return toArabicDigits('$sign$grouped');
  }

  static String formatNum(num value, {bool grouping = false}) {
    if (value is int) return formatInt(value, grouping: grouping);
    if (value == value.roundToDouble()) {
      return formatInt(value.toInt(), grouping: grouping);
    }
    final fixed = value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
    final parts = fixed.split('.');
    final integer = int.tryParse(parts.first) ?? 0;
    final integerText = formatInt(integer, grouping: grouping);
    return '$integerText$arabicDecimalSeparator${toArabicDigits(parts.last)}';
  }

  static String formatPercent(num value) {
    return '${formatInt(value.round())}٪';
  }

  static String formatClock(int totalSeconds) {
    final safe = totalSeconds < 0 ? 0 : totalSeconds;
    final minutes = safe ~/ 60;
    final seconds = safe % 60;
    return '${formatInt(minutes).padLeft(2, '٠')}:${formatInt(seconds).padLeft(2, '٠')}';
  }

  static String formatDuration(int totalSeconds) {
    final safe = totalSeconds < 0 ? 0 : totalSeconds;
    if (safe < 60) return '${formatInt(safe)} ثانية';
    final minutes = safe ~/ 60;
    final seconds = safe % 60;
    if (seconds == 0) return '${formatInt(minutes)} دقيقة';
    return '${formatInt(minutes)} دقيقة و${formatInt(seconds)} ثانية';
  }

  static String formatDate(DateTime date) {
    final day = formatInt(date.day).padLeft(2, '٠');
    final month = formatInt(date.month).padLeft(2, '٠');
    final year = formatInt(date.year);
    return '$day/$month/$year';
  }

  static String formatDateTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = formatInt(date.minute).padLeft(2, '٠');
    final period = date.hour < 12 ? 'ص' : 'م';
    return '${formatDate(date)} • ${formatInt(hour)}:$minute $period';
  }

  static String _groupDigits(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write(arabicThousandsSeparator);
      }
    }
    return buffer.toString();
  }
}
