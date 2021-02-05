import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/project.dart';

import 'dart:async';

final Firestore _firestore = Firestore.instance;

class ProjectService {

  Future<bool> postProjects(
      {String projectImg,
        String name,
        String description,
        String date,
        String memberImg,
        String link,
        // List<String> teamMembers,
          // File file,
        }) async {
          
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "projectImg": projectImg,
      "memberImg": memberImg,
      // "file": file,
      // "teamMembers": teamMembers,
      "date" : date,
      "link": link,
    };

    await _firestore.collection("/projects").add(data).then((value) {

      print(value);
    });
    return true;
  }

  Future<List<Project>> fetchProjects() async {
    List<Project> list = [];

    await _firestore.collection("/projects").getDocuments().then((value) {

      value.documents.forEach((element) {
        list.add(Project.fromMap(element.data));
      });
    });
    return list;
  }
}


