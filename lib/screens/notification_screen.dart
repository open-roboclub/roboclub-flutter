import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
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
    User _user = Provider.of<UserProvider>(context).getUser;
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
              child: true
                  ? StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('/notifications')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<DocumentSnapshot> documents =
                              snapshot.data.documents;
                          return ListView(
                            physics: BouncingScrollPhysics(),
                            children: documents
                                .map(
                                  (doc) => NotificationCard(
                                    msg: doc.data['message'],
                                    link: doc.data['link'],
                                    title: doc.data['title'],
                                  ),
                                )
                                .toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Some Error has Occured");
                        } else {
                          return Text("No Data");
                        }
                      },
                    )
                  //  ListView.builder(
                  //     physics: BouncingScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: 10,
                  //     scrollDirection: Axis.vertical,
                  //     itemBuilder: (context, index) {
                  //       return NotificationCard();
                  //     },
                  //   )
                  : Center(
                      child: Text('No Contributions Yet'),
                    ),
            ),
          ),
        ),
        floatingActionButton: _user != null
            ? (_user.isAdmin
                ? FloatingActionButton(
                    onPressed: null,
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
