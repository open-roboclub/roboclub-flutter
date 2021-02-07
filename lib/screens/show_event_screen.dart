import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';

class ShowEventScreen extends StatefulWidget {
  

  final Event eventinfo;

  ShowEventScreen({Key key, this.eventinfo}) : super(key:key);
  
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
              Container(
                height: vpH * 0.35,
                width: vpW,
                child:  widget.eventinfo.posterURL =="" 
                    ? Image.asset('assets/img/placeholder.jpg',fit: BoxFit.cover,)
                    :Image.network(
                      widget.eventinfo.posterURL ,
                      fit: BoxFit.cover,
                    )
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                top: drag ? vpH * 0.1 : vpH * 0.3,
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    setState(() {
                      drag = !drag;
                    });
                  },
                  child: Container(
                    height: vpH * 0.9,
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
                            widget.eventinfo.eventName!=null ? widget.eventinfo.eventName : "",
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
                                      subtitle: Text(widget.eventinfo.startTime!=null ?widget.eventinfo.startTime + '-' + widget.eventinfo.endTime : ""),
                                    ),
                                    // SizedBox(
                                    //   height: vpH * 0.02,
                                    // ),
                                    ListTile(
                                      title: Text("Get Direction"),
                                      subtitle: Text(widget.eventinfo.place!= null ? widget.eventinfo.place: ""),
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
                          padding: const EdgeInsets.only(left: 15, top: 12),
                          child: Text(
                            widget.eventinfo.details,
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
