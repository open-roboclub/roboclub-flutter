import 'package:flutter/material.dart';
import '../helper/dimensions.dart';

class ContriCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);
    return  Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            height: vpH * 0.15,
            width: vpW * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[200],
                  blurRadius: 5.0,
                  offset: Offset(0.0, 0.75)
                ),
              ],
             ),
            child:Column(
              children: [
              Padding(padding: EdgeInsets.all(10.0),
              child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child:CircleAvatar(
                  radius:vpH*0.028,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: vpH*0.026,
                    backgroundImage: AssetImage('assets/img/placeholder.jpg'),
                  ),
                )
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal:vpW*0.020,vertical:vpH*0.005),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "La'chef",
                          overflow: TextOverflow.ellipsis,
                          style: _titlestyle,
                        ),
                        Text(
                          "-Contibuted to",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize:vpH*0.015),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child:Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Contribution",
                   overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize:vpH*0.018),
                  ),
                ),
            ),
            ],
            ),
             ),
             );
  }
}