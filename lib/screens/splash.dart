import 'package:flutter/material.dart';

import 'package:custom_splash/custom_splash.dart';
import '../main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomSplash(
       
            duration: 4,
            backGroundColor: Colors.black,
            imagePath:'assets/3dgifmaker9.gif',
            animationEffect: 'zoom-in',
            logoSize: 100,
            home: MyApp(),


    ));
  }
}