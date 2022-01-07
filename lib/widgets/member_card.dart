import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:roboclub_flutter/models/member.dart';
import 'package:roboclub_flutter/services/member.dart';
import '../helper/dimensions.dart';

class MemberCard extends StatefulWidget {
  final Member member;

  const MemberCard({Key? key, required this.member}) : super(key: key);

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  Razorpay _razorpay = Razorpay();
  String key = "";
  String scrtKey = "";

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> generateOrderId() async {
    String recieptId = Random.secure().nextInt(1 << 32).toString();
    print(recieptId);
    final client = HttpClient();
    final request =
        await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$scrtKey'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(
        json.encode({"amount": 100, "currency": "INR", "receipt": recieptId})));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      String orderId = contents.split(',')[0].split(":")[1];
      print(contents);
      orderId = orderId.substring(1, orderId.length - 1);
      print(orderId);
      Map<String, dynamic> checkoutOptions = {
        'key': key,
        'amount': 1 * 100,
        "currency": "INR",
        'name': 'AMURoboclub',
        'description': 'Mvggfgfvf',
        'order_id': orderId, // Generate order_id using Orders API
        'timeout': 300,
      };
      try {
        _razorpay.open(checkoutOptions);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void openCheckout() async {
    var options = {
      'key': key,
      'amount': 15000,
      'name': 'AMURoboclub',
      'order_id': "order_id",
      'description': 'AMURoboclub Membership Payment',
      'prefill': {'contact': '9634478754', 'email': 'harshtaliwal@gmail.com'},
      "method": {
        "netbanking": false,
        "card": false,
        "upi": true,
        "wallet": false,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Status Updated ");
    Fluttertoast.showToast(msg: "Payment Completed Successfully");
    String sig = response.signature!;
    print(response.orderId);
    var bytes = utf8.encode(response.orderId! + "|" + response.paymentId!);
    // var digest = sha256.convert(bytes);
    Hmac hmac = new Hmac(sha256, utf8.encode(scrtKey));
    var digest = hmac.convert(bytes);
    if (digest.toString() == sig) {
      MemberService().updatePaymentStatus(widget.member);
    }
    print("Success" + response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error" + response.code.toString() + " - " + response.message!);
    Fluttertoast.showToast(msg: "Something went wrong");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Expernal Wallet" + response.walletName!);
  }

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
          // leading: CircleAvatar(
          //   radius: vpH * 0.037,
          //   onBackgroundImageError: (exception, stackTrace) {
          //     print("Network Img Exception");
          //     print(exception);
          //   },
          //   backgroundColor: Colors.black,
          // ),
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
                          // showUpdateBottomSheet();
                          await generateOrderId();
                          // openCheckout();
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
