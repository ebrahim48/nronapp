import 'package:url_launcher/url_launcher.dart';
import 'toast_mesage_helper.dart';

class EmailHelper {
  /// Opens the device mail app with a pre-filled draft. Falls back to Gmail
  /// web compose when no mail app is installed (e.g. iOS simulator).
  static Future<void> compose({
    required String to,
    required String subject,
    required String body,
  }) async {
    final mailUri = Uri(
      scheme: 'mailto',
      path: to,
      query: 'subject=${Uri.encodeComponent(subject)}'
          '&body=${Uri.encodeComponent(body)}',
    );
    final gmailUri = Uri.https('mail.google.com', '/mail/', {
      'view': 'cm',
      'fs': '1',
      'to': to,
      'su': subject,
      'body': body,
    });

    Future<bool> tryLaunch(Uri uri) async {
      try {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        return false;
      }
    }

    final launched = await tryLaunch(mailUri) || await tryLaunch(gmailUri);
    if (!launched) {
      ToastMessageHelper.showToastMessage('Could not open email.',
          title: 'Error');
    }
  }
}
