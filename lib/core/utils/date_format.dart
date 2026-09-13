abstract final class DateFmt {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String short(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  static String range(DateTime start, DateTime end) {
    return '${short(start)} – ${short(end)}';
  }

  static int nights(DateTime start, DateTime end) {
    return end.difference(DateTime(start.year, start.month, start.day)).inDays;
  }
}
