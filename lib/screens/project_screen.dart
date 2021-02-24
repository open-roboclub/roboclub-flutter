import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:roboclub_flutter/forms/project.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/services/project.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/comp_projects_card.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/ongoing_projects_card.dart';
import '../helper/dimensions.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // List<Project> ongoingProjectsList = [];
  // List<Project> complePedProjectsList = [];
  List<Project> projectsList = [];
  bool isLoading = true;

  @override
  void initState() {
    ProjectService().fetchProjects().then((value) {
      value.forEach((element) {
        DateTime _parsed = DateTime.parse(element.date);
        element.date = DateFormat('yMMMd').format(_parsed);
        projectsList.add(element);
      });

      // value.forEach((item) {
      //   print(item.progress);
      //   item.progress == ""
      //       ? ongoingProjectsList = value
      //       : complePedProjectsList = value;
      // }); // value.forEach((item) {
      //   print(item.progress);
      //   item.progress == ""
      //       ? ongoingProjectsList = value
      //       : complePedProjectsList = value;
      // });

      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  bool _ongoingPressed = false;
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var textStyle =
        TextStyle(fontSize: vpH * 0.027, fontWeight: FontWeight.normal);
    User _user = Provider.of<UserProvider>(context).getUser;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Projects"),
        appBar: appBar(
          context,
          strTitle: "PROJECTS",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: vpW * 0.3,
                          child: Center(
                            child: Text(
                              'Completed',
                              style: textStyle,
                            ),
                          ),
                        ),
                        textColor:
                            !_ongoingPressed ? Colors.white : Colors.black,
                        color: !_ongoingPressed
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        onPressed: () => {
                          setState(() {
                            _ongoingPressed = false;
                          })
                        },
                      ),
                      SizedBox(
                        width: vpW * 0.01,
                      ),
                      FlatButton(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: vpW * 0.3,
                          child: Center(
                            child: Text(
                              'Ongoing',
                              style: textStyle,
                            ),
                          ),
                        ),
                        textColor:
                            _ongoingPressed ? Colors.white : Colors.black,
                        color: _ongoingPressed
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        onPressed: () => {
                          setState(() {
                            _ongoingPressed = true;
                          })
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: vpH * 0.005,
              ),
              Container(
                height: vpH * 0.8,
                width: vpW,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _ongoingPressed
                        ? projectsList.length == 0
                            ? Center(
                                child: Container(
                                  width: vpW * 0.7,
                                  height: vpH * 0.6,
                                  child: SvgPicture.asset(
                                    'assets/illustrations/project.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: projectsList.length,
                                itemBuilder: (context, index) {
                                  return OngoingProjectCard(
                                    ongoingProject: projectsList[index],
                                  );
                                },
                              )
                        : projectsList.length == 0
                            ? Center(
                                child: Container(
                                  width: vpW * 0.7,
                                  height: vpH * 0.6,
                                  child: SvgPicture.asset(
                                    'assets/illustrations/project.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: projectsList.length,
                                itemBuilder: (context, index) {
                                  return CompletedProjectCard(
                                    completedProject: projectsList[index],
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
        floatingActionButton: _user != null
            ? (_user.isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProjectForm();
                          },
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  )
                : null)
            : null,
      ),
    );
  }
}
