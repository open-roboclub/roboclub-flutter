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

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': 15000,
      'name': 'AMURoboclub',
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
    MemberService().updatePaymentStatus(widget.member).then((value) {
      print("Payment Status Updated ");
      Fluttertoast.showToast(msg: "Payment Completed Successfully");
    });
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
    var vpW = getViewportWidth(context);
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
              Text(widget.member.mobileNo)
            ],
          ),
          trailing: !widget.member.isPaid
              ? ElevatedButton(
                  onPressed: !widget.member.isPaid
                      ? () {
                          openCheckout();
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
