import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/themes.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/provider/theme_provider.dart';
import 'package:roboclub_flutter/screens/event_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then(
    (prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? false;
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeNotifier>(
              create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
            ),
          ],
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'AMURoboclub',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      // darkTheme: darkTheme,
      home: EventScreen(),
    );
  }
}
