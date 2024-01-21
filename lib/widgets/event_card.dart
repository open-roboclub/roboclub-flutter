import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';
import 'package:roboclub_flutter/screens/show_event_screen.dart';

class EventCard extends StatefulWidget {
  final Event event;
  EventCard({Key ?key, required this.event}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowEventScreen(eventinfo: widget.event)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8.0,
          child: Container(
            height: vpH * 0.15,
            width: vpW * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Hero(
                    tag: widget.event.eventName,
                    child: Container(
                      height: vpH * 0.15,
                      width: vpW * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: widget.event.posterURL == ""
                            ? SvgPicture.asset(
                                'assets/illustrations/events.svg',
                                fit: BoxFit.contain)
                            : CachedNetworkImage(
                                imageUrl: widget.event.posterURL,
                                fadeInCurve: Curves.easeIn,
                                fadeInDuration: Duration(milliseconds: 500),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.eventName != null
                              ? widget.event.eventName
                              : "",
                          overflow: TextOverflow.ellipsis,
                          style: _titlestyle,
                        ),
                        Text(
                          widget.event.date != null ? widget.event.date : "",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "AMURoboclub",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
