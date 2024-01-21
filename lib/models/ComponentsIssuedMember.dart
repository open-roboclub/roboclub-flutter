class ComponentMember {
  late String name;
  late String email;
  late String enrollNo;
  late String facultyNo;
  late bool isIssued;
  late String mobileNo;
  late String collegeName;
  late String componentsName;
  late String course;
  late String yearOfStudy;
  late String fileUrl;
  late DateTime date;

  ComponentMember({
    required this.name,
    required this.email,
    required this.enrollNo,
    required this.facultyNo,
    required this.isIssued,
    required this.mobileNo,
    required this.collegeName,
    required this.componentsName,
    required this.course,
    required this.yearOfStudy,
    required this.fileUrl,
    required this.date,
  });

  ComponentMember.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.enrollNo = mapData['enrollNo'];
    this.facultyNo = mapData['facultyNo'];
    this.isIssued = mapData['isIssued'] ?? false;
    this.mobileNo = mapData['mobileNo'];
    this.collegeName = mapData['collegeName'];
    this.componentsName = mapData['componentsName'].toString();
    this.course = mapData['course'];
    this.yearOfStudy = mapData['yearOfStudy'];
    this.fileUrl = mapData['fileUrl'];
    this.date = mapData['dateOfReg'].toDate();
  }

  Map tomap() {
    var data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['enrollNo'] = this.enrollNo;
    data['facultyNo'] = this.facultyNo;
    data['isIssued'] = this.isIssued;
    data['mobileNo'] = this.mobileNo;
    data['collegeName'] = this.collegeName;
    data['componentsName'] = this.componentsName;
    data['course'] = this.course;
    data['yearOfStudy'] = this.yearOfStudy;
    data['fileUrl'] = this.fileUrl;
    data['dateOfReg'] = this.date;
    return data;
  }
}
