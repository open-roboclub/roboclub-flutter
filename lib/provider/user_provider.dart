import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User();

  User get getUser {
    return _user;
  }

  set setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
