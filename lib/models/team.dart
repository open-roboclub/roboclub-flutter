class Team {
  String teamName;
  String description;
  String teamImg;
  List<dynamic> members;

  Team({this.description, this.teamName, this.teamImg, this.members});

  Map toMap(Team contributor) {
    var data = Map<String, dynamic>();
    data['teamName'] = contributor.teamName;
    data['description'] = contributor.description;
    data['teamImg'] = contributor.teamImg;
    data['members'] = contributor.members;
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
