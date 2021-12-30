import 'package:firebase_remote_config/firebase_remote_config.dart';
class Remoteconfig{
  RemoteConfig remoteConfig = RemoteConfig.instance;

  Future<bool> showHomeMmebershipOpen() async {
      await remoteConfig.fetchAndActivate();
      bool _isMembershipOpenHome  = remoteConfig.getBool('isMembershipOpenHome');
      print(_isMembershipOpenHome);
      return _isMembershipOpenHome;
    }

    Future<bool> showMmebershipOpen() async {
      await remoteConfig.fetchAndActivate();
      bool _isMembershipOpen  = remoteConfig.getBool('isMembershipOpen');
      print(_isMembershipOpen);
      return _isMembershipOpen;
    }
    
    Future<String> fetchRegEmailTemplate() async {
      
      String _content  = remoteConfig.getString('registrationEmailContent');
      return _content;
    }

    Future setCache() async{
      await remoteConfig.fetchAndActivate();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 10),
      ));
    }
     Remoteconfig(){
       this.setCache();
     }
}
