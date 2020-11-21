import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/admin_screen.dart';
import 'package:roboclub_flutter/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool drag = false;
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    final _userProvider = Provider.of<UserProvider>(context);
    final _user = _userProvider.getUser;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: vpH,
          width: vpW,
          child: Stack(
            children: [
              Container(
                height: vpH * 0.35,
                width: vpW,
                child: Image.network(
                  _user.profileImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: vpH * 0.35,
                width: vpW,
                color: Colors.black.withOpacity(0.2),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                top: drag ? vpH * 0.1 : vpH * 0.3,
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    setState(() {
                      drag = !drag;
                    });
                  },
                  child: Container(
                    height: vpH * 0.9,
                    width: vpW,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(vpW * 0.08),
                        topRight: Radius.circular(vpW * 0.08),
                      ),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          // offset: Offset(2, 2),
                          blurRadius: 1.0,
                          // spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    // color: Colors.yellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: vpH * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            _user.name ?? "",
                            style: TextStyle(
                              fontSize: vpH * 0.032,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(_user.position ?? "Member"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child:
                              Text('Computer Engineering ' + _user.batch ?? ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            _user.about ?? "About Section is empty!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 12),
                          child: Text(
                            "Event Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: vpH * 0.04),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: vpH * 0.06,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      height: vpH * 0.05,
                                    ),
                                    Icon(
                                      Icons.map,
                                      size: vpH * 0.06,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Container(
                                      height: vpH * 0.07,
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    SizedBox(
                                      height: vpH * 0.04,
                                    ),
                                    Container(
                                      height: vpH * 0.07,
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text("Sun, 20 Nov, 2020"),
                                      subtitle: Text("12 PM to 10 PM"),
                                    ),
                                    // SizedBox(
                                    //   height: vpH * 0.02,
                                    // ),
                                    ListTile(
                                      title: Text("Get Direction"),
                                      subtitle: Text("ML 10, Main Building"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 12),
                          child: Text(
                            "Event Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: vpH * 0.03),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 12),
                          child: Text(
                            "The 3-day deal will consist of Live classes, problem-solving sessions, and even contests. As the cherry on top, all participants get to take home a certificate. So hurry up, the last date for registration is the 19th of November.\nThe 3-day deal will consist of Live classes, problem-solving sessions, and even contests. As the cherry on top, all participants get to take home a",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: vpH * 0.025,
                left: vpW * 0.01,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned(
                top: vpH * 0.025,
                right: vpW * 0.02,
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    AuthService().signOutGoogle();
                    _userProvider.setUser = null;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => AdminScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
