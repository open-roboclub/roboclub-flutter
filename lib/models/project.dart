import 'dart:html';

class Project {
  String name;
  String description;
  List<String> team;
  File file;
  String link;

  Project({
    this.description,
    this.name,
    this.team,
    this.file,
    this.link,
  });

  Map toMap(Project project) {
    var data = Map<String, dynamic>();
    data['name'] = project.name;
    data['description'] = project.description;
    data['team'] = project.team;
    data['file'] = project.file;
    data['link'] = project.link;
    return data;
  }

  // Named constructor
  Project.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.description = mapData['description'];
    this.team = mapData['team'];
    this.file = mapData['file'];
    this.link = mapData['link'];
  }
}
