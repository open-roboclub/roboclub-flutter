import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/team.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TeamService {
  Future<List<Team>> fetchTeams() async {
    List<Team> list = [];
    await _firestore.collection('/teams').get().then((teamsList) {
      teamsList.docs.forEach((team) {
        list.add(Team.fromMap(team.data()));
      });
    });
    return list;
  }
}
