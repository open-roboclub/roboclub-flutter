import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';

class FeaturedEventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: vpH * 0.3,
        width: vpW * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
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
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/img/placeholder.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Event name',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Place',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
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
                  color: Theme.of(context).splashColor,
                ),
                child: Center(
                  child: Text(
                    'Ongoing',
                    style: Theme.of(context).primaryTextTheme.subtitle1,
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
