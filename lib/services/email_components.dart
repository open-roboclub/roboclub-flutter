import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class EmailService2 {
  String apiKey = '';
  String regComponentsEmailText = '';
  
 // String compIssueConf = '';
  Future<void> sendComponentsRegistrationEmail({
    required String recipent,
    required bool payment,
    required String username,
    required File? pdf,
  }) async {
    apiKey = await Remoteconfig().sendGridApiFetch();
    regComponentsEmailText = await Remoteconfig().fetchComponentsConfirmationEmail();

    String fileAttachment =
        pdf == null ? "" : base64Encode(pdf.readAsBytesSync());
    print(recipent);
    final mailer = Mailer(apiKey);
    final toAddress = Address(recipent);
    final fromAddress = Address('amuroboclub@gmail.com');
    final content = Content('text/html', regComponentsEmailText);
        
         
    final subject = 'Registeration For Components form submitted successfully!';
        
         
    final personalization = Personalization([toAddress]);

    Attachment? attachment = fileAttachment == ""
        ? null
        : Attachment(
            fileAttachment,
            username + '_membership.pdf',
          );
    final email = Email(
      [personalization],
      fromAddress,
      subject,
      content: [content],
      attachments: attachment == null ? null : [attachment],
    );
    print(email);
    mailer.send(email).then((result) {
      // ...
      print(result.asValue);
      print(result.isValue.toString());
    });
  }
}
