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
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> fetchTutorials() {
    _firestore.collection('/tutorials');
  }
}
