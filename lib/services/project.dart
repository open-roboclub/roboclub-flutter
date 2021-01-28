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
        List<String> teamMembers,
        String memberImg,
        File file,
        String link,
        bool projectStatus}) async {
          
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "projectImg": projectImg,
      "memberImg": memberImg,
      "file": file,
      "teamMembers": teamMembers,
      "link": link,
      "projectStatus" : projectStatus,
    };

    await _firestore.collection("/projects").add(data).then((value) {

      print(value);
    });
    return true;
  }

  Future<List<Project>> fetchProjects() async {
    List<Project> list = [];

    await _firestore.collection('/projects').getDocuments().then((value) {

      value.documents.forEach((element) {
        list.add(Project.fromMap(element.data));
      });
    });
    return list;
  }
}

