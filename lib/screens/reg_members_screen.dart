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
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocNode = FocusNode();

  bool _isLoading = true;
  List<Member> membersList = [];
  List<Member> searchResult = [];

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

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    membersList.forEach((memberDetail) {
      if (memberDetail.name.toLowerCase().contains(text.toLowerCase()))
        searchResult.add(memberDetail);
    });

    setState(() {});
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
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: TextFormField(
                              autofocus: false,
                              controller: searchController,
                              focusNode: searchFocNode,
                              onChanged: onSearchTextChanged,
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Search by name',
                                border: InputBorder.none,
                                suffixIcon: searchFocNode.hasFocus
                                    ? IconButton(
                                        onPressed: () {
                                          searchController.clear();
                                          onSearchTextChanged('');
                                          searchFocNode.unfocus();
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                        ),
                                      )
                                    : null,
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    searchFocNode.requestFocus();
                                  },
                                  icon: Icon(
                                    Icons.search,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: vpH * 0.9,
                          width: vpW,
                          child: searchController.text.isNotEmpty
                              ? searchResult.length != 0
                                  ? new ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: searchResult.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return MemberCard(
                                          member: searchResult[index],
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off_rounded,
                                            size: 80,
                                          ),
                                          Text(
                                            "No Result Found",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ],
                                      ),
                                    )
                              : ListView.builder(
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
            floatingActionButton: showButton
                ? FloatingActionButton(
                    onPressed: () async {
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Membership();
                          },
                        ),
                      );
                      if (result != null) {
                        if (result["success"]) {
                          setState(() {
                            _isLoading = true;
                            membersList.clear();
                            MemberService().fetchMembers().then((value) {
                              addMemberList(value);
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          });
                        }
                      }
                    },
                    child: Icon(Icons.add),
                  )
                : null));
  }
}
