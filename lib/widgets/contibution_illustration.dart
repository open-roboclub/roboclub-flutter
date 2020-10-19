import 'package:flutter/material.dart';
import '../helper/dimensions.dart';

class ContriIllustrationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return  Padding(
          padding: EdgeInsets.all(25.0),
          child: Container(
            height: vpH * 0.15,
            width: vpW * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
        child: Column(
          children:[
            Padding(padding: EdgeInsets.all(15.0),
            child: Text("We are because of you!!", style:TextStyle(fontWeight: FontWeight.bold,color: Colors.orange[300],decoration: TextDecoration.underline,)),
            ),
            Padding(padding: EdgeInsets.all(15.0),
            child: Text("Thank you for all the people who contributed in making AMURoboclub what it is today. We couldn't have reached this place without your support."),
            ),
            Padding(padding: EdgeInsets.all(15.0),
            child: Image.asset('assets/img/contri.png'),) 
          ]
        ),
        
          ),
        );
  }
}