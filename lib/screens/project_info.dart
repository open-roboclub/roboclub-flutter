import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectInfo extends StatelessWidget {

final Project newProject;

const ProjectInfo({Key key, this.newProject}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    var vpH;
    var vpW;
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    var heading = TextStyle(fontSize: vpH*0.03,fontWeight:FontWeight.bold);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(
          context,
          strTitle: newProject.name ,
          isDrawer: false,
          isNotification: false,
        ),
        body: SingleChildScrollView(
        child:Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.03),
              child: Center(
                child:Container(
                  height: vpH * 0.20,
                  width: vpW * 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      'assets/img/placeholder.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),),
              Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.02,horizontal: vpW*0.05),
                child:Align(
                  alignment: Alignment.topLeft,
                  child:Text("Description",style: heading,),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.005,horizontal: vpW*0.05),
                child:Align(
                  alignment: Alignment.topLeft,
                  child:Text(newProject.description,style: TextStyle(fontSize: vpH*0.02),),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.02,horizontal: vpW*0.05),
                child:Align(
                  alignment: Alignment.topLeft,
                  child:Text("Team",style: heading,),
                ),
              ),
              Container(
                height: vpH * 0.25,
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(backgroundImage:  AssetImage('assets/img/placeholder.jpg'),),
                            title: Text("Member",style: TextStyle(color:Colors.black,fontSize: vpH*0.025),),);
                        },
                      )
                    : Center(
                        child: Text('No Members Yet'),
                      ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: vpH*0.03),
              child:Container(
                height: vpH * 0.09,
                width: vpW * 0.9,
                padding:  EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0XFF8C8C8C)),
                ),
                child:ListTile(
                  leading:Icon(Report.icon_ionic_md_document,color: Color(0XFF8C8C8C),),
                  title: Text("Report",style: TextStyle(color:Colors.black,fontSize: vpH*0.025,fontWeight: FontWeight.w500),),
                  subtitle: Text('pdf file'),
                  trailing: IconButton(
                    icon:Icon(Report.icon_ionic_md_open,color: Color(0XFFFF9C01),),
                    onPressed: () {  },
                  ),
                ),
              ),),
              
              Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.02,horizontal: vpW*0.05),
                child:Align(
                  alignment: Alignment.topLeft,
                  child:Text("Check out the project",style: heading,),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    launch(newProject.link);
                  },child:
              Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.02,horizontal: vpW*0.05),
                child:Align(
                  alignment: Alignment.topLeft,
                  child:Text("Github link",style: TextStyle(color:Color(0XFF707070),fontSize: vpH*0.02),),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  
  }

  
}