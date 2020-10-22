import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
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
          child: Column(
            children: [
              SizedBox(
                height: vpH * 0.04,
              ),
              _title('Featured Events', vpH, vpW),
              Container(
                height: vpH * 0.3,
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return FeaturedEventCard();
                        },
                      )
                    : Center(
                        child: Text('No Ongoing Events Yet!'),
                      ),
              ),
              SizedBox(
                height: vpH * 0.04,
              ),
              _title('Upcoming Events', vpH, vpW),
              Container(
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return EventCard();
                        },
                      )
                    : Center(
                        child: Text('No Upcoming Events Yet!'),
                      ),
              ),
              SizedBox(
                height: vpH * 0.04,
              ),
              _title('Past Events', vpH, vpW),
              Container(
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return EventCard();
                        },
                      )
                    : Center(
                        child: Text('No Upcoming Events Yet!'),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
