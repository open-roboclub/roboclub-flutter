import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';

class FeaturedEventCard extends StatelessWidget {
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: vpH * 0.32,
        width: vpW * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _colors['card'],
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              // offset: Offset(2, 2),
              blurRadius: 1.0,
              // spreadRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/img/placeholder.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    'Event name',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Place',
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
                    'Ongoing',
                    style: _textstyle['label'],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
