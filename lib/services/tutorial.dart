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

  Future<List<dynamic>> fetchProjects() async {
    List<dynamic> list = [];

    await _firestore.collection("/tutorials").getDocuments().then((value) {
      value.documents.forEach((element) {
        list.add(element.data);
      });
    });
    print(list[0]['title']);
    print(list[0]['url']);
    return list;
  }
}
