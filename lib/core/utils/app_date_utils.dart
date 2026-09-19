/// أدوات التواريخ لحساب سلسلة الأيام المتتالية.
class AppDateUtils {
  AppDateUtils._();

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime? parseIsoDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static String toIsoDate(DateTime date) {
    final only = dateOnly(date);
    final month = only.month.toString().padLeft(2, '0');
    final day = only.day.toString().padLeft(2, '0');
    return '${only.year}-$month-$day';
  }

  static bool isToday(DateTime? date) {
    if (date == null) return false;
    return dateOnly(date) == dateOnly(DateTime.now());
  }

  static bool isYesterday(DateTime? date) {
    if (date == null) return false;
    return dateOnly(date) ==
        dateOnly(DateTime.now().subtract(const Duration(days: 1)));
  }
}
