import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/screens/profile.dart';
import 'package:roboclub_flutter/services/auth.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var vpH;
  var vpW;
  bool _show = false;
  bool _isLoading = false;
  AuthService _auth = AuthService();

  Widget _button(String title, BuildContext context, bool isGoogle) {
    return PhysicalModel(
      color: Colors.blue,
      shadowColor: Colors.blue.withOpacity(0.3),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      elevation: 8.0,
      child: TextButton(
        style: TextButton.styleFrom(
        foregroundColor: isGoogle ? Color(0xffFF9C01) : Colors.white, disabledForegroundColor: !isGoogle ? Color(0xffFF9C01) : Colors.white.withOpacity(0.38),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),

        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(35.0)),
        ),
        onPressed: () async {
          if (isGoogle) {
            setState(() {
              _isLoading = true;
            });
            _auth.signInWithGoogle().then((user) {
              if (user != null) {
                Provider.of<UserProvider>(context, listen: false).setUser =
                    
                    user as ModelUser;
              }
              setState(() {
                _isLoading = false;
              });
              if (user != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    // TODO: check user
                    builder: (context) => ProfileScreen(member: Provider.of<UserProvider>(context).getUser,),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: ListTile(
                      title: Text(
                        'Access Denied!',
                        style: TextStyle(
                            fontSize: vpH * 0.022, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        'Sorry! Only Core Team members are allowed for User Access and Login.',
                        style: TextStyle(fontSize: vpH * 0.02),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                         style: TextButton.styleFrom(foregroundColor: Colors.amber, fixedSize: vpH * 0.025,
                         ),
                        child: Text(
                          'Ok',
                         
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              }
            }).catchError((onError) {
              print("Error: $onError");
              setState(() {
                _isLoading = false;
              });
            });
          } else {
            setState(() {
              _show = true;
            });
          }
        },
        
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFD9D9D9),
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Admin Panel"),
        appBar: appBar(
          context,
          strTitle: "ADMIN PANEL",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Container(
                              height: vpH * 0.35,
                              width: vpW,
                              child: SvgPicture.asset(
                                'assets/illustrations/signin.svg',
                                fit: BoxFit.contain,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Container(
                            child: _button("Team SignIn", context, false),
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
