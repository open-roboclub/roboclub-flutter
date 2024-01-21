import 'package:flutter/material.dart';
import '../helper/dimensions.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';

class TutorialCard extends StatelessWidget {
  final String title;

  const TutorialCard({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var _style = TextStyle(
      fontSize: vpH * 0.025,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: [
          PhysicalModel(
            color: Colors.transparent,
            elevation: 8.0,
            child: Container(
              height: vpH * 0.15,
              width: vpW * 0.90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  "assets/img/tutorial.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: vpH * 0.15,
            width: vpW * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xD9FFFFFF).withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  title ,
                  style: _style,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Icon(
              SocialMedia.youtube,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
