import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:roboclub_flutter/models/team.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TeamService extends GetxController {
  final List<Team> teamsList = <Team>[].obs;
  final isLoading = false.obs;
  List<dynamic> members = [];
  String title = "";

  @override
  onInit() {
    isLoading(true);
    fetchTeams();
    super.onInit();
  }

  Future<void> fetchTeams() async {
    await _firestore.collection('/teams').get().then((teamList) {
      teamList.docs.forEach((team) {
        if (teamsList.length == 0) {
          teamsList.add(Team.fromMap(team.data()));
        } else {
          teamsList.insert(1, Team.fromMap(team.data()));
        }
      });
      isLoading(false);
    });
  }
}
