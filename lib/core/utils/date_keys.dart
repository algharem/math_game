class DateKeys {
  DateKeys._();

  static String fromDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  static String today() => fromDate(DateTime.now());

  static String yesterday() =>
      fromDate(DateTime.now().subtract(const Duration(days: 1)));

  static DateTime parse(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static List<String> lastDays(int count, {DateTime? end}) {
    final anchor = end ?? DateTime.now();
    return List.generate(count, (index) {
      return fromDate(anchor.subtract(Duration(days: count - index - 1)));
    });
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
