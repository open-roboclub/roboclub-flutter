import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectInfo extends StatefulWidget {
  final Project project;

  ProjectInfo({Key key, this.project}) : super(key: key);

  @override
  _ProjectInfoState createState() => _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  final _formKey = GlobalKey<FormState>();

  var vpH;
  var vpW;

  int _currprogress;

  @override
  void initState() {
    _currprogress =
        widget.project.progress == "" ? 0 : int.parse(widget.project.progress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    var heading = TextStyle(fontSize: vpH * 0.03, fontWeight: FontWeight.bold);
    User _user = Provider.of<UserProvider>(context).getUser;

    Future<void> updateProgress() async {
      String id;
      Firestore.instance.collection('projects').getDocuments().then((projects) {
        projects.documents.forEach((project) {
          if (project['name'] == widget.project.name) {
            id = project.documentID;
            return Firestore.instance
                .collection('projects')
                .document(id)
                .updateData({'progress': _currprogress.toString()})
                .then((value) => print("Progress Updated"))
                .catchError(
                    (error) => print("Failed to update progress: $error"));
          }
        });
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: appBar(
          context,
          strTitle: widget.project.progress == "100"
              ? "Completed Project"
              : "Ongoing Project",
          isDrawer: false,
          isNotification: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: vpH * 0.03, horizontal: vpW * 0.05),
                child: Container(
                  child: Text(
                    widget.project.name,
                    style: heading,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: vpH * 0.03),
                child: Center(
                    child: widget.project.projectImg.length == 0
                        ? Container(
                            height: vpH * 0.20,
                            width: vpW * 0.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: SvgPicture.asset('assets/illustrations/project.svg',fit: BoxFit.contain),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                CarouselSlider.builder(
                                  itemCount: widget.project.projectImg.length,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                        height: vpH * 0.20,
                                        width: vpW * 0.9,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.network(
                                              widget.project.projectImg[index]),
                                        ));
                                  },
                                ),
                              ])),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: vpW * 0.05),
                child: widget.project.progress.isEmpty ||
                        int.parse(widget.project.progress) < 100
                    ? Column(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: vpH * 0.01),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Progress",
                              style: heading,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              _currprogress.toString(),
                              style: TextStyle(
                                  fontSize: vpH * 0.04,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFF9C01)),
                            ),
                            Text("%",
                                style: TextStyle(
                                    fontSize: vpH * 0.03,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        _user.isAdmin
                            ? Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackShape:
                                            RoundedRectSliderTrackShape(),
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 10.0),
                                        thumbColor: Colors.deepPurple[700],
                                        overlayColor: Colors.red.withAlpha(32),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 28.0),
                                        tickMarkShape:
                                            RoundSliderTickMarkShape(),
                                        valueIndicatorShape:
                                            PaddleSliderValueIndicatorShape(),
                                        valueIndicatorColor:
                                            Colors.deepPurpleAccent,
                                        valueIndicatorTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _currprogress.toDouble(),
                                        min: 0,
                                        max: 100,
                                        label: '$_currprogress',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            _currprogress = newValue.round();
                                          });
                                        },
                                      ),
                                    ),
                                    FlatButton(
                                      color: Color(0xFFFF9C01),
                                      child: Container(
                                        width: vpW * 0.32,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Update Progress",
                                            style: TextStyle(
                                              fontSize: vpH * 0.018,
                                            ),
                                          ),
                                        ),
                                      ),
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          await updateProgress();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Container(
                                                  height: vpH * 0.035,
                                                  child: Image.asset(
                                                      'assets/img/success-mark.png'),
                                                ),
                                                content: Text(
                                                  "Progress updated !!",
                                                  style: TextStyle(
                                                      fontSize: vpH * 0.03),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ])
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: vpH * 0.01),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Completed On",
                                style: heading,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: vpH * 0.005,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.project.date,
                                style: TextStyle(fontSize: vpH * 0.02),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: vpH * 0.02, horizontal: vpW * 0.05),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Description",
                    style: heading,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: vpH * 0.005, horizontal: vpW * 0.05),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.project.description,
                    style: TextStyle(fontSize: vpH * 0.02),
                  ),
                ),
              ),
              widget.project.fileUrl.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: vpH * 0.02),
                      child: Container(
                        width: vpW * 0.9,
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFF8C8C8C)),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Report.icon_ionic_md_document,
                            color: Color(0XFF8C8C8C),
                          ),
                          title: Text(
                            "Report",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: vpH * 0.025,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text('pdf file'),
                          trailing: IconButton(
                            icon: Icon(
                              Report.icon_ionic_md_open,
                              color: Color(0XFFFF9C01),
                            ),
                            onPressed: () {
                              launch(widget.project.fileUrl);
                            },
                          ),
                        ),
                      ),
                    ),
              widget.project.link != ""
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: vpH * 0.008,
                              top: vpH * 0.02,
                              left: vpW * 0.05,
                              right: vpW * 0.05),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Check out the project",
                              style: heading,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch(widget.project.link);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: vpH * 0.02, horizontal: vpW * 0.05),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.project.link,
                                style: TextStyle(
                                    color: Colors.blue, fontSize: vpH * 0.02),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: vpH * 0.02, horizontal: vpW * 0.05),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Team",
                    style: heading,
                  ),
                ),
              ),
              Container(
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: IconButton(
                              icon: Icon(
                                SocialMedia.linkedin,
                                color: Colors.blue[700],
                              ),
                              onPressed: null,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage:
                                  AssetImage('assets/img/teamMember.png'),
                            ),
                            title: Text(
                              "Member",
                              style: TextStyle(
                                  color: Colors.black, fontSize: vpH * 0.025),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('No Members Yet'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
