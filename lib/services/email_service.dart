import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  
  static const String _smtpUsername = 'Email';
  static const String _smtpAppPassword = '#SecretAppPassword'; // this is an app password from 2fa
  static const String _toEmail = 'Email';

  static bool get isConfigured =>
      _smtpUsername.isNotEmpty &&
      _smtpAppPassword.isNotEmpty &&
      _toEmail.isNotEmpty;

  Future<void> sendContactEmail({
    required String name,
    required String fromEmail,
    required String comment,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('SMTP is not supported on Flutter Web.');
    }

    final smtpServer = gmail(_smtpUsername, _smtpAppPassword);

    final message = Message()
      ..from = Address(_smtpUsername, 'DRIVE NOW')
      ..recipients.add(_toEmail)
      ..subject = 'New contact form submission from $name'
      ..text =
          '''
You received a new message:

Name: $name
Email: $fromEmail

Comment:
$comment
''';

    try {
      await send(message, smtpServer, timeout: const Duration(seconds: 30));
    } on MailerException catch (e) {
      for (var p in e.problems) {
        debugPrint('SMTP ERROR: ${p.code} - ${p.msg}');
      }
      rethrow;
    }
  }
}
