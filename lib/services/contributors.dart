import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/contributor.dart';

import 'dart:async';



final Firestore _firestore = Firestore.instance;

class ContributorService {

  Future<bool> postContributor(
      {String name,
      String description,
      String amount,
      String representativeImg}) async {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "representativeImg": representativeImg,
      "amount": amount,
    };

    await _firestore.collection("/contributors").add(data).then((value) {

      print(value);
    });
    return true;
  }

  Future<List<Contributor>> fetchContributors() async {
    List<Contributor> list = [];

    await _firestore.collection("/contributors").getDocuments().then((value) {

      value.documents.forEach((element) {
        list.add(Contributor.fromMap(element.data));
      });
    });
    return list;
  }
}
