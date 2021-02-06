import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/team.dart';
import 'package:roboclub_flutter/services/team.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/teams_card.dart';
import '../helper/dimensions.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Team> teamsList = [];

  @override
  void initState() {
    TeamService().fetchTeams().then((teamList) {
      setState(() {
        teamsList = teamList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Teams"),
        appBar: appBar(
          context,
          strTitle: "TEAMS",
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
                        itemCount: teamsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return TeamCard(
                            team: teamsList[index],
                          );
                        },
                      )
                    : Center(
                        child: Text('No Teams Yet'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
