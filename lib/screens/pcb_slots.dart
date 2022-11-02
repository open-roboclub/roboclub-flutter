import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
// import 'package:roboclub_flutter/forms/project.dart';
import 'package:roboclub_flutter/services/auth.dart';
import 'package:roboclub_flutter/services/slot_booking.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';

class PcbSlots extends StatefulWidget {
  const PcbSlots({Key? key}) : super(key: key);

  @override
  _PcbSlotsState createState() => _PcbSlotsState();
}

class _PcbSlotsState extends State<PcbSlots> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SlotService _slotService = SlotService();
  final Remoteconfig remoteConfig = Remoteconfig();
  List slotValue = [];
  Map slot = {};
  bool eligible = true;
  bool selected = false;
  var vpH;
  bool update = false;

  @override
  void initState() {
    super.initState();
    _slotService.fetch().then((value) {
      setState(() {
        slot = value;
        // print(slot);
      });
    });
  }

  void checkForEligibility(String email, String slotKey) async {
    eligible = true;
    slotValue = slot[slotKey] as List;
    if (slotValue.length == 15) {
      setState(() {
        eligible = false;
      });
    } else {
      slot.forEach((key, value) {
        // List slotVal = value as List;
        if (value.contains(email)) {
          setState(() {
            // eligible = false;
            value.remove(email);
            update = true;
          });
        }
      });
    }
    if (email == "") {
      setState(() {
        eligible = false;
      });
    } else if (await _slotService.isMember(email)) {
      setState(() {
        slot[slotKey].add(email);
      });
      bookSlot(slot, update);
    } else {
      setState(() {
        eligible = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "This registration is for members of AMURoboclub only!",
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: vpH * 0.02,
                  fontFamily: 'OpenSans',
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      // color: Theme.of(context).primaryColor,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: vpH * 0.02,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Future<String?> getEmail() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    return googleSignInAccount?.email;
  }

  void signIn(String slotKey) {
    getEmail().then((value) {
      checkForEligibility(value ?? "", slotKey);
      // emailController.text = value == null ? "" : value;
      googleSignIn.signOut();
    });
  }

  bookSlot(Map slot, bool update) async {
    if (eligible == false) {
      print("err");
      Fluttertoast.showToast(msg: "This slot is full");
    } else {
      _slotService.updateSlot(Map.from(slot));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                update
                    ? "Your Slot has been updated"
                    : "Your Slot has been booked",
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: vpH * 0.02,
                  fontFamily: 'OpenSans',
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      // color: Theme.of(context).primaryColor,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: vpH * 0.02,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Book PCB Slots"),
        appBar: appBar(
          context,
          strTitle: "PCB Slots Booking",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Align(
            //     alignment: Alignment.topCenter,
            //     // margin: EdgeInsets.only(top: vpH / 4),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Text(
            //           "Book slots for :",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),

            //       ],
            //     )),
            Text(
              remoteConfig.fetchSlotDate(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            // SizedBox(
            //   height: vpH / 4,
            // ),
            ...List.generate(slot.keys.length, (index) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: vpH * 0.016),
                  child: new InkWell(
                    onTap: slot.values.toList()[index].length == 15
                        ? () {
                            Fluttertoast.showToast(msg: "This slot is full");
                          }
                        : () => signIn(slot.keys.toList()[index]),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: 200.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: slot.values.toList()[index].length == 15
                                ? Colors.grey.withOpacity(0.6)
                                : Theme.of(context).primaryColor,
                            width: 2.0),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text(slot.keys.toList()[index],
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        color: slot.values
                                                    .toList()[index]
                                                    .length ==
                                                15
                                            ? Colors.grey.withOpacity(0.6)
                                            : Theme.of(context).primaryColor)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text(
                                  "Slots available: " +
                                      (15 - slot.values.toList()[index].length)
                                          .toString(),
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color:
                                          slot.values.toList()[index].length ==
                                                  15
                                              ? Colors.grey.withOpacity(0.6)
                                              : Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
