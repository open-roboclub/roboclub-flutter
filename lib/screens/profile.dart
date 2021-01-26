import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

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
    var _userProvider = Provider.of<UserProvider>(context);
    var _user = _userProvider.getUser;
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
                  _user.profileImageUrl.isEmpty
                      ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS12QuNvQIsEBeYe6ecNFtaWq1uf-1jSZc2_g&usqp=CAU"
                      : _user.profileImageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black26,
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              // Container(
              //   height: vpH * 0.35,
              //   width: vpW,
              //   color: Colors.black.withOpacity(0.2),
              // ),
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
                        ListTile(
                          title: Text(
                            "Interests: ",
                            style: TextStyle(
                              fontSize: vpH * 0.032,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(_user.interests ?? ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Let's Connect",
                            style: TextStyle(
                              fontSize: vpH * 0.032,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: vpH * 0.006,
                                  horizontal: vpW * 0.02),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(SocialMedia.facebook),
                                  iconSize: vpW * 0.080,
                                  color: Color(0xFF3B5998),
                                  onPressed: () {
                                    launch(_user.fbId ?? "");
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: vpH * 0.005,
                                  horizontal: vpW * 0.02),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(SocialMedia.linkedin),
                                  iconSize: vpW * 0.080,
                                  color: Color(0xFF2867B2),
                                  onPressed: () {
                                    launch(_user.linkedinId ?? "");
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: vpH * 0.013,
                                  horizontal: vpW * 0.02),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    launch(_user.instaId ?? "");
                                  },
                                  child: Image.asset(
                                    'assets/img/insta.png',
                                    fit: BoxFit.cover,
                                    width: vpW * 0.080,
                                    height: vpH * 0.040,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: vpH * 0.005,
                                  horizontal: vpW * 0.02),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(SocialMedia.youtube),
                                  iconSize: vpW * 0.090,
                                  color: Colors.red,
                                  onPressed: () {
                                    launch('tel://' + _user.contact ?? "");
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: vpH * 0.005,
                                  horizontal: vpW * 0.02),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(SocialMedia.github),
                                  iconSize: vpW * 0.080,
                                  color: Colors.black,
                                  onPressed: () {
                                    launch('https://github.com/open-roboclub');
                                  },
                                ),
                              ),
                            ),
                          ],
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
                    print(_user.name + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!1111" ??
                        "No name\n");
                    _userProvider.setUser = User(name: "Rishabh Jackson");
                    setState(() {});
                    // _userProvider.setUser = User();
                    // print(_userProvider.getUser.name +
                    //         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!2222" ??
                    //     "No name\n");
                    // AuthService().signOutGoogle().then((value) {
                    //   print("_user is set to null");
                    //   Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (context) => AdminScreen(),
                    //     ),
                    //   );
                    // });
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
