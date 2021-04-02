import 'package:flutter/material.dart';

final blueAccent = Color(0xFF7981D0);
final pinkAccent = Color(0xFFFE8D87);
final yellowAccent = Color(0xFFE1D43B);
final blackAccent = Color(0xFF22222A);

final Map<int, Color> colorSwatch = {
  50: Color.fromRGBO(34, 34, 42, .1),
  100: Color.fromRGBO(34, 34, 42, .2),
  200: Color.fromRGBO(34, 34, 42, .3),
  300: Color.fromRGBO(34, 34, 42, .4),
  400: Color.fromRGBO(34, 34, 42, .5),
  500: Color.fromRGBO(34, 34, 42, .6),
  600: Color.fromRGBO(34, 34, 42, .7),
  700: Color.fromRGBO(34, 34, 42, .8),
  800: Color.fromRGBO(34, 34, 42, .9),
  900: Color.fromRGBO(34, 34, 42, 1),
};

final blueTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF22222A, colorSwatch),
  primaryColorLight: Color.fromRGBO(46, 46, 54, 0.5),
  accentColor: blueAccent,
  primaryIconTheme: IconThemeData(color: Colors.white),
  fontFamily: 'Montserrat',
  canvasColor: blackAccent,
  textTheme: TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
    headline4: TextStyle(),
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  accentIconTheme: IconThemeData(color: Colors.white),
);

final pinkTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF22222A, colorSwatch),
  accentColor: pinkAccent,
  fontFamily: 'Montserrat',
  canvasColor: blackAccent,
  textTheme: TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
    headline4: TextStyle(),
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  accentIconTheme: IconThemeData(color: Colors.white),
);

final yellowTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF22222A, colorSwatch),
  accentColor: yellowAccent,
  fontFamily: 'Montserrat',
  canvasColor: blackAccent,
  textTheme: TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
    headline4: TextStyle(),
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  accentIconTheme: IconThemeData(color: Colors.white),
);
