import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';

class PcbSlots extends StatefulWidget {
  const PcbSlots({ Key? key }) : super(key: key);

  @override
  _PcbSlotsState createState() => _PcbSlotsState();
}

class _PcbSlotsState extends State<PcbSlots> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(          
        ),
      ),
    );
  }
}