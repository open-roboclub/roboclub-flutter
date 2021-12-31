// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class EmailService {
  String apiKey = '';
  String emailText = '';
  Future<void> sendRegistrationEmail({required String recipent}) async {
    apiKey = await Remoteconfig().sendGridApiFetch();
    emailText = await Remoteconfig().fetchRegEmailTemplate();

    print(recipent);
    final mailer = Mailer(apiKey);
    final toAddress = Address(recipent);
    final fromAddress = Address('gargdhruv732@gmail.com');
    final content = Content('text/html', emailText);
    final subject = 'Membership form submitted successfully!';
    final personalization = Personalization([toAddress]);
    final email =
        Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      // ...
      print(result.asValue);
      print(result.isValue.toString());
    });
  }
}
