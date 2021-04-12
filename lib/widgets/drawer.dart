import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/screens/about_screen.dart';
import 'package:roboclub_flutter/screens/admin_screen.dart';
import 'package:roboclub_flutter/screens/contributor_screen.dart';
import 'package:roboclub_flutter/screens/event_screen.dart';
import 'package:roboclub_flutter/screens/feedback_screen.dart';
import 'package:roboclub_flutter/screens/profile.dart';
import 'package:roboclub_flutter/screens/project_screen.dart';
import 'package:roboclub_flutter/screens/team_screen.dart';
import 'package:roboclub_flutter/screens/tutorial_screen.dart';

Drawer appdrawer(context, {String page}) {
  var vpH = getViewportHeight(context);
  var vpW = getViewportWidth(context);
  var activeColor = Theme.of(context).primaryColor;
  var inActiveColor = Theme.of(context).unselectedWidgetColor;

  Widget _getScreen(String title) {
    switch (title) {
      case "Events":
        {
          return EventScreen();
        }
        break;
      case "Projects":
        {
          return ProjectScreen();
        }
        break;
      case "Teams":
        {
          return TeamScreen();
        }
        break;
      case "Tutorials":
        {
          return TutorialScreen();
        }
        break;
      case "Contributors":
        {
          return ContributorScreen();
        }
        break;
      case "Admin Panel":
        {
          var _user = Provider.of<UserProvider>(context).getUser;
          if (_user.name.isNotEmpty) {
            return ProfileScreen();
          } else {
            return AdminScreen();
          }
        }
        break;
      case "Feedback":
        {
          return FeedbackScreen();
        }
        break;
      case "About us":
        {
          return AboutScreen();
        }
        break;
      default:
        {
          return EventScreen();
        }
        break;
    }
  }

  Widget _tileBuilder(IconData icon, String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (title != page) {
          if (page == "Events") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _getScreen(title),
              ),
            );
          } else if (title == "Events") {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => _getScreen(title),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => _getScreen(title),
              ),
            );
          }
        }
      },
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? activeColor : inActiveColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? activeColor : inActiveColor,
            fontWeight: FontWeight.bold,
            fontSize: vpH * 0.023,
          ),
        ),
      ),
    );
  }

  return Drawer(
    elevation: 10,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: vpH * 0.178,
            width: vpW,
            // color: Colors.yellow,
            child: Image.asset(
              'assets/img/club_banner.jpg',
              fit: BoxFit.cover,
            ),
          ),
          _tileBuilder(CustomIcons.events, "Events", page == "Events"),
          _tileBuilder(CustomIcons.projects, "Projects", page == "Projects"),
          _tileBuilder(CustomIcons.teams, "Teams", page == "Teams"),
          _tileBuilder(CustomIcons.tutorials, "Tutorials", page == "Tutorials"),
          _tileBuilder(
              CustomIcons.contribution, "Contributors", page == "Contributors"),
          _tileBuilder(CustomIcons.admin, "Admin Panel", page == "Admin Panel"),
          Divider(
            thickness: 2,
            indent: vpW * 0.04,
            endIndent: vpW * 0.04,
          ),
          SizedBox(
            height: vpH * 0.005,
          ),
          _tileBuilder(CustomIcons.feedback, "Feedback", page == "Feedback"),
          _tileBuilder(CustomIcons.info, "About us", page == "About us"),
        ],
      ),
    ),
  );
}
