import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  LauncherUtils._();

  static Future<bool> makePhoneCall(String rawPhoneNumber) async {
    final cleanNumber = rawPhoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: cleanNumber);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        debugPrint('Cannot launch tel URI: $uri');
        return false;
      }
    } catch (e) {
      debugPrint('Error making phone call: $e');
      return false;
    }
  }
}
