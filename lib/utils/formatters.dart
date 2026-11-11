const List<String> _weekdays = [
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
  'Domingo',
];

String weekdayName(DateTime date) => _weekdays[date.weekday - 1];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String formatShortDate(DateTime date) {
  return '${_twoDigits(date.day)}/${_twoDigits(date.month)}';
}

String formatTime(DateTime time) {
  return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 11) {
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
  }
  if (digits.length == 10) {
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
  }
  return raw;
}
