class Member {
  late String name;
  late String email;
  late String enrollNo;
  late String facultyNo;
  late bool isPaid;
  late String mobileNo;
  late String collegeName;
  late String course;
  late String yearOfStudy;
  late String fileUrl;
  late DateTime date;

  Member({
    required this.name,
    required this.email,
    required this.enrollNo,
    required this.facultyNo,
    required this.isPaid,
    required this.mobileNo,
    required this.collegeName,
    required this.course,
    required this.yearOfStudy,
    required this.fileUrl,
    required this.date,
  });

  Member.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.enrollNo = mapData['enrollNo'];
    this.facultyNo = mapData['facultyNo'];
    this.isPaid = mapData['isPaid'];
    this.mobileNo = mapData['mobileNo'];
    this.collegeName = mapData['collegeName'];
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
    data['isPaid'] = this.isPaid;
    data['mobileNo'] = this.mobileNo;
    data['collegeName'] = this.collegeName;
    data['course'] = this.course;
    data['yearOfStudy'] = this.yearOfStudy;
    data['fileUrl'] = this.fileUrl;
    data['dateOfReg'] = this.date;
    return data;
  }
}
