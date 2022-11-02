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

  Future<bool> isMember(String email) async {
    try {
      var docSnap =
          await _firestore.collection('/registeredMembers').doc(email).get();
      return docSnap.data()?['isPaid']??false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateSlot(Map<String, List> slot) async {
    await _firestore.collection("/slots").doc("pcb_slots").update(slot);
  }
}
