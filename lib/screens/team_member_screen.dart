import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/screens/profile.dart';
import 'package:roboclub_flutter/services/team.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/team_member_card.dart';
import '../helper/dimensions.dart';

class TeamMemberScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TeamService _teamController = Get.find();
  void updateProfile(ModelUser updatedUser) {
    Navigator.push(
      Get.context!,
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
    _teamController.members = Get.arguments['members'];
    _teamController.title = Get.arguments['title'];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Faculty Team"),
        appBar: appBar(
          context,
          strTitle: _teamController.title,
          isDrawer: false,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: Column(
          children: [
            SizedBox(
              height: vpH * 0.005,
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (int index = 0;
                      index < _teamController.members.length;
                      index++)
                    GestureDetector(
                      onTap: () async {
                        if (_teamController.members[index]['uid'] == '-1') {
                          Fluttertoast.showToast(
                              msg: "Profile does not exist!");
                          return;
                        }
                        final FirebaseFirestore _firestore =
                            FirebaseFirestore.instance;

                        Get.dialog(
                          Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );
                        DocumentSnapshot snap = await _firestore
                            .collection('/users')
                            .doc(_teamController.members[index]['uid'])
                            .get();
                        print(_teamController.members[index]['uid']);
                        ModelUser user = ModelUser.fromMap(
                            snap.data() as Map<String, dynamic>);
                        Get.back();
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
                      child: TeamMemberCard(
                        member: _teamController.members[index],
                        callback: updateProfile,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
