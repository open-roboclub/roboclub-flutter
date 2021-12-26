import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/contributor.dart';

import 'dart:async';

import 'package:roboclub_flutter/models/member.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MemberService {
  Future<bool> postMember({
    String? name,
    String? description,
    String? amount,
    String? representativeImg,
    String? date,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "representativeImg": representativeImg,
      "amount": amount,
      "date": date,
    };

    await _firestore.collection("/registeredMembers").add(data).then((value) {
      print(value);
    });
    return true;
  }

  Future<List<Member>> fetchMembers() async {
    List<Member> list = [];

    await _firestore
        .collection("/registeredMembers")
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(Member.fromMap(element.data()));
      });
    });
    return list;
  }
}
