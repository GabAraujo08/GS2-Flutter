import 'package:url_launcher/url_launcher.dart';

class PhoneService {
  static const String emergencyNumber = '192';

  Future<bool> call(String number) async {
    final cleaned = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);
    try {
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }
}
