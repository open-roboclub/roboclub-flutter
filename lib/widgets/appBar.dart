import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/notification_screen.dart';

AppBar appBar(context,
    {String strTitle,
    bool isNotification = false,
    isDrawer = false,
    GlobalKey<ScaffoldState> scaffoldKey}) {
  var vpH = getViewportHeight(context);
  var vpW = getViewportWidth(context);
  var iconcolor = isDrawer ? Theme.of(context).primaryColorLight : Colors.black;
  var bgcolor = Theme.of(context).primaryColor;
  var titlestyle = isDrawer
      ? TextStyle(
          fontFamily: "Signatra",
          fontSize: vpH * 0.03,
          fontWeight: FontWeight.bold,
        )
      : TextStyle(
          fontFamily: "Signatra",
          fontSize: vpH * 0.035,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );

  return AppBar(
    toolbarHeight: vpH * 0.098,
    leading: isDrawer
        ? IconButton(
            icon:Icon(Icons.menu,
            size: vpH*0.05,),
            color: iconcolor,
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          )
        : IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: iconcolor,
            iconSize: vpW * 0.08,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
    title: Text(
      strTitle,
      style: titlestyle,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: isNotification
            ? IconButton(
                icon: Icon(Icons.notifications_active),
                color: iconcolor,
                iconSize: vpW * 0.080,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ),
                ),
              )
            : null,
      ),
    ],
    backgroundColor: isDrawer ? bgcolor : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0)),
    ),
  );
}
