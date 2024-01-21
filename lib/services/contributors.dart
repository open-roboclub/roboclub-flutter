import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/contributor.dart';

import 'dart:async';



final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ContributorService {

  Future<bool> postContributor(
      {
      String? name,
      String? description,
      String? amount,
      String? representativeImg,
      String? date}) async {
        
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "representativeImg": representativeImg,
      "amount": amount,
      "date": date,
    };

    await _firestore.collection("/contributors").add(data).then((value) {

      print(value);
    });
    return true;
  }

  Future<List<Contributor>> fetchContributors() async {
    List<Contributor> list = [];

    await _firestore.collection("/contributors")
      .orderBy('date', descending: true)
      .get()
      .then((value) {

      value.docs.forEach((element) {
        list.add(Contributor.fromMap(element.data()));
      });
    });
    return list;
  }
}
