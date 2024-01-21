import 'package:flutter/material.dart';

import 'package:roboclub_flutter/models/contributor.dart';
import '../helper/dimensions.dart';

// ignore: must_be_immutable
class ContriCard extends StatefulWidget {
  
  final Contributor contributor;
  ContriCard({Key? key, required this.contributor}): super(key: key);

  @override
  _ContriCardState createState() => _ContriCardState();
}

class _ContriCardState extends State<ContriCard> {
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    TextStyle _titlestyle = TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025);

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        width: vpW * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: Offset(0.0, 5),
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        radius: vpH * 0.028,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: vpH * 0.026,
                          backgroundColor: Colors.white,
                          backgroundImage: widget.contributor.representativeImg.isEmpty ? AssetImage('assets/img/money.png')
                            : NetworkImage(widget.contributor.representativeImg) as ImageProvider,
                        ),
                      )),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: vpW * 0.030, vertical: vpH * 0.005),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.contributor.name ,
                              style: _titlestyle,
                            ),
                          ),
                           Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: vpH * 0.0001)),
                          Text(
                            widget.contributor.date,
                            style: TextStyle(fontSize: vpH * 0.015),
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: vpH * 0.006)),
                          Text(
                            widget.contributor.description,

                            style: TextStyle(fontSize: vpH * 0.015),
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: vpW * 0.002, vertical: vpH * 0.005),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: vpW * 0.005, vertical: vpH * 0.010),
                          child: Container(
                            child: Text(
                              widget.contributor.amount ,
                              style: TextStyle(fontSize: vpH * 0.018),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
