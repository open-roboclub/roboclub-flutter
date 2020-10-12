import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/event_screen.dart';

Drawer appdrawer(context, {String page}) {
  var vpH = getViewportHeight(context);
  var vpW = getViewportWidth(context);
  var activeColor = Theme.of(context).primaryColor;
  var inActiveColor = Theme.of(context).unselectedWidgetColor;

  Widget _tileBuilder(IconData icon, String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(),
          ),
        );
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
            fontSize: vpH * 0.025,
          ),
        ),
      ),
    );
  }

  return Drawer(
    elevation: 10,
    child: Column(
      children: [
        Container(
          height: vpH * 0.24,
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
          indent: 12,
          endIndent: 12,
        ),
        SizedBox(
          height: vpH * 0.05,
        ),
        _tileBuilder(CustomIcons.feedback, "Feedback", page == "Feedback"),
        _tileBuilder(CustomIcons.info, "About us", page == "About us"),
      ],
    ),
  );
}
