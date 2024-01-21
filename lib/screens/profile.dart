import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/forms/contribution.dart';
import 'package:roboclub_flutter/forms/event.dart';
import 'package:roboclub_flutter/forms/notifications.dart';
import 'package:roboclub_flutter/forms/profile.dart';
import 'package:roboclub_flutter/forms/project.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/admin_screen.dart';
import 'package:roboclub_flutter/services/auth.dart';

import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final bool viewMode;
  final ModelUser member;
  // final bool showInSnackBar;
  const ProfileScreen({
    Key? key,
    this.viewMode = false,
    required this.member,
  }) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool drag = false;
  late ModelUser _user, _currUser;
  var vpH, vpW;

  @override
  void didChangeDependencies() {
    UserProvider _userProvider = Provider.of<UserProvider>(context);
    if (!widget.viewMode) {
      _user = _userProvider.getUser;
      _currUser = _userProvider.getUser;
    } else {
      _user = widget.member;
      _currUser = _userProvider.getUser;
    }

    super.didChangeDependencies();
  }

  Widget _quickOptions(var vpH, IconData iconData, Widget navigateTo) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            iconData,
            color: Colors.black.withOpacity(0.8),
            size: vpH * 0.04,
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
              size: vpH * 0.022,
            ),
          ),
        )
      ],
    );
  }

  void callSnakBar(BuildContext context) {
    Timer(
      Duration(seconds: 1),
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFFF9C01),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _user.isAdmin ? 'Admin detected' : 'Welcome ${_user.name}',
                  style: TextStyle(
                      fontSize: vpH * 0.02,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFFFFFF)),
                ),
              ),
              Icon(
                Icons.admin_panel_settings,
                color: Color(0xFFFFFFFF),
              )
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    List<String> interests = _user.interests.split(',');
    TextStyle lowPriorityText = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: vpH * 0.02,
      color: Colors.grey,
    );

    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
          if (!widget.viewMode) {
            callSnakBar(context);
          }
          return Container(
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
                              // color: Colors.white,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: CachedNetworkImageProvider(
                                    _user.profileImageUrl),
                              ),
                            ),
                          ),
                          Container(
                            width: vpW * 0.5,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      _user.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: vpH * 0.027,
                                      ),
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
                                    vpH, CustomIcons.events, EventForm()),
                                Divider(
                                  height: vpH * 0.04,
                                ),
                                _quickOptions(vpH, Icons.notifications_sharp,
                                    NotificationForm()),
                                Divider(
                                  height: vpH * 0.04,
                                ),
                                _quickOptions(
                                    vpH,
                                    CustomIcons.projects,
                                    ProjectForm(
                                      editMode: false,
                                      // currproject: ,
                                    )),
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
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                'About',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontSize: vpH * 0.03),
                                              ),
                                            ),
                                            _user.about.isNotEmpty
                                                ? Text(
                                                    _user.about,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 10,
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                : Center(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: vpH * 0.2,
                                                          width: vpW * 0.4,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/illustrations/about.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        Text('What about you?')
                                                      ],
                                                    ),
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
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                'Interests',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontSize: vpH * 0.03),
                                              ),
                                            ),
                                            _user.interests.isNotEmpty
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        interests.length > 10
                                                            ? 10
                                                            : interests.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                        interests[index],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: vpH * 0.2,
                                                          width: vpW * 0.4,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/illustrations/interest.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        Text(
                                                            'What Interest you?')
                                                      ],
                                                    ),
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
                                              padding:
                                                  const EdgeInsets.all(15.0),
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
                                                  icon: Icon(
                                                      SocialMedia.facebook),
                                                  iconSize: vpW * 0.080,
                                                  color: _user.fbId.isNotEmpty
                                                      ? Color(0xFF3B5998)
                                                      : Colors.grey,
                                                  onPressed: () {
                                                    if (_user.fbId.isNotEmpty) {
                                                      launch(_user.fbId);
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      SocialMedia.linkedin),
                                                  iconSize: vpW * 0.080,
                                                  color: _user
                                                          .linkedinId.isNotEmpty
                                                      ? Color(0xFF2867B2)
                                                      : Colors.grey,
                                                  onPressed: () {
                                                    if (_user.linkedinId
                                                        .isNotEmpty) {
                                                      launch(_user.linkedinId);
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
                                                  color:
                                                      _user.contact.isNotEmpty
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
                                                      launch(_user.instaId);
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
                                                GestureDetector(
                                                  onTap: () async {
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
                                                  child: Container(
                                                    width: vpW * 0.10,
                                                    height: vpH * 0.050,
                                                    child: Image.asset(
                                                      'assets/img/gmail.png',
                                                      fit: BoxFit.cover,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _user.cvLink.isEmpty
                          ? SizedBox(
                              height: vpH * 0.05,
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: vpW * 0.08,
                                  vertical: vpH * 0.005),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                onSurface: Colors.white,
                                primary: Color(0xff6739d6),
                                ),
                                onPressed: () {
                                  launch(_user.cvLink);
                                },
                                child: Text(
                                  "View CV",
                                  style: TextStyle(fontSize: vpH * 0.02),
                                ),
                              ),
                            ),
                      PhysicalModel(
                        color: Colors.transparent,
                        shadowColor: Colors.blue.withOpacity(0.3),
                        elevation: 8.0,
                        child: Container(
                          width: vpW * 0.85,
                          // height: vpH * 0.1,
                          // color: Colors.white,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 15.0,
                            ),
                            child: Center(
                              child: Text(
                                "\" " + _user.quote + " \"",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            dropdownColor: Color(0xFFE8EAF6),
                            // underline: Underline,
                            // value: "",
                            isDense: true,
                            onChanged: (String? newValue) async {
                              if (newValue == "Sign Out") {
                                await AuthService()
                                    .signOutGoogle()
                                    .then((value) {
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .setUser = ModelUser();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminScreen(),
                                    ),
                                  );
                                });
                              } else if (newValue == 'Edit Profile') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileForm(
                                              member: _user,
                                            )));
                              }
                            },
                            items: <String>['Edit Profile', 'Sign Out']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
