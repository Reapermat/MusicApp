import 'package:flutter/material.dart';

final blueAccent = Color(0xFF7981D0);
final pinkAccent = Color(0xFFFE8D87);
final yellowAccent = Color(0xFFE1D43B);

final Map<int, Color> colorSwatch = {
  50: Color.fromRGBO(46, 46, 54, .1),
  100: Color.fromRGBO(46, 46, 54, .2),
  200: Color.fromRGBO(46, 46, 54, .3),
  300: Color.fromRGBO(46, 46, 54, .4),
  400: Color.fromRGBO(46, 46, 54, .5),
  500: Color.fromRGBO(46, 46, 54, .6),
  600: Color.fromRGBO(46, 46, 54, .7),
  700: Color.fromRGBO(46, 46, 54, .8),
  800: Color.fromRGBO(46, 46, 54, .9),
  900: Color.fromRGBO(46, 46, 54, 1),
};

final blueTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF2E2E36, colorSwatch),
  // primaryColor: Colors.white,
  accentColor: blueAccent,
  fontFamily: 'Montserrat',
  appBarTheme: AppBarTheme(textTheme: TextTheme(headline4: TextStyle(color: Colors.white ))),
  textTheme: TextTheme(headline4: TextStyle(color: Colors.white)),
  // primaryTextTheme: TextTheme(headline1: TextStyle(color: Colors.white))
);

final pinkTheme = ThemeData(
    primarySwatch: MaterialColor(0xFF2E2E36, colorSwatch),
    accentColor: pinkAccent,
    fontFamily: 'Montserrat',
    textTheme: TextTheme(headline1: TextStyle(color: Colors.white)));

final yellowTheme = ThemeData(
    primarySwatch: MaterialColor(0xFF2E2E36, colorSwatch),
    accentColor: yellowAccent,
    fontFamily: 'Montserrat',
    textTheme: TextTheme(headline1: TextStyle(color: Colors.white)));
