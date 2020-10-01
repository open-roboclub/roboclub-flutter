class User {
  String uid;
  String name;
  String email;
  String profilePhoto;
  String firebaseToken;

  User({
    this.uid,
    this.name,
    this.email,
    this.profilePhoto,
    this.firebaseToken,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data["profile_photo"] = user.profilePhoto;
    data["firebaseToken"] = user.firebaseToken;

    return data;
  }

  // Named constructor
  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.profilePhoto = mapData['profile_photo'];
    this.firebaseToken = mapData['firebaseToken'];
  }
}
