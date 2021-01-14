import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/playlist_songs.dart';
import '../widgets/error_dialog.dart';
import '../widgets/playlist_widget.dart';
import '../providers/models/audio_player.dart';
import '../widgets/player_widget_small.dart';
import 'screen_arguments.dart';

class PlaylistScreen extends StatefulWidget {
  static final routeName = 'create-playlist';
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Future _playlist;
  PlaylistSongs _playlistSongs;
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _playlist = _getPlaylist();
    });
  }

  @override
  void didChangeDependencies() {
    print('dependecies');

    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (args.audioPlayer != null) {
      _audioPlayer = args.audioPlayer;
      _isPlaying = true;
    }

    super.didChangeDependencies();
  }

  _getPlaylist() async {
    return await Provider.of<Authentication>(context, listen: false)
        .getPlaylist()
        .then((playlist) {
      setState(() {
        _playlistSongs = playlist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_audioPlayer);
        print('pop');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('playlist'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //doesnt work when system presses back set onWillPop
              print('pop');
              Navigator.of(context).pop(_audioPlayer);
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
              future: _playlist,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    print(dataSnapshot.error);
                    return ErrorDialog('Try again later');
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 5,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                try {
                                  await _getPlaylist();
                                } catch (error) {
                                  await showDialog(
                                    context: context,
                                    builder: (_) =>
                                        ErrorDialog('Try again later'),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: _playlistSongs.total,
                                    itemBuilder: (ctx, i) {
                                      return PlaylistWidget(
                                        playlistSongs: _playlistSongs,
                                        i: i,
                                        onSongChange: (bool val) {
                                          _isPlaying = val;
                                        },
                                        onAudioplayerChange:
                                            (AudioPlayer audio) {
                                          setState(() {
                                            _audioPlayer = audio;
                                          });
                                        },
                                        onSongDeleted: (bool val) {
                                          setState(() async {
                                            if (val) {
                                              await _getPlaylist();
                                            }
                                          });
                                        },
                                      );
                                    }),
                              ),
                            )),
                        _isPlaying
                            ? Flexible(
                                child: PlayerWidgetSmall(
                                    audioPlayer: _audioPlayer),
                                flex: 1,
                              )
                            : Flexible(child: Container(), flex: 0),
                      ],
                    );
                  }
                }
              }),
        ),
      ),
    );
  }
}
