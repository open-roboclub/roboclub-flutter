import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/event.dart';

import 'dart:async';

final Firestore _firestore = Firestore.instance;

class EventService {

  Future<bool> postEvent(
      {
        String eventName,
        String description,
        String date,
        String time,
        String eventImg,
        String hostImg,
        String hostedBy,
        String venue }) async {

    Map<String, dynamic> data = {
      "eventName": eventName,
      "description": description,
      "date": date,
      "time": time,
      "eventImg": eventImg,
      "hostImg": hostImg,
      "hostedBy": hostedBy,
      "venue": venue,
    };

    await _firestore.collection("/events").add(data).then((value) {

      print(value);
    });
    return true;
  }

  Future<List<Event>> fetchEvents() async {
    List<Event> list = [];

    await _firestore.collection("/events").getDocuments().then((value) {

      value.documents.forEach((element) {
        list.add(Event.fromMap(element.data));
      });
    });
    return list;
  }
}
