import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/screens/profile.dart';
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
  User user;
  bool _isLoading = false;
  @override
  void initState() {
    widget.members.sort((a, b) => a['rank'].compareTo(b['rank']));
    super.initState();
  }

  void updateProfile(User updatedUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          viewMode: true,
          member: updatedUser,
        ),
      ),
    );
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
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          for (int i = 0; i < widget.members.length; i++)
                            GestureDetector(
                              onTap: () async {
                                final Firestore _firestore = Firestore.instance;
                                setState(() {
                                  _isLoading = true;
                                });
                                DocumentSnapshot snap = await _firestore
                                    .collection('/users')
                                    .document(widget.members[i]['uid'])
                                    .get();
                                user = User.fromMap(snap.data);
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      viewMode: true,
                                      member: user,
                                    ),
                                  ),
                                );
                              },
                              child: Team2Card(
                                member: widget.members[i],
                                callback: updateProfile,
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
