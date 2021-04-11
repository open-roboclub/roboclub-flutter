class Team {
  String teamName;
  String description;
  String teamImg;
  List<dynamic> members;

  Team({
    this.description,
    this.teamName,
    this.teamImg,
    this.members,
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
