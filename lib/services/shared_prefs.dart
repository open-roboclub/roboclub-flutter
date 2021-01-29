import 'package:shared_preferences/shared_preferences.dart';

class MyLocalStorage {
  //setter functions
  setTheme(bool darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', darkMode);
  }

  //getter functions
  Future<bool> getThemepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode');
  }

  // clear local storage
  clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("darkMode");
  }
}
