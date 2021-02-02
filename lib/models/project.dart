

class Project {
  String projectImg;
  String name;
  String description;
  String date;
  // List<String> teamMembers;
  String memberImg;
  // File file;
  String link;
  bool projectStatus;

  Project({
    this.projectImg,
    this.description,
    this.name,
    this.date,
    // this.teamMembers,
    this.memberImg,
    // this.file,
    this.link,
    this.projectStatus,
  });

  Map toMap(Project project) {
    var data = Map<String, dynamic>();
    data['name'] = project.name;
    data['projectImg'] = project.projectImg;
    data['description'] = project.description;
    data['date'] = project.date;
    // data['teamMembers'] = project.teamMembers;
    data['memberImg'] = project.memberImg;
    // data['file'] = project.file;
    data['link'] = project.link;
    data['projectStatus'] = project.projectStatus;

    return data;
  }

  // Named constructor
  Project.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.projectImg = mapData['projectImg'];
    this.description = mapData['description'];
    this.date = mapData['date'];
    // this.teamMembers = mapData['teamMembers'];
    this.memberImg = mapData['memberImg'];
    // this.file = mapData['file'];
    this.link = mapData['link'];
    this.projectStatus = mapData['projectStatus'];
  
  }
}

