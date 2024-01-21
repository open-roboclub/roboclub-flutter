import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/forms/notifications.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/models/notifications.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  var vpH;
  var vpW;
  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    ModelUser _user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        appBar: appBar(
          context,
          strTitle: "Notifications",
          isDrawer: false,
          isNotification: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: vpH * 0.9,
              width: vpW,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('/notifications')
                .orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: documents
                          .map(
                            (doc) => NotificationCard(Notifications.fromMap(doc.data() as Map<String,dynamic>)))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Some Error has Occured");
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("No Notification Here"),
                          Container(
                            width: vpW * 0.7,
                            height: vpH * 0.5,
                            // color: Colors.yellow,
                            child: SvgPicture.asset(
                              'assets/illustrations/my_notifications.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        floatingActionButton: _user != null
            ? (_user.isAdmin
                ? FloatingActionButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return NotificationForm();
                          },
                        ),
                      );
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                      size: vpH * 0.045,
                    ),
                  )
                : null)
            : null,
      ),
    );
  }
}
