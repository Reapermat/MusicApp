import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/audio_player.dart';
import '../providers/models/playlist_songs.dart';
import '../widgets/error_dialog.dart';
import '../widgets/favorite_widget.dart';
import '../widgets/player_widget_small.dart';
import 'screen_arguments.dart';

class FavoriteScreen extends StatefulWidget {
  static final routeName = 'create-playlist';
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future _playlist;
  PlaylistSongs _playlistSongs;
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");

  @override
  void initState() {
    super.initState();

    setState(() {
      _playlist = _getPlaylist();
    });
  }

  @override
  void didChangeDependencies() {
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
    ScreenArguments args = ModalRoute.of(context)
        .settings
        .arguments; //need to send when it starts here

    if (args.audioPlayer != null) {
      if (_audioPlayer != null) {
        if (_audioPlayer.audio.path !=
                _assetsAudioPlayer.current.value.audio.audio.path &&
            args.audioPlayer.audio.path ==
                _assetsAudioPlayer.current.value.audio.audio.path) {
          setState(() {
            _audioPlayer = args.audioPlayer;
            _isPlaying = true;
          });
        }
      } else if (args.audioPlayer.audio.path ==
          _assetsAudioPlayer.current.value.audio.audio.path) {
        setState(() {
          _audioPlayer = args.audioPlayer;
          _isPlaying = true;
        });
      }
    }
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_audioPlayer);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_audioPlayer);
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.all(10),
          child: FutureBuilder(
              future: _playlist,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
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
                                // padding: EdgeInsets.all(10),
                                child: ListView.builder(
                                    // padding: const EdgeInsets.all(10),
                                    itemCount: _playlistSongs.total,
                                    itemBuilder: (ctx, i) {
                                      return FavoriteWidget(
                                        audioPlayer: _audioPlayer,
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
