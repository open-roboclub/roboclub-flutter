import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var vpH;
  var vpW;
  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    User _user = Provider.of<UserProvider>(context).getUser;
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
        floatingActionButton: _user != null
            ? (_user.isAdmin
                ? FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                      size: vpH * 0.045,
                    ),
                  )
                : null)
            : null,
      ),
    );
  }
}
