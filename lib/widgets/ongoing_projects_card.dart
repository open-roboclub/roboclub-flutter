import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/screens/project_info.dart';
import '../helper/dimensions.dart';

class OngoingProjectCard extends StatefulWidget {


  final Project ongoingProject;
  OngoingProjectCard({Key key, this.ongoingProject}): super(key: key);

  @override
  _OngoingProjectCardState createState() => _OngoingProjectCardState();
}
class _OngoingProjectCardState extends State<OngoingProjectCard> {
  @override
  Widget build(BuildContext context) {

    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle = TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);
    return  GestureDetector(
      onTap:(){ 
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => ProjectInfo(project:widget.ongoingProject)
          ),
        );
      },
      child: 
      Padding(
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
                spreadRadius: 1.0,
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
                    child: ClipRRect(
                      child: Container(
                        height: vpH* 0.038,
                        width: vpW*0.080,
                        child: widget.ongoingProject.projectImg.length ==0 
                        ? Image.asset('assets/img/placeholder.jpg',fit: BoxFit.cover,)
                        :Image.network(
                          widget.ongoingProject.projectImg[0] ,
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal:vpW*0.050,vertical:vpH*0.005),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ongoingProject.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: _titlestyle,
                          ),
                          Text(
                            widget.ongoingProject.date ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize:vpH*0.018),
                          ),  
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child:Align(
                      alignment: Alignment.bottomRight,
                      child:Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                        // CircleAvatar(
                        //   radius: vpH* 0.028,
                        //   backgroundColor: Color(0xFFFF9C01),
                        //   child: 
                        //   CircleAvatar(
                        //     radius: vpH*0.026,
                        //     backgroundImage: AssetImage('assets/img/placeholder.jpg'),
                        //   ),
                        // )
                        Container(
                          width: vpW*0.15,
                          height: vpH*0.055,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(26)),
                          child: Padding(padding: EdgeInsets.only(top:vpH*0.012 ,left: vpW*0.01),child:
                            Text( widget.ongoingProject.progress== "" ? "" :
                              widget.ongoingProject.progress,style: TextStyle(fontSize: vpH*0.02),
                            ),
                          ),
                        ),
                        ),
                      )
                    ),
                
                ],
              ),
            ),
          ],),
        ),
      ),
    );
  }
}