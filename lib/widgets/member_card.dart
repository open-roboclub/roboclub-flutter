import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/member.dart';
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
                  widget.member.email.indexOf("@") - 5,
                  widget.member.email.indexOf("@"),
                  "XXXXX",
                ),
              ),
              Text(widget.member.facultyNo + ", " + widget.member.enrollNo),
              Text(widget.member.mobileNo.replaceRange(6, 10, "XXXX")),
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
