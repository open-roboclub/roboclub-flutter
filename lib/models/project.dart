class Project {
  late List<dynamic> projectImg;
  late String name;
  late String description;
  late String date;
  String progress = "";
  late List<dynamic> teamMembers;
  late String fileUrl;
  late String link;

  Project({
    required this.projectImg,
    required this.description,
    required this.name,
    required this.date,
    this.progress = "",
    required this.teamMembers,
    required this.fileUrl,
    required this.link,
  });

  Map toMap(Project project) {
    var data = Map<String, dynamic>();
    data['name'] = project.name;
    data['projectImg'] = project.projectImg;
    data['description'] = project.description;
    data['date'] = project.date;
    data['progress'] = project.progress;
    data['teamMembers'] = project.teamMembers;
    data['fileUrl'] = project.fileUrl;
    data['link'] = project.link;

    return data;
  }

  // Named constructor
  Project.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.projectImg = mapData['projectImg'];
    this.description = mapData['description'];
    this.date = mapData['date'];
    this.progress = mapData['progress'];
    this.teamMembers = mapData['teamMembers'];
    this.fileUrl = mapData['fileUrl'];
    this.link = mapData['link'];
  }
}
