import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FeedbackService {
  Future<bool> postFeedback(String feedback, bool isMember) async {
    DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    String date = formatter.format(DateTime.now());
    Map<String, dynamic> data = {
      "feedback": feedback,
      "isMember": isMember,
      "dateTime": date,
    };
    await _firestore.collection('/feedbacks').add(data).then((value) {
      print(value);
    });
    return true;
  }
}
