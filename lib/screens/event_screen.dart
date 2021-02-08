import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/forms/event.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/services/event.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/event_card.dart';
import 'package:roboclub_flutter/widgets/featured_event_card.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Event> eventsList = [];
  bool isLoading = false;

  @override
  void initState() {
    EventService().fetchEvents().then((value) {
      eventsList = value;
      isLoading = true;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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
          child: eventsList.length == 0
              ? Center(
                  child: Container(
                    height: vpH,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Be Ready! A lot is about to happen..."),
                        Container(
                          width: vpW * 0.8,
                          height: vpH * 0.6,
                          // color: Colors.yellow,
                          child: SvgPicture.asset(
                            'assets/illustrations/events.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: vpH * 0.04,
                    ),
                    _title('Featured Events', vpH, vpW),
                    Container(
                        height: vpH * 0.34,
                        width: vpW,
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: eventsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return FeaturedEventCard(
                                    featuredEvent: eventsList[index],
                                  );
                                },
                              )),
                    SizedBox(
                      height: vpH * 0.04,
                    ),
                    _title('Upcoming Events', vpH, vpW),
                    Container(
                        width: vpW,
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: eventsList.length,
                                itemBuilder: (context, index) {
                                  return EventCard(
                                    event: eventsList[index],
                                  );
                                },
                              )),
                    SizedBox(
                      height: vpH * 0.04,
                    ),
                    _title('Past Events', vpH, vpW),
                    Container(
                        width: vpW,
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: eventsList.length,
                                itemBuilder: (context, index) {
                                  return EventCard(
                                    event: eventsList[index],
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
                      print("!!!!FLOATING" * 10);
                      print(_user.name);
                      print(_user.isAdmin);
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
