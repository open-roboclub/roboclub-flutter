import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/forms/event.dart';
import 'package:roboclub_flutter/forms/membership.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/screens/notification_screen.dart';
import 'package:roboclub_flutter/screens/reg_members_screen.dart';
import 'package:roboclub_flutter/services/event.dart';
import 'package:roboclub_flutter/services/shared_prefs.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/event_card.dart';
import 'package:roboclub_flutter/widgets/featured_event_card.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:in_app_update/in_app_update.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data['screen'] == 'notification') {
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
  // bool isUpdateCanceled = true;
  late DateTime parsedDate;

  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool showBanner = false;
  bool isUpdateRequired = false;
  MyLocalStorage prefs = MyLocalStorage();

  @override
  void initState() {
    prefs.getCheckUpdate().then((lastChecked) {
      if (lastChecked == "") {
        Remoteconfig().isUpdateRequired().then((value) {
          setState(() {
            // print()
            isUpdateRequired = value;
            if (isUpdateRequired) _showVersionDialog();
          });
        });
      } else if (DateTime.now().difference(DateTime.parse(lastChecked)).inDays >
          2) {
        Remoteconfig().isUpdateRequired().then((value) {
          setState(() {
            // print()
            isUpdateRequired = value;
            if (isUpdateRequired) _showVersionDialog();
          });
        });
      }
    });

    Remoteconfig().showHomeMmebershipOpen().then((value) {
      setState(() {
        showBanner = value;
      });
    });

    // checkForUpdate();

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
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message == null) return print(message?.notification);
      if (message.data['screen'] == 'event') {
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
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data);
      print(message.notification);
      if (message.data['screen'] == 'event') {
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
    });
    FirebaseMessaging.onMessage.listen((message) {
      print("onMessage: $message");
      // print("onMessage: ${message.notification}");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message.notification!.title ?? ""),
            subtitle: Text(message.notification!.body ?? ""),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.amber,
              child: Text('Show'),
              onPressed: () {
                Navigator.of(context).pop();
                if (message.data['screen'] == 'event') {
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
    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    // _messaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");

    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             color: Colors.amber,
    //             child: Text('Show'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               if (message['data']['screen'] == 'event') {
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => EventScreen(),
    //                     ));
    //               } else {
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => NotificationScreen(),
    //                     ));
    //               }
    //             },
    //           ),
    //           FlatButton(
    //             color: Colors.amber,
    //             child: Text('Cancel'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    // onLaunch: (Map<String, dynamic> message) async {
    //   if (message['data']['screen'] == 'notification') {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Notuser as ModelUserificationScreen,
    //       ),
    //     );
    //   }
    // },
    // onResume: (Map<String, dynamic> message) async {
    //   if (message['data']['screen'] == 'event') {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => EventScreen(),
    //         ));
    //   } else {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => NotificationScreen(),
    //       ),
    //     );
    //   }
    // },
    // );
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

  _showVersionDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => launch(
                'https://play.google.com/store/apps/details?id=amuroboclub.roboclub_flutter',
              ),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () {
                prefs.setCheckUpdate(DateTime.now().toIso8601String());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initNotifications(context);
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    ModelUser _user = Provider.of<UserProvider>(context).getUser;

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
                    // SizedBox(
                    //   height: vpH * 0.02,
                    // ),
                    showBanner
                        ? SkeletonLoader(
                            baseColor: Colors.black,
                            direction: SkeletonDirection.rtl,
                            highlightColor: Colors.grey.shade300,
                            builder: Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.only(
                                  left: vpW * 0.04,
                                  right: vpW * 0.04,
                                  top: vpH * 0.02,
                                  bottom: vpH * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                horizontalTitleGap: 0,
                                tileColor: Colors.orange[400],
                                title: FittedBox(
                                  child: Text(
                                    'Applications Open for Membership',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Membership();
                                      },
                                    ),
                                  );
                                  if (result != null) {
                                    if (result["success"]) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return RegMembersScreen();
                                          },
                                        ),
                                      );
                                    }
                                  }
                                },
                                leading: ImageIcon(
                                  AssetImage('assets/img/NoPath.png'),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
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
        // bottomSheet: Text(""),
      ),
    );
  }
}
