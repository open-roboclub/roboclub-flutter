import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roboclub_flutter/models/contributor.dart';

import 'dart:async';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ContributorService extends GetxController {
  var contributorsList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    isLoading(true);
    fetchContributors();
    super.onInit();
  }

  Future<bool> postContributor({
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

    await _firestore.collection("/contributors").add(data).then((value) {
      print(value);
    });
    return true;
  }

  Future<void> fetchContributors() async {
    await _firestore
        .collection("/contributors")
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Contributor contributor = Contributor.fromMap(element.data());
        DateTime _parsed = DateTime.parse(contributor.date);
        contributor.date = DateFormat('yMMMd').format(_parsed);
        contributorsList.add(Contributor.fromMap(element.data()));
      });
      isLoading(false);
    });
  }
}
