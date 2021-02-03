import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/event.dart';

final Firestore _firestore = Firestore.instance;

class EventService {
  Future<bool> postEvent(String videoId, String title) {
    Map<String, dynamic> _tutorial = {
      'videoId': videoId,
    };
    _firestore
        .collection('/tutorials')
        .document(title)
        .setData(_tutorial)
        .then((value) {
      return Future.value(true);
    }).catchError((e) {
      return Future.value(false);
    });
    return Future.value(false);
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
