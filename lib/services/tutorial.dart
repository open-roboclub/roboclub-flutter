import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;

class TutorialService {
  Future<bool> addTutorial(String videoId, String title) {
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

  Future<bool> fetchTutorials() {
    _firestore.collection('/tutorials');

    return Future.value(false);

  }
}
