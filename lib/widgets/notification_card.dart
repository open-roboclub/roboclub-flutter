import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';

class NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define
    Map<String, Color> _colors = {
      "card": Theme.of(context).cardColor,
      "label": Theme.of(context).splashColor,
    };
    Map<String, TextStyle> _textstyle = {
      "location": Theme.of(context).textTheme.subtitle1,
      "label": Theme.of(context).primaryTextTheme.subtitle1,
    };
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: vpH * 0.3,
        width: vpW * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _colors['card'],
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              // offset: Offset(2, 2),
              blurRadius: 1.0,
              // spreadRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          children: [],
        ),
      ),
    );
  }
}
