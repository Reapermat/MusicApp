import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../themes/theme_data.dart';
import '../widgets/theme_button.dart';
import '../screens/user_data_screen.dart';

class SettingsScreen extends StatefulWidget {
  static final routeName = 'settings-route';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      // drawer: AppDrawer(
      //   fromSettings: true,
      //   fromMain: false,
      //   fromFavorite: false,
      // ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.topLeft,
            child: Text(
              'Choose your color',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThemeButton(
                buttonThemeData: blueTheme,
              ),
              ThemeButton(
                buttonThemeData: pinkTheme,
              ),
              ThemeButton(
                buttonThemeData: yellowTheme,
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
                top: 30, left: 15, right: 15, bottom: 15), //we'll see

            child: Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Container(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(
                  UserDataScreen.routeName,
                );
              },
              title: Text(
                'My data',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_sharp,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Container(
            child: ListTile(
              onTap: () {
// await showDialog(
//                                   context: context,
//                                   builder: (ctx) => (AlertDialog(
//                                           title:
//                                               Text('Song successfully added!'),
//                                           actions: <Widget>[
//                                             FlatButton(
//                                                 child: Text('Okay'),
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 })
//                                           ])))

                showDialog(
                    context: context,
                    builder: (ctx) => (AlertDialog(
                            backgroundColor: blueTheme.primaryColor,
                            actionsPadding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: Text(
                              'Are you sure you want to log out?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            actions: <Widget>[
                              Container(
                                width: 80,
                                height: 40,
                                child: OutlineButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  textColor: Colors.white,
                                  borderSide: BorderSide(color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            LoginScreen.routeName,
                                            (Route<dynamic> route) => false);
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 40,
                                child: OutlineButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  textColor: Colors.white,
                                  borderSide: BorderSide(color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ])));

                // Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              title: Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.logout,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
