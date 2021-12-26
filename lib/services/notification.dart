import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class NotificationService {
  Future<Null> postDeviceToken({String? fcmToken}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Map<String, dynamic> data = {
      "deviceToken": fcmToken,
      "createdAt": FieldValue.serverTimestamp(),
      "platform": Platform.operatingSystem,
      "androidId": androidInfo.androidId,
    };

    await _firestore
        .collection("/pushTokens")
        .doc(androidInfo.androidId)
        .set(data);
  }

  Future<List<String>> getFCMTokens() async {
    List<String> list = [];
    await _firestore.collection('/pushTokens').get().then((tokens) {
      tokens.docs.forEach((token) {
        list.add(token.data.call()['deviceToken']);
      });
    });
    return list;
  }

  Future<Null> pushNotification(
      {required String title,
      required String msg,
      required String img,
      required String screen}) async {
    List<String> tokens = await getFCMTokens();
    final Map<String, dynamic> body = {
      // "to": 'fwGkbdNJRiSKRkOSQBMYi6:APA91bFG9P6YsOBaLJD8kEpUBd1VHn1W7SSrSehVdQ10X4hfQDxf32K2gUchpc1SYIwP78fxVOEecihsKXfxkdMDFtauaYLaFL_MHMhh4pmW36YYql_dskatPRhKuPFB6FCeD5IgQLwh',
      "registration_ids": ['fwGkbdNJRiSKRkOSQBMYi6:APA91bFG9P6YsOBaLJD8kEpUBd1VHn1W7SSrSehVdQ10X4hfQDxf32K2gUchpc1SYIwP78fxVOEecihsKXfxkdMDFtauaYLaFL_MHMhh4pmW36YYql_dskatPRhKuPFB6FCeD5IgQLwh', 'c9PwIj7jT6y7GxCyx7_6o7:APA91bGnW3uxeoaoqeFM7vxrWH2DtjXHve3f6QfKcERo7dJ5U4RMr3UNbZXZ96wbN11vpliiIQf6McSWKA-7ZiSg1utj3eE1Rf0lM8UrvR4AH9ULDEY_xySMG5bEwkaS1EzopThv8Ktm', 'dCydb-A8RDGwthLK2VR5JI:APA91bH0nF2NwSoGc8B849jIJZQmYhbuGWSrCyKfW81pvwuQIdmuKA2jKAB37eZSYp76uvk1VU2fUE2aiyKwhCRRUK0GEIXhLEpUeSgeO_nwQg5DDFt8ntuHJiijfSc0NUBQ34z2n5J3', 'e4FZT9cNSj6Z8WYAqZV3oP:APA91bHUlyYJ4I9gsXdA3yS1_eAKK_GylODWgUKWvXtRZ5XnYCAbaPoG6NmgGsMnyc9ylkvr-mY3E7VgBrXTC3QKIi0VObeIUBgYBTPi_C21lscS0CdkeTg7G_3njLqNcaq4HoQwbGjL', 'd4jwa-FJTFqiZdEa8S9996:APA91bEiezr7Kkh1XuSNWMNblaapBPDRe8M3gwbKN1vNIhb0kuHqy3kzggGmuygFF1h5ntYG4H1IkUGwSC5Yqwxs5F2wcRz95xnc_QtBETXwpFWGtMRRihgKHBREu-N-IK22et6IS010'],
      "data": {"screen": screen},
      "notification": {
        "title": title,
        "body": msg,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "image": img
      }
    };

    // TODO: check it
    DocumentSnapshot fcmKeySnap =
        await _firestore.collection("/keys").doc("FCM_KEY").get();
    String fcmKey = fcmKeySnap.get('key');
    try {
      final http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: json.encode(body),
          headers: <String, String>{
            'authorization': "key=$fcmKey",
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        print('Notification Send Successfully');
        final Map<String, dynamic> res = json.decode(response.body);

        int success = res['success'];
        print("Success status is: ");
        print(success);
      } else {
        print('Invalid status code: ${response.statusCode}');
      }
    } catch (err) {
      print(err);
    }
  }

  Future<bool> postNotification(
      {String? title, String? msg, String? link, String? date}) async {
    Map<String, dynamic> data = {
      "title": title,
      "msg": msg,
      "link": link,
      "date": date,
    };

    await _firestore.collection("/notifications").add(data).then((value) {
      print(value);
    });
    return true;
  }
}
