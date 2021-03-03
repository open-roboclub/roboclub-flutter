import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/team.dart';

final Firestore _firestore = Firestore.instance;

class TeamService {
  Future<List<Team>> fetchTeams() async {
    List<Team> list = [];
    await _firestore.collection('/teams').getDocuments().then((teamsList) {
      teamsList.documents.forEach((team) {
        list.add(Team.fromMap(team.data));
      });
    });
    return list;
  }
}
