import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/event.dart';
import 'package:roboclub_flutter/screens/show_event_screen.dart';

class FeaturedEventCard extends StatefulWidget {
  final Event featuredEvent;
  FeaturedEventCard({Key key, this.featuredEvent}) : super(key: key);

  @override
  _FeaturedEventCardState createState() => _FeaturedEventCardState();
}

class _FeaturedEventCardState extends State<FeaturedEventCard> {
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ShowEventScreen(eventinfo: widget.featuredEvent)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8.0,
          child: Container(
            height: vpH * 0.32,
            width: vpW * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _colors['card'],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: widget.featuredEvent.posterURL.isEmpty
                          ? Container(
                              height: vpH * 0.18,
                              width: vpW * 0.6,
                              child: SvgPicture.asset(
                                  'assets/illustrations/events.svg',
                                  fit: BoxFit.contain))
                          : Container(
                              height: vpH * 0.18,
                              width: vpW * 0.6,
                              child: CachedNetworkImage(
                                imageUrl: widget.featuredEvent.posterURL,
                                fadeInCurve: Curves.easeIn,
                                fadeInDuration: Duration(milliseconds: 500),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: Text(
                        widget.featuredEvent.eventName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.featuredEvent.place,
                        overflow: TextOverflow.ellipsis,
                        style: _textstyle['location'],
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: vpH * 0.035,
                    width: vpH * 0.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(0),
                      ),
                      color: _colors['label'],
                    ),
                    child: Center(
                      child: Text(
                        'Featured',
                        style: _textstyle['label'],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: vpH * 0.14,
                  child: PhysicalModel(
                    color: Colors.transparent,
                    // shadowColor: Colors.red,
                    elevation: 5.0,
                    child: Container(
                      // height: vpH * 0.04,
                      // width: vpH * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 4),
                        child: Center(
                          child: Text(
                            widget.featuredEvent.date,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: vpH * 0.015),
                          ),
                        ),
                      ),
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
