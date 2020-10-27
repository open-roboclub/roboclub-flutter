import 'package:flutter/material.dart';
import 'package:roboclub_flutter/screens/team2_screen.dart';
import '../helper/dimensions.dart';

class TeamCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var _style = TextStyle(fontSize:vpH*0.05, fontWeight: FontWeight.bold );
    return  GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Team2Screen()),
          );
        },
        child:Padding(
          padding: EdgeInsets.all(20.0),
          child: 
          Stack(
          children: [
            Container(
               height: vpH * 0.15,
               width: vpW * 0.90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/img/placeholder.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              
            ),
            Container(
                height: vpH * 0.15,
                width: vpW * 0.90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xD9FFFFFF).withOpacity(0.5),
                ),
                child:
                  Center(
                  child:Text("Faculty",
                   style:_style, ),
                 
                  ),
              ),
                
          ],
        ),
      ),
      );
  }
}