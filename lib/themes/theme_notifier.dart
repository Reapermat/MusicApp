import 'package:flutter/material.dart';

import './theme_data.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData = blueTheme;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
