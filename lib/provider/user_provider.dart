import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User();

  User get getUser {
    return _user;
  }

  set setUser(User user) {
    _user = user;
    print('!!!!!!!!' * 5);
    print("user changed");
    print(user.name);
    print(user.isAdmin);
    notifyListeners();
  }
}
