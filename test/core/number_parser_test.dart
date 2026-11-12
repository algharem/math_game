import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/arabic_numbers.dart';
import 'package:math_heroes/core/utils/number_parser.dart';

void main() {
  group('NumberParser', () {
    test('parses Arabic-Indic and Eastern Arabic digits', () {
      expect(NumberParser.parseInt('١٢٣'), 123);
      expect(NumberParser.parseInt('۱۲۳'), 123);
      expect(NumberParser.parseInt(' ٤٥ '), 45);
      expect(NumberParser.parseInt('0'), 0);
    });

    test('returns null for invalid input', () {
      expect(NumberParser.parseInt(null), isNull);
      expect(NumberParser.parseInt(''), isNull);
      expect(NumberParser.parseInt('12a'), isNull);
    });

    test('parses Arabic decimal separator', () {
      expect(NumberParser.parseDouble('٣٫٥'), 3.5);
    });

    test('sanitizes and limits numeric input', () {
      expect(NumberParser.sanitizeNumericInput('١٢أ٣'), '١٢٣');
      expect(
          NumberParser.sanitizeNumericInput('1234567', maxLength: 4), '١٢٣٤');
    });

    test('appends and removes digits', () {
      expect(NumberParser.appendDigit('١٢', '٣'), '١٢٣');
      expect(NumberParser.appendDigit('١٢٣٤', '٥', maxLength: 4), '١٢٣٤');
      expect(NumberParser.removeLastDigit('١٢٣'), '١٢');
      expect(NumberParser.removeLastDigit(''), '');
    });
  });

  group('ArabicNumbers', () {
    test('converts digits in both directions', () {
      expect(ArabicNumbers.toArabicDigits(123), '١٢٣');
      expect(ArabicNumbers.toWesternDigits('١٢٣'), '123');
    });

    test('formats integers and percentages', () {
      expect(ArabicNumbers.formatInt(1250, grouping: true), '١٬٢٥٠');
      expect(ArabicNumbers.formatPercent(75), '٧٥٪');
    });
  });
}
