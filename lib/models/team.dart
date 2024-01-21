class Team {
  late String teamName;
  late String description;
  late String teamImg;
  late List<dynamic> members;

  Team({
    required this.description,
    required this.teamName,
    required this.teamImg,
    required this.members,
  });

  Map toMap(Team team) {
    var data = Map<String, dynamic>();
    data['teamName'] = team.teamName;
    data['description'] = team.description;
    data['teamImg'] = team.teamImg;
    data['members'] = team.members;
    return data;
  }

  // named constructor
  Team.fromMap(Map<String, dynamic> mapData) {
    this.teamName = mapData['teamName'];
    this.description = mapData['description'];
    this.teamImg = mapData['teamImg'];
    this.members = mapData['members'];
  }
}
