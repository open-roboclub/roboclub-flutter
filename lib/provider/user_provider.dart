import 'package:flutter/material.dart';
import 'package:roboclub_flutter/models/user.dart';

class UserProvider extends ChangeNotifier {
  ModelUser _modelUser = ModelUser();

  ModelUser get getUser {
    return _modelUser;
  }

  set setUser(ModelUser modelUser) {
    _modelUser = modelUser;
    notifyListeners();
  }
}
