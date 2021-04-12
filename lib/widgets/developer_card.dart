import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/dimensions.dart';

class DeveloperCard extends StatelessWidget {
  final name;
  final String img;
  final String linkedin;

  const DeveloperCard({Key key, this.name, this.img, this.linkedin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    TextStyle _titlestyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontSize: vpH * 0.026,
    );
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: vpH * 0.01, horizontal: vpW * 0.040),
      child: Container(
        // height: vpH * 0.085,
        width: vpW * 0.90,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: vpH * 0.008, horizontal: vpW * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: CircleAvatar(
                      radius: vpH * 0.035,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: vpH * 0.033,
                        backgroundImage: AssetImage(img),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: vpW * 0.040),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              name,
                              style: _titlestyle,
                            ),
                          ),
                          // Padding(padding: EdgeInsets.symmetric(vertical:vpH*0.006),
                          //   child:Text(
                          //   "Post",
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(fontSize:vpH*0.018),
                          // ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(SocialMedia.linkedin),
                      iconSize: vpW * 0.070,
                      color: Color(0xFF2867B2),
                      onPressed: () {
                        launch(linkedin);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
