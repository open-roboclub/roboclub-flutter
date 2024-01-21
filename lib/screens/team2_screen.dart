import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/screens/profile.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/team2.dart';
import '../helper/dimensions.dart';

class Team2Screen extends StatefulWidget {
  final List<dynamic> members;
  final String title;

  const Team2Screen({Key? key, required this.members, required this.title})
      : super(key: key);
  @override
  _Team2ScreenState createState() => _Team2ScreenState();
}

class _Team2ScreenState extends State<Team2Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late ModelUser user;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  late double _position;

  @override
  void initState() {
    _position = 40;
    widget.members.sort((a, b) => a['name'].compareTo(b['name']));
    widget.members.sort((a, b) => a['rank'].compareTo(b['rank']));
    super.initState();
  }

  void scrollToItem() {
    _scrollController.animateTo(_position,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  void updateProfile(ModelUser updatedUser) {
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
    var _height = 3 * (vpH * 0.036);
    var _verticalPadding = 8.0;
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
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          for (int index = 0;
                              index < widget.members.length;
                              index++)
                            GestureDetector(
                              onTap: () async {
                                if (widget.members[index]['uid'] == '-1') {
                                  Fluttertoast.showToast(
                                      // backgroundColor: Colors.pink,
                                      msg: "Profile does not exist!");
                                  return;
                                }
                                final FirebaseFirestore _firestore =
                                    FirebaseFirestore.instance;
                                setState(() {
                                  _isLoading = true;
                                });

                                DocumentSnapshot snap = await _firestore
                                    .collection('/users')
                                    .doc(widget.members[index]['uid'])
                                    .get();
                                print(widget.members[index]['uid']);
                                // if (snap.data() == null) {}
                                user = ModelUser.fromMap(
                                    snap.data() as Map<String, dynamic>);
                                setState(() {
                                  _isLoading = false;
                                  _position =
                                      index * (_height + 2 * _verticalPadding);
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      viewMode: true,
                                      member: user,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    scrollToItem();
                                  });
                                });
                              },
                              child: Team2Card(
                                member: widget.members[index],
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
