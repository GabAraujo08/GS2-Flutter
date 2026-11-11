import 'package:presente/models/check_in.dart';
import 'package:presente/services/storage_service.dart';
import 'package:presente/utils/formatters.dart';

class CheckInService {
  CheckInService({StorageService? storage})
      : _storage = storage ?? StorageService();

  final StorageService _storage;

  Future<CheckIn> register(CheckInStatus status) async {
    final checkIn = CheckIn(time: DateTime.now(), status: status);
    await _storage.addCheckIn(checkIn);
    return checkIn;
  }

  Future<List<CheckIn>> history() async {
    final all = await _storage.loadCheckIns();
    final limit = DateTime.now().subtract(const Duration(days: 30));
    final recent = all.where((c) => c.time.isAfter(limit)).toList();
    recent.sort((a, b) => b.time.compareTo(a.time));
    return recent;
  }

  CheckIn? latestToday(List<CheckIn> sortedHistory) {
    final now = DateTime.now();
    for (final checkIn in sortedHistory) {
      if (isSameDay(checkIn.time, now)) return checkIn;
    }
    return null;
  }

  int countOk(List<CheckIn> history) {
    return history.where((c) => c.status == CheckInStatus.ok).length;
  }
}
