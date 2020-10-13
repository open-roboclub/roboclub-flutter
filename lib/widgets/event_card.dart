import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
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
              color: Colors.black54,
              // offset: Offset(2, 2),
              blurRadius: 1.0,
              // spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(),
      ),
    );
  }
}
