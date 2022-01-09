// import 'dart:convert';
import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:roboclub_flutter/configs/remoteConfig.dart';
// import 'package:roboclub_flutter/helper/pdf_manager.dart';
import 'package:roboclub_flutter/models/member.dart';
// import 'package:roboclub_flutter/services/email.dart';
// import 'package:roboclub_flutter/services/member.dart';
import '../helper/dimensions.dart';
// import 'package:string_encryption/string_encryption.dart';

class MemberCard extends StatefulWidget {
  final Member member;
  final Function createOrderId;
  // final bool showPayment;
  const MemberCard({Key? key, required this.member, required this.createOrderId})
      : super(key: key);

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  // late Razorpay _razorpay;

  File? pdf;
  // late String amount;
  @override
  void initState() {
    super.initState();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // void initEncryption() async {
  //   _firestore
  //       .collection("/keys")
  //       .doc("razorpayKey")
  //       .get()
  //       .then((fcmKeySnap) async {
  //     String password = fcmKeySnap.get('password');
  //     String salt = fcmKeySnap.get('salt');
  //     // print(scrtKey);
  //     String? encrptyKey =
  //         await cryptor.generateKeyFromPassword(password, salt);
  //     // encrpy=cryptor.encrypt("", key)
  //     scrtKey = await cryptor.decrypt(scrtKey, encrptyKey!) ?? "";
  //     // print("decrypted $scrtKey");
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  // Future<void> generatePdf() async {
  //   var regNo = 'RT';
  //   regNo += new Random.secure().nextInt(1 << 6).toString();
  //   // print(regNo);
  //   pdf = await PdfManager().createRegSlip(widget.member, regNo);
  // }

  // Future<void> generateOrderId() async {
  //   String recieptId = Random.secure().nextInt(1 << 32).toString();

  //   print(recieptId);
  //   final client = HttpClient();
  //   final request =
  //       await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
  //   request.headers
  //       .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
  //   String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$scrtKey'));
  //   request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
  //   request.add(utf8.encode(json.encode(
  //       {"amount": amount * 100, "currency": "INR", "receipt": recieptId})));
  //   final response = await request.close();
  //   response.transform(utf8.decoder).listen((contents) {
  //     String orderId = contents.split(',')[0].split(":")[1];
  //     // print(contents);
  //     orderId = orderId.substring(1, orderId.length - 1);
  //     // print(orderId);
  //     Map<String, dynamic> checkoutOptions = {
  //       'key': key,
  //       'amount': amount * 100,
  //       "currency": "INR",
  //       'name': 'AMURoboclub',
  //       'description': 'Membership amount',
  //       'order_id': orderId,
  //       // 'prefill': {'contact': '9634478754', 'email': 'harshtaliwal@gmail.com'},
  //       "method": {
  //         "netbanking": false,
  //         "card": false,
  //         "upi": true,
  //         "wallet": false,
  //       }, // Generate order_id using Orders API
  //       'timeout': 300,
  //     };
  //     // log.call(checkoutOptions);
  //     // debugPrint(checkoutOptions.toString());
  //     try {
  //       _razorpay.open(checkoutOptions);
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   });
  // }

  // void openCheckout() async {
  //   var options = {
  //     'key': key,
  //     'amount': 15000,
  //     'name': 'AMURoboclub',
  //     'order_id': "order_id",
  //     'description': 'AMURoboclub Membership Payment',
  //     'prefill': {'contact': '9634478754', 'email': 'harshtaliwal@gmail.com'},
  //     "method": {
  //       "netbanking": false,
  //       "card": false,
  //       "upi": true,
  //       "wallet": false,
  //     },
  //   };

  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    String memberName = widget.member.name;
    TextStyle _titlestyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: vpH * 0.028,
        color: Colors.black);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.white,
          contentPadding: EdgeInsets.all(10),
          title: Text(
            memberName,
            style: _titlestyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.member.email),
              Text(widget.member.facultyNo + ", " + widget.member.enrollNo),
              Text(widget.member.mobileNo),
            ],
          ),
          trailing: !widget.member.isPaid
              ? ElevatedButton(
                  onPressed: !widget.member.isPaid
                      ? () async {
                          await widget.createOrderId(widget.member);
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Text(
                    "Pay Now",
                  ),
                )
              : TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  ),
                  label: Text(
                    "Payed",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
