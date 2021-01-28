import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationCard extends StatelessWidget {
  final String msg;
  final String link;
  final String title;

  const NotificationCard({Key key, this.msg, this.link, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Define
    // Map<String, Color> _colors = {
    //   "card": Theme.of(context).cardColor,
    //   "label": Theme.of(context).splashColor,
    // };
    // Map<String, TextStyle> _textstyle = {
    //   "location": Theme.of(context).textTheme.subtitle1,
    //   "label": Theme.of(context).primaryTextTheme.subtitle1,
    // };
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var heading = TextStyle(fontSize: vpH * 0.028, fontWeight: FontWeight.bold);

    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: vpH * 0.03),
          child: Container(
            // height: vpH * 0.4,
            width: vpW * 0.8,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  width: vpW * 0.017,
                ),
              ),
              // borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(2, 5),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vpH * 0.02, horizontal: vpW * 0.05),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: heading,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vpH * 0.005, horizontal: vpW * 0.05),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      msg.isNotEmpty ? msg : "",
                      style: TextStyle(fontSize: vpH * 0.018),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch(link);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: vpH * 0.02, horizontal: vpW * 0.05),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ListTile(
                        leading: Icon(
                          Icons.link_outlined,
                          color: Color(0XFFFF9C01),
                        ),
                        title: Text(
                          "View attached link",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: vpH * 0.020,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
