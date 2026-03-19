// Pure Dart utility — no Flutter import needed

String formatDate(DateTime dt) {
  final months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${dt.day} ${months[dt.month]} ${dt.year}';
}

String formatDateShort(DateTime dt) {
  return '${dt.day}/${dt.month}';
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isBeforeDay(DateTime a, DateTime b) {
  final da = DateTime(a.year, a.month, a.day);
  final db = DateTime(b.year, b.month, b.day);
  return da.isBefore(db);
}
