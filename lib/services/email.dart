import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class EmailService {
  String apiKey = '';
  String regEmailText = '';
  String payEmailText = '';
  Future<void> sendRegistrationEmail({
    required String recipent,
    required bool payment,
    File? pdf,
  }) async {
    apiKey = await Remoteconfig().SendGridApiFetch();
    regEmailText = await Remoteconfig().fetchRegEmailTemplate();
    payEmailText = await Remoteconfig().fetchPaymentConfEmailTemplate();

    String fileAttachment = base64Encode(pdf!.readAsBytesSync());
    print(recipent);
    final mailer = Mailer(apiKey);
    final toAddress = Address(recipent);
    final fromAddress = Address('amuroboclub@gmail.com');
    final content = payment
        ? Content('text/html', payEmailText)
        : Content('text/html', regEmailText);
    final subject = payment
        ? 'AMURoboclub Membership confirmation'
        : 'Membership form submitted successfully!';
    final personalization = Personalization([toAddress]);

    final Attachment attachment = Attachment(
      fileAttachment,
      'temp.pdf',
    );
    final email = Email(
      [personalization],
      fromAddress,
      subject,
      content: [content],
      attachments: [attachment],
    );
    mailer.send(email).then((result) {
      // ...
      print(result.asValue);
      print(result.isValue.toString());
    });
  }
}
