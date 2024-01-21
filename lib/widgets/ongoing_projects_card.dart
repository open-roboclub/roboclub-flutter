import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/screens/project_info.dart';
import '../helper/dimensions.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OngoingProjectCard extends StatefulWidget {
  final Project ongoingProject;
  final void Function(Project, String) callback;
  final String date;
  OngoingProjectCard({Key? key, required this.ongoingProject, required this.callback, this.date=""})
      : super(key: key);

  @override
  _OngoingProjectCardState createState() => _OngoingProjectCardState();
}

class _OngoingProjectCardState extends State<OngoingProjectCard> {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProjectInfo(
                  project: widget.ongoingProject, callback: widget.callback)),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: vpH * 0.16,
          width: vpW * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[50],
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey[200]!,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 0.75)),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        child: Container(
                            height: vpH * 0.038,
                            width: vpW * 0.080,
                            child: widget.ongoingProject.projectImg.length == 0
                                ? SvgPicture.asset(
                                    'assets/illustrations/project.svg',
                                    fit: BoxFit.contain)
                                : CachedNetworkImage(
                                    imageUrl:
                                        widget.ongoingProject.projectImg[0],
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: vpW * 0.050, vertical: vpH * 0.005),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.ongoingProject.name ,
                              overflow: TextOverflow.ellipsis,
                              style: _titlestyle,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: vpH * 0.005),
                              child: Text(
                                widget.ongoingProject.date ,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: vpH * 0.018),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: vpW * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: vpH * 0.045,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      backgroundImage: AssetImage(
                                          'assets/img/teamMember.png'),
                                    ),
                                  ),
                                  Align(
                                    widthFactor: vpW * 0.0004,
                                    child: Container(
                                      height: vpH * 0.045,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black,
                                        backgroundImage: AssetImage(
                                            'assets/img/teamMember.png'),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: vpH * 0.045,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      backgroundImage: AssetImage(
                                          'assets/img/teamMember.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircularPercentIndicator(
                          radius: vpH * 0.06,
                          lineWidth: vpW * 0.012,
                          animation: true,
                          percent: widget.ongoingProject.progress.isEmpty
                              ? 0.0
                              : int.parse(widget.ongoingProject.progress)
                                      .toDouble() /
                                  100, // Defaults to 0.5.
                          center: new Text(
                            widget.ongoingProject.progress.isEmpty
                                ? '0' + "%"
                                : widget.ongoingProject.progress.toString() +
                                    "%",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: vpH * 0.02),
                          ),

                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: (() {
                            if (widget.ongoingProject.progress.isEmpty) {
                              return Colors.grey;
                            } else if (int.parse(
                                        widget.ongoingProject.progress) <
                                    26 &&
                                int.parse(widget.ongoingProject.progress) > 0) {
                              return Colors.red;
                            } else if (int.parse(
                                        widget.ongoingProject.progress) <
                                    51 &&
                                int.parse(widget.ongoingProject.progress) >
                                    25) {
                              return Colors.orange;
                            } else if (int.parse(
                                        widget.ongoingProject.progress) <
                                    76 &&
                                int.parse(widget.ongoingProject.progress) >
                                    50) {
                              return Colors.yellow[600];
                            } else {
                              return Colors.green;
                            }
                          }()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
