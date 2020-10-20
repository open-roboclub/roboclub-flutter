import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';

class CompletedProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define
  
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.020);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:40.0,vertical: 20.0),
      child: Container(
        height: vpH * 0.20,
        width: vpW * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor, 
        ),
        child: Stack(
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
            Positioned(
              bottom: 0,
              left: vpW * 0.075,
              child: Container(
                height: vpH * 0.13,
                width: vpH * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    // offset: Offset(2, 2),
                    blurRadius: 1.0,
                    // spreadRadius: 1.0,
                  ),
                ],
                  gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey[200],
                    Colors.grey[200],
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Padding(padding: EdgeInsets.all(10.0),
                    child:Text("Project Name ",
                    overflow: TextOverflow.ellipsis,
                    style: _titlestyle)
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:Padding(
                        padding: EdgeInsets.all(10.0),
                        child:FlatButton(
                          color: Colors.orange[400],
                          child: Text("View",style: TextStyle(fontSize:15.0,)),
                          textColor: Colors.white,
                        onPressed: (){},) 
                       
                        )
                     ) 
                  ],)
                ),
              ),
          
          ],
        ),
      ),
    );
  }
}
