import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:roboclub_flutter/configs/keys.dart';
import 'package:roboclub_flutter/services/shared_prefs.dart';

final Firestore _firestore = Firestore.instance;

class NotificationService {
  Future<Null> postDeviceToken({String fcmToken}) async {
    Map<String, dynamic> data = {
      "deviceToken": fcmToken,
      "createdAt": FieldValue.serverTimestamp(),
      "platform": Platform.operatingSystem
    };

    await _firestore.collection("/pushTokens").document(fcmToken).setData(data);
  }

  Future<Null> pushNotification({String title, String msg}) async {
    String token = await MyLocalStorage().getDeviceToken();
    final Map<String, dynamic> body = {
      "to": token,
      "data": {
        "key1": "Hello this is key 1 from AMURoboclub",
        "key2": "Hello this is key 2 from AMURoboclub"
      },
      "notification": {
        "title": title,
        "body": msg
        // "image": "https://images.ctfassets.net/gg4ddi543f5b/2tMJ2QQXnxLatGtylEYut1/cdddf953c759f1083d41d7dc72c56d00/5-Positive-Conflict-tips-You-Can-Learn-From-High-Performance-Teams-5.jpg"
      }
    };
    String fcmKey = Keys().fcmKey;
    try {
      final http.Response response = await http.post(
          'https://fcm.googleapis.com/fcm/send',
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
}
