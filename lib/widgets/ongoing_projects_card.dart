import 'package:flutter/material.dart';
import '../helper/dimensions.dart';

class OngoingProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);
    return  Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            height: vpH * 0.13,
            width: vpW * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[200],
                  blurRadius: 5.0,
                  offset: Offset(0.0, 0.75)
                ),
              ],
             ),
             child:Column(children: [
             Padding(padding: EdgeInsets.all(15.0),
             child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: ClipRRect(
                  child: Container(
                    height: 40.0,
                    width: 40.0,
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
                    margin: EdgeInsets.symmetric(horizontal:20.0,vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Name",
                          overflow: TextOverflow.ellipsis,
                          style: _titlestyle,
                        ),
                        Text(
                          "Day, Date",
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                      ],
                    ),
                  ),
                ),
                 Flexible(
                  flex: 3,
                  child:Align(
                  alignment: Alignment.centerRight,
                  child:Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange[400],
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/img/placeholder.jpg'),
                    ),
                )
                    )
                    ),
                  ),
              ],
            ),
            ),
           
            ])
             )
             );
  }
}