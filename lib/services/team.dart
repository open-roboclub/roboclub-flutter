import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roboclub_flutter/models/team.dart';
import 'package:roboclub_flutter/models/user.dart';

final Firestore _firestore = Firestore.instance;

class TeamService {
  // Future<bool> addTeam(String videoId, String title) {
  //   Map<String, dynamic> _tutorial = {
  //     'videoId': videoId,
  //   };
  //   _firestore
  //       .collection('/tutorials')
  //       .document(title)
  //       .setData(_tutorial)
  //       .then((value) {
  //     return true;
  //   }).catchError((e) {
  //     return false;
  //   });
  // }

  Future<List<Team>> fetchTeams() async {
    List<Team> list = [];
    await _firestore.collection('/teams').getDocuments().then((teamsList) {
      teamsList.documents.forEach((team) {
        // List<User> userList = [];
        // team.data['members'].forEach((_user) {
        //   userList.add(User.fromMap(_user));
        // });
        // team.data['members'] = userList;
        list.add(Team.fromMap(team.data));
      });
    });
    return list;
  }

  Future<List<User>> getTeamMembers(List<dynamic> ids) async {
    List<User> list = [];
    ids.forEach((id) async {
      await _firestore
          .collection('/users')
          .document(id['email'])
          .get()
          .then((user) {
        list.add(User.fromMap(user.data));
      });
    });
    return list;
  }
}
