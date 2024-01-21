import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TutorialService {
  Future<bool> addTutorial(String videoId, String title) {
    Map<String, dynamic> _tutorial = {
      'videoId': videoId,
    };
    _firestore.collection('/tutorials').doc(title).set(_tutorial).then((value) {
      return Future.value(true);
    }).catchError((e) {
      return Future.value(false);
    });
    return Future.value(false);
  }

  Future<List<dynamic>> fetchTutorials() async {
    List<dynamic> list = [];

    await _firestore.collection("/tutorials").get().then((value) {
      value.docs.forEach((element) {
        // print(element.data());
        list.add(element.data());
      });
    });
    return list;
  }
}
