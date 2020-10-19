import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/notifications_screen.dart';

AppBar appBar(context,
    {String strTitle,
    bool isNotification = false,
    isDrawer = false,
    GlobalKey<ScaffoldState> scaffoldKey}) {
  var vpH = getViewportHeight(context);
  var vpW = getViewportWidth(context);
  var iconcolor = Theme.of(context).primaryColorLight;
  var bgcolor = Theme.of(context).primaryColor;

  return AppBar(
    toolbarHeight: vpH * 0.098,
    leading: isDrawer
        ? IconButton(
            icon: Icon(Icons.menu),
            color: iconcolor,
            iconSize: vpW * 0.10,
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          )
        : IconButton(
            icon: Icon(Icons.arrow_back),
            color: iconcolor,
            iconSize: vpW * 0.10,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
    title: Text(
      strTitle,
      style: TextStyle(
        fontFamily: "Signatra",
        fontSize: vpH * 0.03,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: isNotification
            ? IconButton(
            icon: Icon(Icons.notifications),
            color: iconcolor,
            iconSize: vpW * 0.080,
            onPressed: ()=>Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (BuildContext context)=>NotificationScreen()
                          )),
          )
            : null,
      ),
    ],
    backgroundColor: bgcolor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0)),
    ),
  );
}
