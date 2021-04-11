import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowEventScreen extends StatefulWidget {
  final Event eventinfo;

  ShowEventScreen({Key key, this.eventinfo}) : super(key: key);

  @override
  _ShowEventScreenState createState() => _ShowEventScreenState();
}

class _ShowEventScreenState extends State<ShowEventScreen> {
  bool drag = false;
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: vpH,
          width: vpW,
          child: Stack(
            children: [
              Hero(
                tag: widget.eventinfo.eventName,
                child: Container(
                  height: vpH * 0.35,
                  width: vpW,
                  child: widget.eventinfo.posterURL == ""
                      ? SvgPicture.asset(
                          'assets/illustrations/events.svg',
                          fit: BoxFit.contain,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.eventinfo.posterURL,
                          fadeInCurve: Curves.easeIn,
                          fadeInDuration: Duration(milliseconds: 500),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: vpH,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: vpH * 0.3,
                      ),
                      Container(
                        // height: vpH * 0.9,

                        width: vpW,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(vpW * 0.08),
                            topRight: Radius.circular(vpW * 0.08),
                          ),
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,

                              // offset: Offset(2, 2),

                              blurRadius: 1.0,

                              // spreadRadius: 1.0,
                            ),
                          ],
                        ),

                        // color: Colors.yellow,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: vpH * 0.03,
                            ),
                            ListTile(
                              leading: Container(
                                height: vpW * 0.15,
                                width: vpW * 0.15,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    'assets/img/NoPath.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text('Hosted BY'),
                              subtitle: Text('AMURoboclub'),
                            ),
                            Divider(
                              thickness: 2,
                              indent: vpW * 0.05,
                              endIndent: vpW * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 12),
                              child: Text(
                                widget.eventinfo.eventName != null
                                    ? widget.eventinfo.eventName
                                    : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: vpH * 0.04),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: vpH * 0.06,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          height: vpH * 0.05,
                                        ),
                                        Icon(
                                          Icons.map,
                                          size: vpH * 0.06,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: vpH * 0.07,
                                          width: 1,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                        SizedBox(
                                          height: vpH * 0.04,
                                        ),
                                        Container(
                                          height: vpH * 0.07,
                                          width: 1,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(widget.eventinfo.date),
                                          subtitle: Text(
                                              widget.eventinfo.startTime != null
                                                  ? widget.eventinfo.startTime +
                                                      '-' +
                                                      widget.eventinfo.endTime
                                                  : ""),
                                        ),

                                        // SizedBox(

                                        //   height: vpH * 0.02,

                                        // ),

                                        ListTile(
                                          title: Text("Get Direction"),
                                          subtitle: Text(
                                              widget.eventinfo.place != null
                                                  ? widget.eventinfo.place
                                                  : ""),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 12),
                              child: Text(
                                "Event Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: vpH * 0.03),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 12,
                                right: 15,
                              ),
                              child: Text(
                                widget.eventinfo.details,
                                style: TextStyle(fontSize: vpH*0.022),
                              ),
                            ),
                            SizedBox(
                              height: vpH * 0.15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: vpH * 0.025,
                left: vpW * 0.01,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: widget.eventinfo.regFormLink.isNotEmpty
            ? BottomSheet(
                backgroundColor: Colors.transparent,
                onClosing: () {},
                builder: (context) => Container(
                  height: vpH * 0.1,
                  width: vpW,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      launch(widget.eventinfo.regFormLink);
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: vpH * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                height: 0,
              ),
      ),
    );
  }
}
