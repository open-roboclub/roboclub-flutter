import 'package:flutter/material.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/models/ComponentsIssuedMember.dart';
import 'package:roboclub_flutter/models/member.dart';
import '../helper/dimensions.dart';

class ComponentsCard extends StatefulWidget {
  final ComponentMember member;
  final Function createOrderId;

  // final bool showPayment;
  const ComponentsCard(
      {Key? key, required this.member, required this.createOrderId})
      : super(key: key);

  @override
  State<ComponentsCard> createState() => _ComponentsCardState();
}

class _ComponentsCardState extends State<ComponentsCard> {
  bool isPayOpen = false;
  @override
  void initState() {
    super.initState();
    Remoteconfig().fetchIsPaymentOpen().then((value) {
      setState(() {
        isPayOpen = value;
      });
    });
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
              // Text(
              //   widget.member.email.replaceRange(
              //     2,
              //     10,
              //     "XXXXXXXX",
              //   ),
              // ),
              Text(widget.member.facultyNo + ", " + widget.member.enrollNo),
              //Text(widget.member.mobileNo.replaceRange(6, 10, "XXXX")),
              
            ],
          ),
          trailing: isPayOpen
              ? !widget.member.isIssued
                  ? ElevatedButton(
                      onPressed: !widget.member.isIssued
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
                        "Issued Now",
                      ),
                    )
                  : TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Issued",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
              : !widget.member.isIssued
                  ? TextButton.icon(
                      onPressed: () {},
                      icon: Text("Not Issued"),
                      label: Icon(Icons.access_time_rounded))
                  : TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Issued",
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
