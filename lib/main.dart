import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:roboclub_flutter/helper/themes.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/theme_provider.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/screens/event_screen.dart';
import 'package:roboclub_flutter/services/auth.dart';
import 'package:roboclub_flutter/services/notification.dart';
import 'package:roboclub_flutter/services/shared_prefs.dart';

void main() async {
  // debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  MyLocalStorage _storage = MyLocalStorage();
  var darkModeOn = await _storage.getThemepref() ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  MyLocalStorage _storage = MyLocalStorage();
  @override
  void initState() {
    _storage.getDeviceToken().then((value) {
      if (value == null) {
        _messaging.getToken().then((fcmToken) {
          print("fcm saved to storage!");
          NotificationService().postDeviceToken(fcmToken: fcmToken);
          _storage.setDeviceToken(fcmToken);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    AuthService().getCurrentUser().then((currUser) {
      if (currUser != null) {
        _userProvider.setUser = currUser;
      } else {
        _userProvider.setUser = User();
      }
    });

    return MaterialApp(
      title: 'AMURoboclub',

      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      // theme: ThemeData(),
      // darkTheme: darkTheme,

      home: EventScreen(),
    );
  }
}
