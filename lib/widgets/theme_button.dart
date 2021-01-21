import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_notifier.dart';

class ThemeButton extends StatelessWidget {
  final ThemeData buttonThemeData;

  ThemeButton({this.buttonThemeData});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifier>(context);
    bool _selected = (themeProvider.getTheme() == buttonThemeData);

    return Container(
      height: 64,
      width: 64,
      margin: EdgeInsets.all(15),
      child: RaisedButton(
          shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  color:
                      _selected ? Colors.white : buttonThemeData.primaryColor,
                      width: 3.0),
                      ),
          color: buttonThemeData.accentColor,
          onPressed: () {
            themeProvider.setTheme(buttonThemeData);
          }),
    );
  }
}
