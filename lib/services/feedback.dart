import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;

class FeedbackService {
  Future<bool> postFeedback(String feedback, bool isMember) async {
    Map<String, dynamic> data = {
      "feedback": feedback,
      "isMember": isMember,
    };
    await _firestore.collection('/feedbacks').add(data).then((value) {
      print(value);
    });
    return true;
  }
}
