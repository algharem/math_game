import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/utils/arabic_number_words.dart';

void main() {
  test('small numbers', () {
    expect(ArabicNumberWords.format(0), 'صفر');
    expect(ArabicNumberWords.format(1), 'واحد');
    expect(ArabicNumberWords.format(10), 'عشرة');
    expect(ArabicNumberWords.format(12), 'اثنا عشر');
    expect(ArabicNumberWords.format(21), 'واحد وعشرون');
    expect(ArabicNumberWords.format(45), 'خمسة وأربعون');
    expect(ArabicNumberWords.format(99), 'تسعة وتسعون');
  });

  test('hundreds', () {
    expect(ArabicNumberWords.format(100), 'مائة');
    expect(ArabicNumberWords.format(200), 'مائتان');
    expect(ArabicNumberWords.format(345), 'ثلاثمائة وخمسة وأربعون');
  });

  test('thousands', () {
    expect(ArabicNumberWords.format(1000), 'ألف');
    expect(ArabicNumberWords.format(2000), 'ألفان');
    expect(ArabicNumberWords.format(3000), 'ثلاثة آلاف');
    expect(ArabicNumberWords.format(34000), 'أربعة وثلاثون ألف');
    expect(ArabicNumberWords.format(21000), 'واحد وعشرون ألف');
    expect(ArabicNumberWords.format(3405), 'ثلاثة آلاف وأربعمائة وخمسة');
    expect(
      ArabicNumberWords.format(543210),
      'خمسمائة وثلاثة وأربعون ألف ومائتان وعشرة',
    );
  });

  test('millions range', () {
    expect(ArabicNumberWords.format(1000000), 'مليون');
    expect(ArabicNumberWords.format(2000000), 'مليونان');
    final large = ArabicNumberWords.format(3456789)!;
    expect(large, contains('ملايين'));
    expect(large, contains('أربعمائة وستة وخمسون ألف'));
    expect(large, contains('سبعمائة وتسعة وثمانون'));
  });

  test('out of range returns null, clamp fallback works', () {
    expect(ArabicNumberWords.format(-1), isNull);
    expect(ArabicNumberWords.format(1000000000), isNull);
    expect(ArabicNumberWords.format(999999999), isNotNull);
    expect(
      ArabicNumberWords.formatOrClamp(2000000000, max: 999999999),
      ArabicNumberWords.format(999999999),
    );
  });

  test('every supported numeral round-trips non-empty words', () {
    // Sample deterministic spread (segments + random-ish interior values).
    for (final value in [
      1, 7, 11, 99, 100, 105, 210, 999, 1000, 1001, 1234, 5000, 11000,
      99999, 100000, 100001, 543210, 999999, 1000000, 1000001, 2000000,
      10000000, 99999999, 505050505,
    ]) {
      final words = ArabicNumberWords.format(value);
      expect(words, isNotNull, reason: 'value $value');
      expect(words!.trim(), isNotEmpty, reason: 'value $value');
    }
  });
}
