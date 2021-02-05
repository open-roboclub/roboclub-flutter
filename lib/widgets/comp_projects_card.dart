
import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/screens/project_info.dart';

class CompletedProjectCard extends StatefulWidget {


  final Project _completedProject;
  CompletedProjectCard(this._completedProject);

@override
_CompletedProjectCardState createState() => _CompletedProjectCardState();
}

class _CompletedProjectCardState extends State<CompletedProjectCard>{

  @override
  Widget build(BuildContext context) {
    
    // Define
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    TextStyle _titlestyle =TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: vpW * 0.090, vertical: vpH * 0.020),
      child: Container(
        height: vpH * 0.20,
        width: vpW * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Container(
              height: vpH * 0.15,
              width: vpW * 0.818,
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
              left: vpW * 0.109,
              child: Container(
                  height: vpH * 0.16,
                  width: vpW * 0.60,
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
                  
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(widget._completedProject.name,
                              overflow: TextOverflow.ellipsis,
                              style: _titlestyle)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(vpH * 0.010),
                          child: FlatButton(
                            color: Color(0xFFFF9C01),
                            child: Text("View",
                                style: TextStyle(
                                  fontSize: vpH * 0.015,
                                )),
                            textColor: Colors.white,

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProjectInfo(project:widget._completedProject)),
                              );
                            },

                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}