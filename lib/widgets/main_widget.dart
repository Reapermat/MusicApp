import 'package:MusicApp/providers/models/audio_player.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/tracklist.dart';
import '../providers/models/user.dart';
import 'error_dialog.dart';
import 'gridtile_main.dart';
import 'player_widget_small.dart';

class MainWidget extends StatefulWidget {
  final Future Function(AudioPlayer) onAudioplayerChange;

  final Function(bool) onSongChange;

  final AudioPlayer poppedAudioPlayer;

  MainWidget(
      {this.onAudioplayerChange, this.onSongChange, this.poppedAudioPlayer});
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  Future _tokenFuture;
  Tracklist _tracklist;
  User _userList;
  Playlist _playlist = Playlist();
  AudioPlayer _audioPlayer;
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  bool _isPlaying = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      _tokenFuture = _getToken();
      _tokenFuture.then((user) {
        _userList = user[0];
        _tracklist = user[1];
      });
    });
  }

  @override
  void didChangeDependencies() {
    // if (widget.poppedAudioPlayer != null) {
    //   _audioPlayer = widget.poppedAudioPlayer;
    //   _isPlaying = true;
    // }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  _getToken() async {
    return await Provider.of<Authentication>(context, listen: false).getToken();
  }

  _getTracklist() async {
    var provider = Provider.of<Authentication>(context, listen: false);
    return await provider.getTracklist(provider.getTrack).then((tracklist) {
      setState(() {
        _tracklist = tracklist;
        creatingPlaylist();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.poppedAudioPlayer != null) {
      if (_audioPlayer != null) {
        if (_audioPlayer.audio.path !=
                _assetsAudioPlayer.current.value.audio.audio.path &&
            widget.poppedAudioPlayer.audio.path ==
                _assetsAudioPlayer.current.value.audio.audio.path) {
          setState(() {
            _audioPlayer = widget.poppedAudioPlayer;
            _isPlaying = true;
          });
        }
      } else if (widget.poppedAudioPlayer.audio.path ==
          _assetsAudioPlayer.current.value.audio.audio.path) {
        setState(() {
          _audioPlayer = widget.poppedAudioPlayer;
          _isPlaying = true;
        });
      }
    }

    return FutureBuilder(
      future: _tokenFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return ErrorDialog('Try again later');
          } else {
            if (_isInit) {
              creatingPlaylist();
              _isInit = false;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.network(_userList.pictureMedium,
                            fit: BoxFit.cover),
                      ),
                      title: Text(
                        'hello, ${_userList.name}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  // fit: FlexFit.loose,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 60.0, top: 60),
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(15)),
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () async {
                          try {
                            if (_playlist != null) {
                              _playlist.audios.clear();
                            }
                            await _getTracklist();
                          } catch (error) {
                            await showDialog(
                              context: context,
                              builder: (_) => ErrorDialog('Try again later'),
                            );
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(5.0),
                            itemCount: _tracklist.data.length,
                            itemBuilder: (ctx, i) {
                              return GridtileMain(
                                playlist: _playlist,
                                i: i,
                                onSongChange: (bool val) {
                                  _isPlaying = val;
                                },
                                onAudioplayerChange: (AudioPlayer audio) {
                                  setState(() {
                                    _audioPlayer = audio; //send it to screen
                                    widget.onAudioplayerChange(_audioPlayer);
                                    widget.onSongChange(true);
                                  });
                                },
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _isPlaying
                    ? Expanded(
                        child: PlayerWidgetSmall(
                          audioPlayer: _audioPlayer,
                          onAudioplayerChange: (AudioPlayer audio) {
                            setState(() {
                              _audioPlayer = audio;
                            });
                            widget.onAudioplayerChange(_audioPlayer);
                            widget.onSongChange(true);
                          },
                        ),
                        flex: 1,
                      )
                    : Expanded(child: Container(), flex: 0),
              ],
            );
          }
        }
      },
    );
  }

  void creatingPlaylist() {
    for (int i = 0; i < _tracklist.data.length; i++) {
      var tracklist = _tracklist.data.elementAt(i);
      _playlist.audios.insert(
          i,
          Audio.network(
            '${tracklist.preview}',
            metas: Metas(
              id: tracklist.id.toString(),
              title: tracklist.title,
              artist: tracklist.artist.name,
              album: tracklist.album.title,
              image: MetasImage.network(tracklist.album.coverXl),
            ),
          ));
    }
  }
}
