// import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/project.dart';
import 'package:roboclub_flutter/screens/project_info.dart';

class CompletedProjectCard extends StatefulWidget {
  final Project completedProject;
  CompletedProjectCard({Key? key, required this.completedProject}) : super(key: key);

  @override
  _CompletedProjectCardState createState() => _CompletedProjectCardState();
}

class _CompletedProjectCardState extends State<CompletedProjectCard> {
  @override
  Widget build(BuildContext context) {
    // Define
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: vpH * 0.023);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: vpW * 0.090, vertical: vpH * 0.020),
      child: Container(
        height: vpH * 0.2,
        width: vpW * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          clipBehavior: Clip.none,
           children: [
            Container(
              height: vpH * 0.15,
              width: vpW * 0.818,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: widget.completedProject.projectImg.length == 0
                      ? Image.asset(
                          'assets/img/projectPlaceholder.jpg',
                          fit: BoxFit.fill,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.completedProject.projectImg[0],
                          fadeInCurve: Curves.easeIn,
                          fadeInDuration: Duration(milliseconds: 500),
                          fit: BoxFit.cover,
                        )),
            ),
            Positioned(
              bottom: vpH * -0.008,
              left: vpW * 0.08,
              child: Container(
                height: vpH * 0.14,
                width: vpW * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[350]!.withOpacity(0.96),
                      // offset: Offset(2, 2),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child:Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: vpH * 0.05,
                          child: Text(
                            widget.completedProject.name,
                            style: _titlestyle,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(vpH * 0.010),
                          child: PhysicalModel(
                            color: Colors.transparent,
                            shadowColor: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            elevation: 8.0,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                onSurface: Colors.white,
                              primary: Color(0xFFFF9C01),
                              ),
                              child: Container(
                                width: vpW * 0.12,
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                    fontSize: vpH * 0.024,
                                    fontWeight: FontWeight.w500
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectInfo(
                                          project: widget.completedProject)),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
