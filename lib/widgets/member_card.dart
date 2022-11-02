import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/helper/pdf_manager.dart';
import 'package:roboclub_flutter/models/member.dart';
import 'package:roboclub_flutter/services/email.dart';
import 'package:roboclub_flutter/services/member.dart';
import '../helper/dimensions.dart';

class MemberCard extends StatefulWidget {
  final Member member;
  final Function createOrderId;

  // final bool showPayment;
  const MemberCard(
      {Key? key, required this.member, required this.createOrderId})
      : super(key: key);

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool isPayOpen = false;
  File? pdf;

  @override
  void initState() {
    super.initState();
    Remoteconfig().fetchIsPaymentOpen().then((value) {
      setState(() {
        isPayOpen = value;
      });
    });
  }

  Future<void> generatePdf() async {
    var regNo = 'RT';
    regNo += new Random.secure().nextInt(1 << 6).toString();
    // print(regNo);
    pdf = await PdfManager().createRegSlip(widget.member, regNo);
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
          title: Text(
            memberName,
            style: _titlestyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.member.email.replaceRange(
                  2,
                  10,
                  "XXXXXXXX",
                ),
              ),
              Text(widget.member.facultyNo + ", " + widget.member.enrollNo),
              Text(widget.member.mobileNo.replaceRange(6, 10, "XXXX")),
            ],
          ),
          trailing: isPayOpen
              ? !widget.member.isPaid
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
                        "Paid",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
              : !widget.member.isPaid
                  ? TextButton.icon(
                      onPressed: () async {
                        await MemberService()
                            .updatePaymentStatus(widget.member)
                            .then((value) async {
                          await generatePdf();
                          EmailService().sendRegistrationEmail(
                            recipent: widget.member.email,
                            payment: true,
                            pdf: pdf,
                            username: widget.member.name,
                          );
                        });
                        setState(() {
                          widget.member.isPaid = true;
                        });
                      },
                      icon: Text("Payment due"),
                      label: Icon(Icons.access_time_rounded))
                  : TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Paid",
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
