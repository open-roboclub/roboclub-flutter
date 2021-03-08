import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  var vpH, vpW;
  List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(
          context,
          strTitle: "PlayList",
          isDrawer: false,
          isNotification: false,
        ),
        body: Container(),
      ),
    );
  }
}
