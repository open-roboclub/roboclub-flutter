import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import '../helper/dimensions.dart';

class Team2Card extends StatelessWidget {
  final User member;

  const Team2Card({Key key, this.member}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var _currUser = Provider.of<UserProvider>(context).getUser;
    TextStyle _titlestyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.028);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
      child: Container(
        height: vpH * 0.13,
        width: vpW * 0.90,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: vpH * 0.0016, color: Color(0xFF707070)),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: CircleAvatar(
                      radius: vpH * 0.037,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                        member.profileImageUrl.isNotEmpty
                            ? member.profileImageUrl
                            : "",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    // fit: FlexFit.tight,
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: vpW * 0.040),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name ?? "Name",
                            overflow: TextOverflow.ellipsis,
                            style: _titlestyle,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: vpH * 0.006),
                            child: Text(
                              member.position ?? "Post",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: vpH * 0.018,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _currUser.isAdmin
                      ? Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                  icon: Icon(MyFlutterApp.edit),
                                  color: Color(0xFFFF9C01),
                                  iconSize: vpW * 0.060,
                                  onPressed: () {}),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
