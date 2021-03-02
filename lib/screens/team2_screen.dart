import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/screens/profile.dart';
import 'package:roboclub_flutter/services/team.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/team2.dart';
import '../helper/dimensions.dart';

class Team2Screen extends StatefulWidget {
  final List<dynamic> members;
  final String title;

  const Team2Screen({Key key, this.members, this.title}) : super(key: key);
  @override
  _Team2ScreenState createState() => _Team2ScreenState();
}

class _Team2ScreenState extends State<Team2Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  List<User> membersList = [];

  @override
  void initState() {
    widget.members.sort((a, b) => a['rank'].compareTo(b['rank']));
    List<User> tempList = [];
    TeamService().getTeamMembers(widget.members).then((value) {
      tempList = value;
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          rankMembers(tempList);
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  void rankMembers(List<User> tempList) {
    for (int i = 0; i < widget.members.length; i++) {
      for (int j = 0; j < tempList.length; j++) {
        if (widget.members[i]['email'] == tempList[j].email) {
          membersList.add(tempList[j]);
          break;
        }
      }
    }
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
          strTitle: widget.title,
          isDrawer: false,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: vpH * 0.005,
                    ),
                    Container(
                      height: vpH * 0.9,
                      width: vpW,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: membersList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      viewMode: true,
                                      member: membersList[index],
                                    ),
                                  )),
                              child: Team2Card(member: membersList[index]));
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
