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
      // darkTheme: darkTheme,

      home: EventScreen(),
    );
  }
}
