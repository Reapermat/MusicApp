import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/playlist_songs.dart';

class PlaylistScreen extends StatefulWidget {
  static final routeName = 'create-playlist';
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  PlaylistSongs _playlistSongs;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Authentication>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('playlist'),
      ),
      body: Container(
        child: Column(
          children: [
            RaisedButton(
                child: Text('add song'),
                onPressed: () {
                  // provider.addPlaylistSong();
                }),
            RaisedButton(
                child: Text('Get playlist'),
                onPressed: () {
                  provider.getPlaylist()
                  .then((playlistSongs) {
                    _playlistSongs = playlistSongs;
                    print(_playlistSongs.data.first.title);
                  });
                })
          ],
        ),
      ),
    );
  }
}
