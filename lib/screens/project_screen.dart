import 'package:flutter/material.dart';
import 'package:roboclub_flutter/forms/project.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/services/project.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/comp_projects_card.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/ongoing_projects_card.dart';
import '../helper/dimensions.dart';

class ProjectScreen extends StatefulWidget {

  final Project project;
  const ProjectScreen({Key key, this.project}) : super(key: key);
  
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Project> projectsList = [];
  

  @override
  void initState() {
    ProjectService().fetchProjects().then((value) {
      projectsList = value;
    });
    super.initState();
  }

  bool _ongoingPressed = false;
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    var textStyle =
        TextStyle(fontSize: vpH * 0.018, fontWeight: FontWeight.bold);
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
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Text(
                          'Completed',
                          style: textStyle,
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
                        child: Text('Ongoing', style: textStyle),
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
                child: _ongoingPressed
                      ? 
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: projectsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return OngoingProjectCard(project: projectsList[index],);
                        },
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: projectsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return CompletedProjectCard(project: projectsList[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
         floatingActionButton: FloatingActionButton(
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
        ),
      ),
    );
  }
}
