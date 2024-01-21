import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
      "androidId": androidInfo.id,
    };

    await _firestore
        .collection("/pushTokens")
        .doc(androidInfo.id)
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
      "registration_ids": tokens,
      "data": {"screen": screen},
      "dry_run": true,
      "notification": {
        "title": title,
        "body": msg,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "image": img,
      }
    };
    final Map<String, dynamic> body2 = {
      "to": "/topics/newNotification",
      "data": {"screen": screen},
      // "dry_run": true,
      "notification": {
        "title": title,
        "body": msg,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "image": img,
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

    try {
      final http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: json.encode(body2),
          headers: <String, String>{
            'authorization': "key=$fcmKey",
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        print('Notification Send Successfully');
        final Map<String, dynamic> res = json.decode(response.body);

        // int success = res['success'];
        print("Success status is:$res ");
        // print(success);
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
