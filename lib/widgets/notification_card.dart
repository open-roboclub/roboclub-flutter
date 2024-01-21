import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationCard extends StatefulWidget {
 
final Notifications notifications;

 NotificationCard(this.notifications) ;
 
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var heading = TextStyle(fontSize: vpH * 0.028, fontWeight: FontWeight.bold);

    DateTime _parsed = DateTime.parse(widget.notifications.date);
  
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: ExpansionTile(
            title: Text(
              widget.notifications.title,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: widget.notifications.link.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.link_outlined,
                      size: 15,
                      color: Color(0XFFFF9C01),
                    ),
                    onPressed: () async {
                      if (await canLaunch(widget.notifications.link)) {
                        launch(widget.notifications.link);
                      }
                    })
                : null,
            onExpansionChanged: (value) {
              setState(() {
                isExpanded = value;
              });
            },
            leading: Icon(Icons.circle_notifications),
            subtitle: isExpanded
                ? Text("")
                : RichText(
                    text: new TextSpan(
                      text: widget.notifications.msg.length > 100
                          ? widget.notifications.msg.substring(0, 100)
                          : widget.notifications.msg,
                      style: TextStyle(
                          color: Colors.black54, fontStyle: FontStyle.italic),
                      children: <TextSpan>[
                        new TextSpan(
                            text: widget.notifications.msg.length > 100 ? "...Read more" : "",
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: vpH * 0.03),
                child: Container(
                  width: vpW * 0.8,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        width: vpW * 0.017,
                      ),
                    ),
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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: vpH * 0.02, horizontal: vpW * 0.05),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.notifications.title,
                                  style: heading,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: vpH * 0.02, horizontal: vpW * 0.05),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                DateFormat('MMMEd').format(_parsed),
                                style: TextStyle(fontSize: vpH * 0.015),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: vpH * 0.005, horizontal: vpW * 0.05),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.notifications.msg.isNotEmpty ? widget.notifications.msg : "",
                            style: TextStyle(fontSize: vpH * 0.018),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.notifications.link)) {
                            launch(widget.notifications.link);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: vpH * 0.02, horizontal: vpW * 0.05),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListTile(
                              leading: Icon(
                                Icons.link_outlined,
                                color: widget.notifications.link.isNotEmpty
                                    ? Color(0XFFFF9C01)
                                    : Colors.grey,
                              ),
                              title: Text(
                                widget.notifications.link.isNotEmpty
                                    ? "View attached link"
                                    : "No link attached",
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
          ),
        ),
      ],
    );
  }
}
