import 'package:flutter/material.dart';
import 'package:roboclub_flutter/forms/contribution.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/team.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/member_card.dart';

class RegMembersScreen extends StatefulWidget {
  const RegMembersScreen({Key? key}) : super(key: key);

  @override
  _RegMembersScreenState createState() => _RegMembersScreenState();
}

class _RegMembersScreenState extends State<RegMembersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  List<Team> membersList = [];

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
          drawer: appdrawer(context, page: "Registered Members"),
          appBar: appBar(
            context,
            strTitle: "MEMBERS",
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
                          itemCount: membersList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return MemberCard(
                              team: membersList[index],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ContributionForm();
                  },
                ),
              );
            },
            child: Icon(Icons.add),
          )),
    );
  }
}
