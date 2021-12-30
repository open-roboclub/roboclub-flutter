import 'package:flutter/material.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/forms/membership.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/member.dart';
import 'package:roboclub_flutter/services/member.dart';
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

  bool _isLoading = true;
  List<Member> membersList = [];

  bool showButton = false;
  void initState() {
     Remoteconfig().showMmebershipOpen().then((value) {
       setState(() {
         showButton = value;
       });
     });
    MemberService().fetchMembers().then((value) {
      addMemberList(value);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  void addMemberList(List<Member> members) {
    members.forEach((item) {
      membersList.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
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
                              member: membersList[index],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
          floatingActionButton: showButton? FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return  Membership();
                  },
                ),
              ).then((value) {
                setState(() {
                  _isLoading=  true;
                  membersList.clear();
                  MemberService().fetchMembers().then((value) {
                    addMemberList(value);
                    setState(() {
                      _isLoading = false;
                    });
                  });
                });
              } );
            },
            child: Icon(Icons.add),
          ): null )
    );
  }
}
