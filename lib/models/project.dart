

class Project {
  String projectImg;
  String name;
  String description;
  String date;
  // List<String> teamMembers;
 
  String fileUrl;
  String link;
  

  Project({
    this.projectImg,
    this.description,
    this.name,
    this.date,
    // this.teamMembers,
    
    this.fileUrl,
    this.link,
    
  });

  Map toMap(Project project) {
    var data = Map<String, dynamic>();
    data['name'] = project.name;
    data['projectImg'] = project.projectImg;
    data['description'] = project.description;
    data['date'] = project.date;
    // data['teamMembers'] = project.teamMembers;
    
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
    // this.teamMembers = mapData['teamMembers'];
   
    this.fileUrl = mapData['fileUrl'];
    this.link = mapData['link'];
  
  
  }
}

