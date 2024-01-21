import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/forms/profile.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import '../helper/dimensions.dart';

class Team2Card extends StatelessWidget {
  final dynamic member;
  final void Function(ModelUser) callback;

  const Team2Card({Key? key, this.member, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var _currUser = Provider.of<UserProvider>(context).getUser;
    ModelUser user;
    TextStyle _titlestyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: vpH * 0.028,
        color: Colors.black);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.grey.withOpacity(0.2),
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: vpH * 0.037,
          onBackgroundImageError: (exception, stackTrace) {
            print("Network Img Exception");
            print(exception);
          },
          backgroundColor: Colors.black,
          backgroundImage:
              CachedNetworkImageProvider(member['profileImageUrl']),
        ),
        title: Text(
          member['name'] ?? " ",
          style: _titlestyle,
        ),
        subtitle: Text(member['position'] ?? " "),
        trailing: _currUser.isAdmin
            ? IconButton(
                icon: Icon(MyFlutterApp.edit),
                color: Color(0xFFFF9C01),
                iconSize: vpW * 0.060,
                onPressed: () async {
                  final FirebaseFirestore _firestore =
                      FirebaseFirestore.instance;

                  DocumentSnapshot snap = await _firestore
                      .collection('/users')
                      .doc(member['uid'])
                      .get();
                  user = ModelUser.fromMap(snap.data() as Map<String, dynamic>);
                  user.uid != "-1"
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileForm(
                              member: user,
                              callback: callback,
                            ),
                          ),
                        )
                      : Fluttertoast.showToast(
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          msg: "Profile does not exist!");
                },
              )
            : Container(
                height: 0,
                width: 0,
              ),
      ),
    );
  }
}
