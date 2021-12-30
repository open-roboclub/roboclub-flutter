// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

// import 'package:flutter_email_sender/flutter_email_sender.dart';

// import 'package:roboclub_flutter/models/member.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class EmailService {
  Future<void> sendRegistrationEmail({required String recipent}) async {
    // final message=Message().
    // final SmtpServer server = SmtpServer("smtp.sendgrid.net",
    // port: 25,
    // username: "apiKey",
    // password: "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"
    // );
    // gmailSaslXoauth2("amuroboclub@gmail.com", "lyqrixcqollvlsuh");
    // final Message message = Message()
    //   ..from = Address("gargdhruv732@gmail.com", "AMURoboclub")
    //   ..recipients = [recipent]
    //   ..subject = "Registration confirmation"
    //   ..html = emailText;
    // ..html=;

    final mailer = Mailer(
        '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');
    final toAddress = Address(recipent);
    final fromAddress = Address('gargdhruv732@gmail.com');
    final content = Content('text/html', emailText);
    final subject = 'Hello Subject!';
    final personalization = Personalization([toAddress]);
    // Email().content
    final email =
        Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      // ...
      print(result.toString());
      print(result.isValue.toString());
    });

    //   try {
    //     await send(message, server);
    //     print("Email send successfully");
    //   } catch (e) {
    //     print("could not send email $e");
    //   }
    // }
  }
}

String emailText =
    """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-GB">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>Demystifying Email Design</title>
  <meta name="viewport" content="width=device-width"/>

  <style type="text/css">
    a[x-apple-data-detectors] {color: inherit !important;}
  </style>

</head>
<body style="margin: 0; padding: 0;">
  <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td style="padding: 20px 0 30px 0;">

  <tr>
    <td bgcolor="black" style="padding: 40px 30px 40px 30px;">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
        <tr>
            <td bgcolor="black" align="center"  style="color:black ;">
                <img src="https://drive.google.com/thumbnail?id=11ASZixwcKQo_VGb5_AnkroQ9APHbfoMZ" bgcolor="black" style="display: block; width:40%; margin-left: auto; margin-right: auto;" />
              </td><br>
              
          
        </tr>
        <tr>
            <td style="color: #153643; font-family: Arial, sans-serif;">
                <h1 style="font-size: 24px; margin: 0;"><br>Greetings from <b style="color:darkblue">Team AMURoboclub!</b></h1>
              </td>
         
        </tr>
        <tr>
           
          <td style="color: brown; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; padding: 20px 0 30px 0;">
            <p style="margin: 0;">Thank you for registration, now be a part of AMURoboclub by scanning the QR and going through the final steps mentioned below.</p>
          </td>
        </tr>
        <tr>
          <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
              <tr>
                <td width="260" valign="top">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
                    <tr>
                      <td>
                        <img src="https://res.cloudinary.com/vidita/image/upload/v1638877335/qrCode_mjosyj.jpg" alt=""  style="width: 40%; display: block; margin-left: auto; margin-right: auto;" />
                      </td>
                    </tr>
                    <tr>
                      <td style="color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; padding: 25px 0 0 0;">
                        <p> <b style="color:#ee4c50">Problem scanning QR?</b></p>
                        <p> Pay to <b style="color:#162fa0">UPI ID: harshtaliwal@okaxis</b></p>
                        <br>
                        <p><li><b style="color:#4ba335">Registration Fees: </b> <b style = "color: white">Rs 150</b></li></p>
                        <p><li><b style="color:#4ba335">Registration Validity:</b> <b style = "color: white">1 year</b></li></p>
                        <p><li><b style="color:#4ba335">During your payment, clearly mention your name and faculty number in the note attached with it.</b></li></p>
                        <p><li><b style="color:#4ba335">If you face any difficulty with regards to payment, contact:- </b><b style = "color: white">(+91)9634478754</b></li></p>
                        <p><li><b style="color:#4ba335">Once your transaction is successful, we will reach you shortly.</b></li></p>
                        
                    </tr>
                    <tr>
                     
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>



      </td>
    </tr>
  </table>
</body>
</html>""";
