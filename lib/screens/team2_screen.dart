import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/services/team.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/team2.dart';
import '../helper/dimensions.dart';

class Team2Screen extends StatefulWidget {
  final List<dynamic> members;

  const Team2Screen({Key key, this.members}) : super(key: key);
  @override
  _Team2ScreenState createState() => _Team2ScreenState();
}

class _Team2ScreenState extends State<Team2Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<User> membersList = [];

  @override
  void initState() {
    TeamService().getTeamMembers(widget.members).then((value) {
      membersList = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
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
                        itemCount: membersList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Team2Card(member: membersList[index]);
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
