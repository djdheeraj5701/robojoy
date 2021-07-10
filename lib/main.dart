import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robo_joystick/screens/controllerScreen.dart';
import 'package:robo_joystick/services/generalServices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xff000000,
          <int, Color>{
            50: Color(0xFF000000),
            100: Color(0xFF000000),
            200: Color(0xFF000000),
            300: Color(0xFF000000),
            400: Color(0xFF000000),
            500: Color(0xff000000),
            600: Color(0xFF000000),
            700: Color(0xFF000000),
            800: Color(0xFF000000),
            900: Color(0xFF000000),
          },
        ),
      ),
      home: ControllerScreen(),
      routes: {
        '/editingpage' : (context)=>EditingPage(),
        '/settingspage':(context)=>SettingsPage(),
        '/btpage':(context)=>BTPage(),
        '/wifipage':(context)=>WiFiPage(),
      },
    );
  }
}