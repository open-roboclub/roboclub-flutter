import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roboclub_flutter/models/member.dart';
import 'package:roboclub_flutter/services/member.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/dimensions.dart';

class MemberCard extends StatefulWidget {
  final Member member;

  const MemberCard({Key? key, required this.member}) : super(key: key);

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  List<ApplicationMeta>? _apps;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handlePaymentSuccess() {
    MemberService().updatePaymentStatus(widget.member).then((value) {
      print("Payment Status Updated ");
      Fluttertoast.showToast(msg: "Payment Completed Successfully");
    });
  }

  void _handlePaymentError() {
    Fluttertoast.showToast(msg: "Something went wrong");
  }

  void showUpdateBottomSheet() {
    print("Hrs");
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        builder: (context) {
          return Wrap(
              children: _apps!.length == 0
                  ? [
                      Text("Download any UPI APP. Follow below link to download Google Pay."),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          try {
                            launch(
                              'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user&hl=en_IN&gl=US',
                            );
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Unable to launch");
                          }
                        },
                        child: Text("Update"),
                      ),
                    ]
                  : _apps!.map((ApplicationMeta appMetaData) {
                      return ListTile(
                        onTap: () async {
                          final transactionRef = Random.secure().nextInt(1 << 32).toString();
                          final response = await UpiPay.initiateTransaction(
                            app: appMetaData.upiApplication,
                            receiverUpiAddress: "gargdhruv732@okhdfcbank",
                            receiverName: "dhruv garg",
                            transactionRef: transactionRef,
                            amount: "1",
                          );
                          if (response.status == UpiTransactionStatus.success) {
                            _handlePaymentSuccess();
                          } else if (response.status == UpiTransactionStatus.failure) {
                            _handlePaymentError();
                          } else if (response.status == UpiTransactionStatus.submitted) {
                            Fluttertoast.showToast(
                                msg:
                                    "Your trransaction is in process. Please contact AMURoboclub if your status is not marked as successful in 24 hours");
                          }
                        },
                        leading: appMetaData.iconImage(24),
                        title: Text(appMetaData.upiApplication.appName),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      );
                    }).toList());
        });
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    String memberName = widget.member.name;
    TextStyle _titlestyle = TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.028, color: Colors.black);
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
            children: [Text(widget.member.email), Text(widget.member.facultyNo + ", " + widget.member.enrollNo), Text(widget.member.mobileNo)],
          ),
          trailing: !widget.member.isPaid
              ? ElevatedButton(
                  onPressed: !widget.member.isPaid
                      ? () {
                          showUpdateBottomSheet();
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
