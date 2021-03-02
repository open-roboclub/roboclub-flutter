import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final Firestore _firestore = Firestore.instance;

class FeedbackService {
  Future<bool> postFeedback(String feedback, bool isMember) async {
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
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
