import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Remoteconfig {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> showHomeMmebershipOpen() async {
    await remoteConfig.fetchAndActivate();
    bool _isMembershipOpenHome = remoteConfig.getBool('isMembershipOpenHome');
    print(_isMembershipOpenHome);
    return _isMembershipOpenHome;
  }

  Future<bool> showMmebershipOpen() async {
    await remoteConfig.fetchAndActivate();
    bool _isMembershipOpen = remoteConfig.getBool('isMembershipOpen');
    print(_isMembershipOpen);
    return _isMembershipOpen;
  }

  Future<String> fetchRegEmailTemplate() async {
    String _content = remoteConfig.getString('registrationEmailContent');
    return _content;
  }

  Future<String> fetchPaymentConfEmailTemplate() async {
    String _content = remoteConfig.getString('paymentConfirmationEmailContent');
    return _content;
  }

  Future<String> fetchComponentsConfirmationEmail() async {
    String _content = remoteConfig.getString('ComponentsIssuedConfirmationEmail');
    return _content;
  }

  Future<String> sendGridApiFetch() async {
    String _content = remoteConfig.getString('SendGridApi');
    return _content;
  }

  Future<bool> isUpdateRequired() async {
    int latestVersion = remoteConfig.getInt('updateVersion');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int currentAppVersion = int.parse(packageInfo.buildNumber);
    if (latestVersion > currentAppVersion) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> fetchIsPaymentOpen() async {
    bool _content = remoteConfig.getBool('isPayNowOpen');
    return _content;
  }

  Future setCache() async {
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 60),
      minimumFetchInterval: Duration(seconds: 10),
    ));
  }

  int getMembershipAmount() {
    int _amount = remoteConfig.getInt('membershipAmount');
    return _amount;
  }

  // Future<bool> showDeathScreen() async {
  //   await remoteConfig.fetchAndActivate();
  //   bool deathScreen = remoteConfig.getBool('DeathScreen');
  //   return deathScreen;
  // }

  Remoteconfig() {
    this.setCache();
  }
}
