import 'package:flutter/material.dart';

class PrimaryColor {
  final Map<int, Color> color = {
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
  MaterialColor colorCustom;

  setColor() {
    colorCustom = MaterialColor(0xF2E2E36, color);
  }

  MaterialColor get getColor{
    return colorCustom;
  }
}
