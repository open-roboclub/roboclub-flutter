import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roboclub_flutter/models/team.dart';
import 'package:roboclub_flutter/services/team.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/team_card.dart';
import '../helper/dimensions.dart';

class TeamScreen extends StatelessWidget {
  TeamScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TeamService _teamController = Get.put(TeamService());

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
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
        body: Obx(
          () => _teamController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: vpH * 0.005,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _teamController.teamsList.length,
                        itemBuilder: (context, index) {
                          return TeamCard(
                            team: _teamController.teamsList[index],
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
