import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';
import 'profile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var vpH;
  var vpW;
  bool _show = false;

  Widget _button(String title, BuildContext context, bool isGoogle) {
    return FlatButton(
      color: isGoogle ? Color(0xffFF9C01) : Colors.white,
      textColor: !isGoogle ? Color(0xffFF9C01) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      onPressed: () {
        setState(() {
          _show = true;
        });
      },
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(35.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          isGoogle
              ? Image.asset(
                  'assets/img/google_icon.png',
                  fit: BoxFit.fitHeight,
                  height: vpH * 0.06,
                )
              : Container(),
          isGoogle
              ? SizedBox(
                  width: 5,
                )
              : Container(),
          Text(
            title,
            style:
                TextStyle(fontSize: vpH * 0.035, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffd9d9d9),
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Admin Panel"),
        appBar: appBar(
          context,
          strTitle: "Admin Panel",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      child: Image.asset(
                        'assets/img/admin.png',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Container(
                      child: _button("Admin Area !!", context, false),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              width: vpW,
              child: Center(
                child: _button('Sign in with Google', context, true),
              ),
              duration: Duration(milliseconds: 500),
              bottom: _show ? vpH * 0.12 : -vpH * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
