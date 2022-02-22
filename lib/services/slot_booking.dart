import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:roboclub_flutter/models/team.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SlotService {
  Future<Map> fetch() async {
    Map slot = {};
    await _firestore.collection('/slots').get().then((slots) {
      slots.docs.forEach((value) {
        slot = value.data();
      });
    });
    return slot;
  }

  Future<void> updateSlot(Map<String, List> slot) async {
    await _firestore.collection("/slots").doc("pcb_slots").update(slot);
  }
}
