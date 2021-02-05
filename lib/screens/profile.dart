import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/forms/contribution.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/admin_screen.dart';
import 'package:roboclub_flutter/services/auth.dart';

import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final bool viewMode;
  final User member;

  const ProfileScreen({Key key, this.viewMode = false, this.member})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool drag = false;

  Widget _quickOptions(var vpH, IconData iconData, Object navigateTo) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            iconData,
            color: Colors.black.withOpacity(0.8),
            size: vpH * 0.045,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return navigateTo;
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.white60,
            child: Icon(
              Icons.add,
              color: Colors.orangeAccent.withOpacity(0.8),
              size: vpH * 0.025,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    TextStyle lowPriorityText = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: vpH * 0.02,
      color: Colors.grey,
    );
    var _userProvider, _user, _currUser;
    _userProvider = Provider.of<UserProvider>(context);
    if (!widget.viewMode) {
      _user = _userProvider.getUser;
      _currUser = _userProvider.getUser;
    } else {
      _user = widget.member;
      _currUser = _userProvider.getUser;
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: vpH,
          width: vpW,
          child: Stack(
            children: [
              Container(
                height: vpH,
                width: vpW,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: vpH * 0.25,
                          width: vpW * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(_user.profileImageUrl),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: vpH * 0.025,
                                  ),
                                ),
                                Text(
                                  _user.position,
                                  style: lowPriorityText,
                                ),
                                Text(
                                  _user.branch,
                                  style: lowPriorityText,
                                ),
                                Text(
                                  _user.batch,
                                  style: lowPriorityText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: vpH * 0.05,
                    ),
                    _currUser.isAdmin
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _quickOptions(
                                  vpH, CustomIcons.events, ContributionForm()),
                              Divider(
                                height: vpH * 0.04,
                              ),
                              _quickOptions(vpH, Icons.notifications_sharp,
                                  ContributionForm()),
                              Divider(
                                height: vpH * 0.04,
                              ),
                              _quickOptions(vpH, CustomIcons.tutorials,
                                  ContributionForm()),
                              Divider(
                                height: vpH * 0.04,
                              ),
                              _quickOptions(vpH, CustomIcons.contribution,
                                  ContributionForm()),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: vpH * 0.025,
                    ),
                    Container(
                      height: vpH * 0.4,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: ListView(
                          addSemanticIndexes: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PhysicalModel(
                                color: Colors.transparent,
                                shadowColor: Colors.blue.withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                elevation: 8.0,
                                child: Container(
                                  width: vpW * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'About',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: vpH * 0.03),
                                            ),
                                          ),
                                          Text(
                                            _user.about,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PhysicalModel(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                shadowColor: Colors.blue.withOpacity(0.3),
                                elevation: 8.0,
                                child: Container(
                                  width: vpW * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Interests',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: vpH * 0.03),
                                            ),
                                          ),
                                          Text(
                                            _user.interests,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PhysicalModel(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                shadowColor: Colors.blue.withOpacity(0.3),
                                elevation: 8.0,
                                child: Container(
                                  width: vpW * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Social Handles',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: vpH * 0.03),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon:
                                                    Icon(SocialMedia.facebook),
                                                iconSize: vpW * 0.080,
                                                color: _user.fbId.isNotEmpty
                                                    ? Color(0xFF3B5998)
                                                    : Colors.grey,
                                                onPressed: () {
                                                  if (_user.fbId.isNotEmpty) {
                                                    launch(
                                                        'https://www.facebook.com/groups/amuroboculb/');
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                icon:
                                                    Icon(SocialMedia.linkedin),
                                                iconSize: vpW * 0.080,
                                                color:
                                                    _user.linkedinId.isNotEmpty
                                                        ? Color(0xFF2867B2)
                                                        : Colors.grey,
                                                onPressed: () {
                                                  if (_user
                                                      .linkedinId.isNotEmpty) {
                                                    launch(
                                                        'https://www.linkedin.com/in/amuroboclub');
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.phone),
                                                iconSize: vpW * 0.080,
                                                color: _user.contact.isNotEmpty
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                onPressed: () {
                                                  if (_user
                                                      .contact.isNotEmpty) {
                                                    launch('tel://' +
                                                        _user.contact);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (_user
                                                      .instaId.isNotEmpty) {
                                                    launch(
                                                        'https://www.instagram.com/amuroboclub');
                                                  }
                                                },
                                                child: Image.asset(
                                                  'assets/img/insta.png',
                                                  color:
                                                      _user.instaId.isNotEmpty
                                                          ? null
                                                          : Colors.grey,
                                                  colorBlendMode:
                                                      BlendMode.color,
                                                  fit: BoxFit.cover,
                                                  width: vpW * 0.080,
                                                  height: vpH * 0.040,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.mail_outline),
                                                iconSize: vpW * 0.080,
                                                color: Colors.black,
                                                onPressed: () async {
                                                  final Uri params = Uri(
                                                    scheme: 'mailto',
                                                    path: _user.email,
                                                    query:
                                                        'subject=&body=', //add subject and body here
                                                  );

                                                  var url = params.toString();
                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: vpH * 0.05,
                    ),
                    PhysicalModel(
                      color: Colors.transparent,
                      shadowColor: Colors.blue.withOpacity(0.3),
                      elevation: 8.0,
                      child: Container(
                        width: vpW * 0.85,
                        height: vpH * 0.1,
                        // color: Colors.white,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
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
              widget.viewMode
                  ? Container()
                  : Positioned(
                      top: vpH * 0.025,
                      right: vpW * 0.02,
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        onPressed: () async {
                          await AuthService().signOutGoogle().then((value) {
                            _userProvider.setUser = User();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminScreen(),
                              ),
                            );
                          });
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
