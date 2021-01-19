import 'package:flutter/material.dart';
import './theme_data.dart';

class ThemeNotifier with ChangeNotifier{
  // will need this for creating settings page when smth clicked it is all here 
  // https://levelup.gitconnected.com/flutter-custom-dynamic-theme-b3e9b70fcd71

  ThemeData _themeData = blueTheme;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}