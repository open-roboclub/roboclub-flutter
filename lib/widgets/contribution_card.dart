import 'package:flutter/material.dart';

import 'package:roboclub_flutter/models/contributor.dart';
import '../helper/dimensions.dart';

// ignore: must_be_immutable
class ContriCard extends StatefulWidget {
  
  final Contributor _contributor;
  ContriCard(this._contributor);

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
        height: vpH * 0.18,
        width: vpW * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // color: Color(0xFF00000029),
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
                          backgroundImage:
                              AssetImage('assets/img/placeholder.jpg'),
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
                          Text(
                            widget._contributor.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: _titlestyle,
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: vpH * 0.006)),
                          Text(
                            widget._contributor.description ?? "",

                            // overflow: TextOverflow.ellipsis,
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
                          child: Text(
                            "\u20B9 " + widget._contributor.amount ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: vpH * 0.018),
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
