import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/project.dart';

import 'dart:async';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProjectService {
  Future<bool> postProjects({
    List<dynamic> projectImg,
    String name,
    String description,
    String date,
    String link,
    String progress = "",
    List<dynamic> teamMembers,
    String fileUrl,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "projectImg": projectImg,
      "fileUrl": fileUrl,
      "progress": progress,
      "teamMembers": teamMembers,
      "date": date,
      "link": link,
    };

    await _firestore.collection("/projects").add(data).then((value) {
      print(value);
    });
    return true;
  }

  Future<List<Project>> fetchProjects() async {
    List<Project> list = [];

    await _firestore
        .collection("/projects")
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(Project.fromMap(element.data()));
      });
    });
    return list;
  }
}
