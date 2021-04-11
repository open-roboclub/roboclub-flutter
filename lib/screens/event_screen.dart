import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/forms/event.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/screens/notification_screen.dart';
import 'package:roboclub_flutter/services/event.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/event_card.dart';
import 'package:roboclub_flutter/widgets/featured_event_card.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message['data']['screen'] == 'notification') {
    print('inside notification screen');
  }

  // Or do other work.
}

class _EventScreenState extends State<EventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Event> featuredEventsList = [];
  List<Event> upcomingEventsList = [];
  List<Event> pastEventsList = [];
  bool isLoading = true;
  DateTime parsedDate;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    EventService().fetchEvents().then((value) {
      splitEventLists(value);
      isLoading = true;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void initNotifications(BuildContext context) async {
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Show'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (message['data']['screen'] == 'event') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventScreen(),
                        ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ));
                  }
                },
              ),
              FlatButton(
                color: Colors.amber,
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        if (message['data']['screen'] == 'notification') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
            ),
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        if (message['data']['screen'] == 'event') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(),
              ));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
            ),
          );
        }
      },
    );
  }

  void splitEventLists(List<Event> events) {
    List<Event> tempList = [];
    events.forEach((item) {
      DateTime today = DateTime.now();
      DateTime _parsed = DateTime.parse(item.date);
      if (_parsed.difference(today).inDays == 0 || item.isFeatured) {
        item.date = DateFormat('MMMEd').format(_parsed);
        featuredEventsList.add(item);
      } else if (_parsed.isAfter(today)) {
        item.date = DateFormat('MMMEd').format(_parsed);
        tempList.add(item);
      } else {
        item.date = DateFormat('MMMEd').format(_parsed);
        item.regFormLink = "";
        pastEventsList.add(item);
      }
    });
    upcomingEventsList = tempList.reversed.toList();
  }

  Widget _title(String title, var vpH, var vpW) {
    return Row(
      children: [
        SizedBox(
          width: vpW * 0.06,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: vpH * 0.03,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    initNotifications(context);
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    User _user = Provider.of<UserProvider>(context).getUser;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Events"),
        appBar: appBar(context,
            strTitle: "AMURoboclub",
            isDrawer: true,
            isNotification: true,
            scaffoldKey: _scaffoldKey),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: isLoading
              ? Container(
                  height: vpH,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: vpH * 0.04,
                    ),
                    _title('Featured Events', vpH, vpW),
                    featuredEventsList.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: vpH * 0.02),
                              child: Container(
                                height: vpH * 0.2,
                                width: vpW * 0.6,
                                child: SvgPicture.asset(
                                  'assets/illustrations/events.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: vpH * 0.34,
                            width: vpW,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: featuredEventsList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return FeaturedEventCard(
                                  featuredEvent: featuredEventsList[index],
                                );
                              },
                            )),
                    SizedBox(
                      height: vpH * 0.04,
                    ),
                    _title('Upcoming Events', vpH, vpW),
                    upcomingEventsList.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: vpH * 0.02),
                              child: Container(
                                height: vpH * 0.2,
                                width: vpW * 0.6,
                                child: SvgPicture.asset(
                                  'assets/illustrations/calendar.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: vpW,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: upcomingEventsList.length,
                              itemBuilder: (context, index) {
                                return EventCard(
                                  event: upcomingEventsList[index],
                                );
                              },
                            )),
                    SizedBox(
                      height: vpH * 0.04,
                    ),
                    _title('Past Events', vpH, vpW),
                    Container(
                        width: vpW,
                        child: pastEventsList.isEmpty
                            ? Center(
                                child: Container(
                                  height: vpH * 0.3,
                                  width: vpW * 0.6,
                                  child: SvgPicture.asset(
                                    'assets/illustrations/calendar.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: pastEventsList.length,
                                itemBuilder: (context, index) {
                                  return EventCard(
                                    event: pastEventsList[index],
                                  );
                                },
                              )),
                  ],
                ),
        ),
        floatingActionButton: _user != null
            ? (_user.isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EventForm();
                          },
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  )
                : null)
            : null,
      ),
    );
  }
}
