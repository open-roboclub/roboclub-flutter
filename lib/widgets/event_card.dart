import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: vpH * 0.15,
        width: vpW * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 8),
              blurRadius: 1.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: vpH * 0.15,
                width: vpW * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/img/placeholder.jpg',
                    fit: BoxFit.cover,
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
                      "RoboRace",
                      overflow: TextOverflow.ellipsis,
                      style: _titlestyle,
                    ),
                    Text(
                      "Thu, Oct 10 at 2:00 PM",
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
    );
  }
}
