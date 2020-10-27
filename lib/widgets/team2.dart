import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import '../helper/dimensions.dart';

class Team2Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.030);
    return  Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            height: vpH * 0.13,
            width: vpW * 0.90,
            decoration: BoxDecoration(
              border: Border(
              bottom: BorderSide(width:vpH* 0.0016, color: Color(0xFF707070)),
              ),
              color: Colors.white,  
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
                  radius:vpH*0.040,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: vpH*0.032,
                    backgroundColor: Colors.white,
                    
                  ),
                )
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal:vpW*0.040),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          overflow: TextOverflow.ellipsis,
                          style: _titlestyle,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.006),
                          child:Text(
                          "Post",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize:vpH*0.018),
                        ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child:Align(
                  alignment: Alignment.topRight,
                  child:Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:IconButton(
                      icon: Icon(MyFlutterApp.edit),
                      color: Color(0xFFFF9C01),
                      iconSize: vpW * 0.060,
                      onPressed: (){}
                      ),
                    ),
                  )
                ),
              
                ],
              ),
              ),
           
            ],
            ),
             ),
             );
  }
}