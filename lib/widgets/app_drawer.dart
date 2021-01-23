import 'package:flutter/material.dart';

import '../providers/models/audio_player.dart';
import '../screens/favorite_screen.dart';
import '../screens/screen_arguments.dart';
import '../screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  final AudioPlayer audioPlayer;

  AppDrawer({this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, top: 15, right: 15),
          height: MediaQuery.of(context).size.height * 0.15,
          alignment: Alignment.center,
          child: DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          title: Text('Main Page'),
          trailing: Icon(
            Icons.arrow_forward_sharp,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.favorite,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          title: Text('Favorites'),
          trailing: Icon(
            Icons.arrow_forward_sharp,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          onTap: () {
            Navigator.of(context).popAndPushNamed(
              //need to send audioplayer and stuff
              FavoriteScreen.routeName, // get the result to send it to main
              arguments: ScreenArguments(audioPlayer: audioPlayer),
            );
            // }
          },
        ),
        Divider(),
        ListTile(
            onTap: () {
              Navigator.of(context).popAndPushNamed(SettingsScreen.routeName);
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            title: Text('Settings'),
            trailing: Icon(
              Icons.arrow_forward_sharp,
              color: Theme.of(context).primaryIconTheme.color,
            ))
      ],
    ));
  }
}
