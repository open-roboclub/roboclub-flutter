import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/contributor.dart';

import 'dart:async';

import 'package:roboclub_flutter/models/member.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MemberService {
  Future<bool> postMember({
    String? name,
    String? email,
    String? enrollNo,
    String? course,
    String? collegeName,
    String? fileUrl,
    String? yearOfStudy,
    String? mobileNo,
    DateTime? dateOfReg,
    String? facultyNo,
    // String? representativeImg,
    // String? date,
  }) async {
    Map<String, dynamic> data = {
      "enrollNo": enrollNo,
      "email": email,
      "name": name,
      "facultyNo": facultyNo,
      "fileUrl": fileUrl,
      "course": course,
      "collegeName": collegeName,
      "yearOfStudy": yearOfStudy,
      "mobileNo": mobileNo,
      "dateOfReg": DateTime.now()
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
