import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/audio_player.dart';
import '../widgets/error_dialog.dart';
import 'playing_control_big.dart';
import 'position_seek_widget.dart';

class PlayerWidgetBig extends StatefulWidget {
  // final AudioPlayer audioPlayer;

  // PlayerWidgetBig({this.audioPlayer});

  final Future Function(AudioPlayer) onAudioplayerChange;

  PlayerWidgetBig({this.onAudioplayerChange});

  @override
  _PlayerWidgetBigState createState() => _PlayerWidgetBigState();
}

class _PlayerWidgetBigState extends State<PlayerWidgetBig> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  bool _getError = false;
  bool _isFavorite = false;
  Map<String, bool> favMap = {'isFav': false};

  Future getFavorite;
  var _isInit = true;
  AudioPlayer _audioPlayer;

  //didDependecies change check current song if it is playlist then return bool

  @override
  void initState() {
    // _isFavorite = widget.audioPlayer.isFavorite;
    // print('isFavorite value $_isFavorite');

    // setState(() {
    // _checkFavorite(_assetsAudioPlayer.current.value.audio.audio);
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('dependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<Authentication>(context, listen: false);
    String _songId;

    // if (_isInit) {
    //   setState(() {
    //     _checkFavorite(_assetsAudioPlayer.current.value.audio.audio);
    //   });
    //   _isInit = false;
    // }
    return StreamBuilder(
        //could implement swipe to dissapear
        stream: _assetsAudioPlayer.isPlaying,
        initialData: false,
        builder: (context, snapshotPlaying) {
          final isPlaying = snapshotPlaying.data;

          print('snapshot ${snapshotPlaying.hasData}');
          print('snapshot data ${snapshotPlaying.data}');
          // if (snapshotPlaying.data) {
          //   // setState(() {
          //   _checkFavorite(_assetsAudioPlayer.current.value.audio.audio);
          //   // _isInit
          //   // });
          // }
          // _isInit = false;
          if ((_audioPlayer != null &&
                  _audioPlayer.audio.path !=
                      _assetsAudioPlayer.current.value.audio.audio.path) ||
              (_audioPlayer == null)) {
            _checkFavorite(_assetsAudioPlayer.current.value.audio.audio)
                .then((value) {
              setState(() {});
            });
          }
          _audioPlayer = AudioPlayer(
              audio: _assetsAudioPlayer.current.value.audio.audio,
              title: _assetsAudioPlayer.current.value.audio.audio.metas.title,
              imageUrl: _assetsAudioPlayer
                  .current.value.audio.audio.metas.image.path);

          // if (snapshotPlaying.hasData) {
          //   _getFavorite().then((value) {
          //     // print('favorite is $value');
          //     // setState(() {
          //     _isFavorite = value;
          //     print('favorite is $_isFavorite');
          //   });
          //   // });
          //   // });
          // }
          // print('snapshot data ${isPlaying.toString()}');
          if (!snapshotPlaying.hasData) {
            return CircularProgressIndicator();
          }

          return Column(
            //need on error or smth
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    //this is the container
                    margin: EdgeInsets.only(right: 100.0, bottom: 60),
                    alignment: Alignment.topRight,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(15)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: 15, right: 15),
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        _assetsAudioPlayer
                            .current.value.audio.audio.metas.image.path,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  alignment: Alignment.centerLeft,
                  // child: Text(this.widget.audioPlayer.title),
                  child: ListTile(
                    title: Text(
                      _assetsAudioPlayer.current.value.audio.audio.metas.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      _assetsAudioPlayer.current.value.audio.audio.metas.artist,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                        //need to change this when song is favorite
                        icon: _isFavorite
                            ? Icon(Icons.favorite,
                                color: Theme.of(context).primaryIconTheme.color)
                            : Icon(Icons.favorite_border,
                                color:
                                    Theme.of(context).primaryIconTheme.color),
                        onPressed: () {
                          _songId = _assetsAudioPlayer
                              .current.value.audio.audio.metas.id;
                          Provider.of<Authentication>(context, listen: false)
                              .addPlaylistSong(_songId)
                              .then((value) {
                            setState(() {
                              _isFavorite = value;
                            });
                          });
                          // initState();
                        }),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                    stream: _assetsAudioPlayer.realtimePlayingInfos,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }
                      if (snapshot.hasError) {
                        print('error slider');
                        return ErrorDialog('Try again later');
                      } else {
                        try {
                          RealtimePlayingInfos infos = snapshot.data;
                          if (!_getError) {
                            _isInit = true;
                            return PositionSeekWidget(
                              seekTo: (to) async {
                                _assetsAudioPlayer.seek(to);
                              },
                              duration: infos.duration,
                              currentPosition: infos.currentPosition,
                            );
                          }
                          _getError = true;
                          return SizedBox();
                        } catch (error) {
                          return ErrorDialog('Try again later');
                        }
                      }
                    }),
              ),
              Expanded(
                flex: 2,
                child: PlayerBuilder.isPlaying(
                  player: _assetsAudioPlayer,
                  builder: (context, isPlaying) {
                    return PlayingControlBig(
                      isPlaying: isPlaying,
                      onPlay: () async {
                        try {
                          setState(() {
                            _getError = false;
                          });
                          await _assetsAudioPlayer
                              .playOrPause()
                              .catchError((onError) {
                            throw onError;
                          });
                        } catch (error) {
                          print('on Error');
                          _getError = true;
                          await showDialog(
                            context: context,
                            builder: (ctx) => ErrorDialog('Try again later'),
                          );
                        }

                        // }
                      },
                      onNext: () async {
                        try {
                          setState(() {
                            _getError = false;
                          });
                          await _assetsAudioPlayer.next().catchError((onError) {
                            throw onError;
                          });
                        } catch (error) {
                          print('error');
                          _getError = true;
                          await showDialog(
                            context: context,
                            builder: (ctx) => ErrorDialog('Try again later'),
                          );
                        }

                        // });
                      },
                      onPrevious: () async {
                        try {
                          setState(() {
                            _getError = false;
                          });
                          await _assetsAudioPlayer
                              .previous()
                              .catchError((onError) {
                            throw onError;
                          });
                        } catch (error) {
                          _getError = true;
                          await showDialog(
                            context: context,
                            builder: (ctx) => ErrorDialog('Try again later'),
                          );
                        }

                        // });
                        if (_audioPlayer != null &&
                            _audioPlayer.audio.path !=
                                _assetsAudioPlayer
                                    .current.value.audio.audio.path) {
                          print('hello');
                          _checkFavorite(
                                  _assetsAudioPlayer.current.value.audio.audio)
                              .then((value) {
                            setState(() {});
                          });
                        }
                        _audioPlayer = AudioPlayer(
                            audio: _assetsAudioPlayer.current.value.audio.audio,
                            title: _assetsAudioPlayer
                                .current.value.audio.audio.metas.title,
                            imageUrl: _assetsAudioPlayer
                                .current.value.audio.audio.metas.image.path);
                        widget.onAudioplayerChange(_audioPlayer);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  Future wait(int i) async {
    await Future.delayed(Duration(milliseconds: i));
  }

  Future _checkFavorite(Audio audio) {
    print('checking');
    var provider = Provider.of<Authentication>(context, listen: false);
    return provider.checkSong(audio).then((value) {
      _isFavorite = value;
      print(_isFavorite);
      // if (_isFavorite) {
      // setState(() {});
      // }
    });
  }
}
