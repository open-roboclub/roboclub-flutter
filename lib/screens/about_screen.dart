import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "About us"),
        appBar: appBar(
          context,
          strTitle: "About Us",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: CustomScrollView(
    slivers: <Widget>[
      // SliverAppBar(
      //   // title: Text('SliverAppBar'),
      //   backgroundColor: Colors.green,
      //   expandedHeight: vpH*0.02,
      //   flexibleSpace: FlexibleSpaceBar(
          
      //   ),
      // ),
      SliverFixedExtentList(
        itemExtent: vpH*0.18,
        delegate: SliverChildListDelegate(
          [
            Container(color: Colors.red),
            Container(color: Colors.purple),
            Container(color: Colors.green),
            Container(color: Colors.orange),
            Container(color: Colors.yellow),
            Container(color: Colors.pink),
          ],
        ),
      ),
    ],
)
      ),
    );
  }
}
