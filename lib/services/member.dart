import 'package:cloud_firestore/cloud_firestore.dart';

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
      "dateOfReg": DateTime.now(),
      "isPaid": false
    };

    await _firestore
        .collection("/registeredMembers")
        .doc(email)
        .set(data)
        .then((value) {
      print("Success");
    });
    return true;
  }

  Future<List<Member>> fetchMembers() async {
    List<Member> list = [];

    await _firestore
        .collection("/registeredMembers")
        .orderBy('dateOfReg', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(Member.fromMap(element.data()));
      });
    });
    return list;
  }

  Future<void> updatePaymentStatus(Member memberData) async {
    await _firestore
        .collection("/registeredMembers")
        .doc(memberData.email)
        .update({"isPaid": true});
  }

  Future<void> postPaymentDetails(Map<String, dynamic> memberData) async {
    await _firestore.collection("/payments").add(memberData);
  }
}
