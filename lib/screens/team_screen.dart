import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/team.dart';
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  List<Team> teamsList = [];

  @override
  void initState() {
    _firestore.collection('/teams').get().then((teamSnaps) {
      teamSnaps.docs.forEach((element) {
        if (teamsList.length == 0) {
          teamsList.add(Team.fromMap(element.data()));
        } else {
          teamsList.insert(1, Team.fromMap(element.data()));
        }
      });
      setState(() {
        _isLoading = false;
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
                        itemCount: teamsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return TeamCard(
                            team: teamsList[index],
                          );
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
