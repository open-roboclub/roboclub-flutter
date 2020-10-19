import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(
          context,
          strTitle: "Notifications",
          isDrawer: false,
          isNotification: false,
        ),
        body: Center(
          child: Text('Notifications Screen'),
        ),
      ),
    );
  }
}
