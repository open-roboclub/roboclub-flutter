import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/team2.dart';
import '../helper/dimensions.dart';

class Team2Screen extends StatefulWidget {
  @override
  _Team2ScreenState createState() => _Team2ScreenState();
}

class _Team2ScreenState extends State<Team2Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
     var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:Color(0xFFFFFFFF),
        key: _scaffoldKey,  
        drawer: appdrawer(context, page: "Faculty Team"),
        appBar: appBar(
          context,
          strTitle: "FACULTY TEAM",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: vpH * 0.005,
                
              ),
              Container(
                height: vpH * 0.9,
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Team2Card();
                        },
                      )
                    : Center(
                        child: Text('No Members Yet'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
