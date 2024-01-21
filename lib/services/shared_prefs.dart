import 'package:shared_preferences/shared_preferences.dart';

class MyLocalStorage {
  //setter functions

  setTheme(bool darkMode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setBool('darkMode', darkMode);
  }

  //getter functions
  Future<bool> getThemepref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool('darkMode') ?? false;
  }

  setDeviceToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setString('deviceToken', token);
  }

  //getter functions
  Future<String> getDeviceToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    return _prefs.getString('deviceToken') ?? "";
  }

  setOnboarding(bool isDone) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setBool('onboarding', isDone);
  }

  //getter functions
  Future<bool> getOnboarding() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool('onboarding') ?? false;
  }

  setCheckUpdate(String lastChecked) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setString('update', lastChecked);
  }

  //getter functions
  Future<String> getCheckUpdate() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    return _prefs.getString('update') ?? "";
  }

  // clear local storage
  clearPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.remove("darkMode");
  }
}
