import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/ComponentsIssuedMember.dart';

import 'dart:async';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ComponentsIssuedService {
  Future<bool> postMember({
    String? name,
    String? email,
    String? enrollNo,
    String? course,
    String? collegeName,
    String? componentsName,
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
      "componentsName": componentsName,
      "yearOfStudy": yearOfStudy,
      "mobileNo": mobileNo,
      "dateOfReg": DateTime.now(),
      "isIssued": false
    };

    await _firestore
        .collection("/registeredForComponents")
        .doc(email)
        .set(data)
        .then((value) {
      print("Success");
    });
    return true;
  }

  Future<List<ComponentMember>> fetchMembers() async {
    List<ComponentMember> list = [];

    await _firestore
        .collection("/registeredForComponents")
        .orderBy('dateOfReg', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(ComponentMember.fromMap(element.data()));
      });
    });
    return list;
  }

  Future<void> updatePaymentStatus(ComponentMember memberData) async {
    await _firestore
        .collection("/registeredForComponents")
        .doc(memberData.email)
        .update({"isIssued": true});
  }

  Future<void> postPaymentDetails(Map<String, dynamic> memberData) async {
    await _firestore.collection("/payments").add(memberData);
  }
}
