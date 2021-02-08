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
    // final themeNotifier = Provider.of<ThemeNotifier>(context);
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
      // theme: themeNotifier.getTheme(),
      theme: ThemeData(
        primarySwatch: MaterialColor(4284889814, {
          50: Color(0xffefeafb),
          100: Color(0xffded5f6),
          200: Color(0xffbdabed),
          300: Color(0xff9d80e5),
          400: Color(0xff7c56dc),
          500: Color(0xff5b2cd3),
          600: Color(0xff4923a9),
          700: Color(0xff371a7f),
          800: Color(0xff241254),
          900: Color(0xff12092a)
        }),
        brightness: Brightness.light,
        primaryColor: Color(0xff663ad6),
        primaryColorBrightness: Brightness.dark,
        primaryColorLight: Color(0xffded5f6),
        primaryColorDark: Color(0xff371a7f),
        accentColor: Color(0xff5c2cd3),
        accentColorBrightness: Brightness.dark,
        canvasColor: Color(0xfffafafa),
        scaffoldBackgroundColor: Color(0xffECEAEA),
        bottomAppBarColor: Color(0xffffffff),
        cardColor: Color(0xffffffff),
        dividerColor: Color(0x1f000000),
        highlightColor: Color(0x66bcbcbc),
        splashColor: Color(0xff09C278),
        selectedRowColor: Color(0xfff5f5f5),
        unselectedWidgetColor: Color(0x8a000000),
        disabledColor: Color(0xffc2b8ee),
        buttonColor: Color(0xff6739d6),
        toggleableActiveColor: Color(0xff4a23a9),
        secondaryHeaderColor: Color(0xffefeafb),
        textSelectionColor: Color(0xffbeabed),
        cursorColor: Color(0xff6739d6),
        textSelectionHandleColor: Color(0xff9d80e5),
        backgroundColor: Color(0xffbeabed),
        dialogBackgroundColor: Color(0xffffffff),
        indicatorColor: Color(0xff5c2cd3),
        hintColor: Color(0xff999999),
        errorColor: Color(0xffd32f2f),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          minWidth: 124,
          height: 40,
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 52, right: 52),
          shape: StadiumBorder(
              side: BorderSide(
            color: Color(0xff000000),
            width: 0,
            style: BorderStyle.none,
          )),
          alignedDropdown: true,
          buttonColor: Color(0xff673ad6),
          disabledColor: Color(0xffcec7f4),
          highlightColor: Color(0x00000000),
          splashColor: Color(0x1fffffff),
          focusColor: Color(0xffc1b1f1),
          hoverColor: Color(0xfff3f3f3),
          colorScheme: ColorScheme(
            primary: Color(0xff673ad6),
            primaryVariant: Color(0xff371a7f),
            secondary: Color(0xff5c2cd3),
            secondaryVariant: Color(0xff371a7f),
            surface: Color(0xffffffff),
            background: Color(0xffbeabed),
            error: Color(0xffd32f2f),
            onPrimary: Color(0xffffffff),
            onSecondary: Color(0xffffffff),
            onSurface: Color(0xff000000),
            onBackground: Color(0xffffffff),
            onError: Color(0xffffffff),
            brightness: Brightness.light,
          ),
        ),
      ),
      // darkTheme: darkTheme,

      home: EventScreen(),
    );
  }
}
