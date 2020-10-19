import 'package:flutter/material.dart';
import '../helper/dimensions.dart';

class ContriCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return  Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            height: vpH * 0.15,
            width: vpW * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[200],
                  // offset: Offset(2, 2),
                  blurRadius: 5.0,
                  // spreadRadius: 1.0,
                  offset: Offset(0.0, 0.75)
                ),
              ],
        ),
          ),
        );
  }
}