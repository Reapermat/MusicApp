import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';
import '../screens/main_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/screen_arguments.dart';
import '../providers/models/audio_player.dart';

class AppDrawer extends StatelessWidget {

  
  AudioPlayer audioPlayer;

  AppDrawer({this.audioPlayer});

  @override
  Widget build(BuildContext context) {

    print(audioPlayer.audio.metas.title);
    
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
            // if (fromMain) {
              Navigator.of(context).pop();
            // } else {
            //   Navigator.of(context).popAndPushNamed(MainScreen.routeName);
            // }
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
            // if (fromFavorite) {
            //   Navigator.of(context).pop();
            // } else {
              print('from drawer $audioPlayer');
              Navigator.of(context).popAndPushNamed(  //need to send audioplayer and stuff
                FavoriteScreen.routeName, // get the result to send it to main
                arguments: ScreenArguments(audioPlayer: audioPlayer),
              );
            // }
          },
        ),
        Divider(),
        ListTile(
            onTap: () {
              // if (fromSettings) {
              //   Navigator.of(context).pop();
              // } else {
                Navigator.of(context).popAndPushNamed(SettingsScreen.routeName);
              // }
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
