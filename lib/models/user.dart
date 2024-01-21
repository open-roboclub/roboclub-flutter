class ModelUser {
  late String uid;
  late String name;
  late String email;
  late String profileImageUrl;
  late String position;
  late String about;
  late String batch;
  late String branch;
  late String quote;
  late String cvLink;
  late String interests;
  late String contact;
  late String fbId;
  late String linkedinId;
  late String instaId;
  late bool isMember;
  late bool isAdmin;

  ModelUser({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.profileImageUrl = "",
    this.about = "",
    this.batch = "",
    this.contact = "",
    this.quote = "",
    this.cvLink = "",
    this.fbId = "",
    this.instaId = "",
    this.interests = "",
    this.branch = "",
    this.isAdmin = false,
    this.isMember = false,
    this.linkedinId = "",
    this.position = "",
  });

  Map toMap(ModelUser user) {
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
    data["quote"] = user.quote;
    data["interests"] = user.interests;
    data["isAdmin"] = user.isAdmin;
    data["branch"] = user.branch;
    data["isMember"] = user.isMember;
    data["linkedinId"] = user.linkedinId;
    data["position"] = user.position;

    return data;
  }

  // Named constructor
  ModelUser.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.profileImageUrl = mapData['profileImageUrl'];
    this.about = mapData['about'];
    this.batch = mapData['batch'];
    this.contact = mapData['contact'];
    this.cvLink = mapData['cvLink'];
    this.fbId = mapData['fbId'];
    this.branch = mapData['branch'];
    this.instaId = mapData['instaId'];
    this.quote = mapData['quote'];
    this.interests = mapData['interests'];
    this.isAdmin = mapData['isAdmin'];
    this.isMember = mapData['isMember'];
    this.linkedinId = mapData['linkedinId'];
    this.position = mapData['position'];
  }
}
