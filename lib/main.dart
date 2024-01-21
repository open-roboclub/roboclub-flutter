import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:flutter/services.dart';
// import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/helper/themes.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/theme_provider.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/screens/event_screen.dart';
import 'package:roboclub_flutter/screens/onboarding_screen.dart';
import 'package:roboclub_flutter/services/auth.dart';
// import 'package:roboclub_flutter/services/notification.dart';
import 'package:roboclub_flutter/services/shared_prefs.dart';

void main() async {
  // debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MyLocalStorage _storage = MyLocalStorage();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  WidgetsFlutterBinding.ensureInitialized();
  DotEnv.dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _storage.getDeviceToken().then((value) {
    _messaging.subscribeToTopic('newNotification');
    if (value == "") {
      _messaging.getToken().then((fcmToken) {
        // print("fcm saved to storage!");
        // NotificationService().postDeviceToken(fcmToken: fcmToken!);
        _storage.setDeviceToken(fcmToken!);
      });
    }
  });
  var isOnboarding = await _storage.getOnboarding();
  var darkModeOn = await _storage.getThemepref();
  // var deathScreen = await Remoteconfig().showDeathScreen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
      ],
      child: MyApp(
        isOnboarding: isOnboarding,
        // showDeathScreen: deathScreen
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnboarding;
  // final bool showDeathScreen;

  const MyApp({Key? key, this.isOnboarding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    AuthService().getCurrentUser().then((currUser) {
      if (currUser != null) {
        _userProvider.setUser = currUser;
      } else {
        _userProvider.setUser = ModelUser();
      }
    });

    return MaterialApp(
      title: 'AMURoboclub',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      // theme: ThemeData(),
      // darkTheme: darkTheme,
      home: !isOnboarding ? OnboardingScreen() : EventScreen(),
    );
  }
}
