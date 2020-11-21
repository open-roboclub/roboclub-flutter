class User {
  String uid;
  String name;
  String email;
  String profileImageUrl;
  String position;
  String about;
  String batch;
  String cvLink;
  String interests;
  String contact;
  String fbId;
  String linkedinId;
  String instaId;
  bool isMember;
  bool isAdmin;

  User({
    this.uid,
    this.name,
    this.email,
    this.profileImageUrl,
    this.about,
    this.batch,
    this.contact,
    this.cvLink,
    this.fbId,
    this.instaId,
    this.interests,
    this.isAdmin,
    this.isMember,
    this.linkedinId,
    this.position,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data["profileImageUrl"] = user.profileImageUrl;
    data["about"] = user.about;
    data["batch"] = user.batch;
    data["contact"] = user.contact;
    data["cvLink"] = user.cvLink;
    data["fbId"] = user.fbId;
    data["instaId"] = user.instaId;
    data["interests"] = user.interests;
    data["isAdmin"] = user.isAdmin;
    data["isMember"] = user.isMember;
    data["linkedinId"] = user.linkedinId;
    data["position"] = user.position;

    return data;
  }

  // Named constructor
  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.profileImageUrl = mapData['profileImageUrl'];
    this.about = mapData['about'];
    this.batch = mapData['batch'];
    this.contact = mapData['contact'];
    this.cvLink = mapData['cvLink'];
    this.fbId = mapData['fbId'];
    this.instaId = mapData['instaId'];
    this.interests = mapData['interests'];
    this.isAdmin = mapData['isAdmin'];
    this.isMember = mapData['isMember'];
    this.linkedinId = mapData['linkedinId'];
    this.position = mapData['position'];
  }
}
