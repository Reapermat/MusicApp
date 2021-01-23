
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

    super.initState();

    // setState(() {
    //   _getFavorite().then((value) {
    //     // print('favorite is $value');
    //     setState(() {
    //       _isFavorite = value;
    //       print('favorite is $_isFavorite');
    //     });
    //   });
    // });
  }

  Future<bool> _getFavorite() async {
    bool favorite =
        false;    //trzeba porownac po porstu czy ten id jest w liscie czy nie jak jest to value smienic i tyle!
    return await Provider.of<Authentication>(context, listen: false)
        .getPlaylist()
        .then((songs) {
      for (int i = 0; i < songs.data.length; i++) {
        if (_assetsAudioPlayer.current.value.audio.audio.metas.id ==
            songs.data.elementAt(i).id.toString()) {
          print('nr of stuff $i');
          // setState(() {
          favorite = true;
          // favMap.update('isFav', (value) => true);

          // _assetsAudioPlayer.current.value.audio.audio.metas.extra.addAll(favMap);
          return favorite;
          // });
          // break;
        }
      }
      // favMap.update('isFav', (value) => false);

      //     _assetsAudioPlayer.current.value.audio.audio.metas.extra.addAll(favMap);
      return favorite;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   Provider.of<Authentication>(context, listen: false)
  //       .checkSong(_assetsAudioPlayer)
  //       .then((value) {
  //     print('method called');
  //     setState(() {
  //       _isFavorite = value;
  //       print(_isFavorite);
  //     });
  //   });

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<Authentication>(context, listen: false);
    // Provider.of<Authentication>(context)
    //     .checkSong(_assetsAudioPlayer)
    //     .then((value) {
    //   print('method called');
    //   setState(() {
    //     _isFavorite = value;
    //   });
    // });
    String _songId;

    // _assetsAudioPlayer.current.listen((event) async {
    //   await _getFavorite().then(() {
    //     setState(() {});
    //   });

    //   _isFavorite = false;
    // });

    return StreamBuilder(
        //could implement swipe to dissapear
        stream: _assetsAudioPlayer.isPlaying,
        initialData: false,
        builder: (context, snapshotPlaying) {
          final isPlaying = snapshotPlaying.data;

          print('snapshot ${snapshotPlaying.hasData}');

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
                    // width: MediaQuery.of(context).size.width *0.6,
                    // width: ,
                    // color: color,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(15)),
                    ),
                    // child: SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.5,
                    // ),
                    //has to have child
                    //maybe boxdecoration
                  ),
                  // Padding(
                  // padding: EdgeInsets.all(4.0),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50, left: 15, right: 15),
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ClipRRect(
                      // decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.all(Radius.circular(15))),
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        _assetsAudioPlayer
                            .current.value.audio.audio.metas.image.path,
                        // widget.audioPlayer.imageUrl,
                        // widget.playlist.audios.elementAt(index).
                        // height: contraints.maxHeight * 0.585,
                        // width: 25,
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
                  margin: EdgeInsets.all(15.0),
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
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          _songId = _assetsAudioPlayer
                              .current.value.audio.audio.metas.id;

                          print(_songId);
                          _provider.addPlaylistSong(_songId).then((_) async {
                            // _getFavorite();

                            await showDialog(
                                context: context,
                                builder: (ctx) => (AlertDialog(
                                        title: Text('Song successfully added!'),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('Okay'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              })
                                        ]))).then((_) {});
                            // setState(() {});
                            // _isFavorite = false; //not sure about this
                          }).catchError((onError) async {
                            await showDialog(
                                context: context,
                                builder: (ctx) => ErrorDialog(
                                    'Song already exists in Favorites'));
                          });
                          initState();
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
                            // if(infos.currentPosition.toString() == '0:00:00.000000') {
                            //   print('wainting');
                            //   sleep(Duration(milliseconds: 1000));
                            // }
                            return PositionSeekWidget(
                              //when there is an error it doesn't show and for a sec u see red stuff
                              //maybe its the neumorphic problem
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
                          print('hello error');
                          return ErrorDialog('Try again later');
                        }
                      }
                    }),
              ),
              // Expanded(
              //   flex: 1,
              //   child: IconButton(
              //       //need to change this when song is favorite
              //       icon: _isFavorite
              //           ? Icon(Icons.favorite)
              //           : Icon(Icons.favorite_border),
              //       onPressed: () {
              //         _songId =
              //             _assetsAudioPlayer.current.value.audio.audio.metas.id;

              //         print(_songId);
              //         _provider.addPlaylistSong(_songId).then((_) async {
              //           // _getFavorite();

              //           await showDialog(
              //               context: context,
              //               builder: (ctx) => (AlertDialog(
              //                       title: Text('Song successfully added!'),
              //                       actions: <Widget>[
              //                         FlatButton(
              //                             child: Text('Okay'),
              //                             onPressed: () {
              //                               Navigator.of(context).pop();
              //                             })
              //                       ]))).then((_) {});
              //           // setState(() {});
              //           // _isFavorite = false; //not sure about this
              //         }).catchError((onError) async {
              //           await showDialog(
              //               context: context,
              //               builder: (ctx) => ErrorDialog(
              //                   'Song already exists in Favorites'));
              //         });
              //         initState();
              //       }),
              // ),
              Expanded(
                flex: 2,
                child: PlayerBuilder.isPlaying(
                  player: _assetsAudioPlayer,
                  builder: (context, isPlaying) {
                    // _assetsAudioPlayer.onErrorDo = (_) {
                    //   return ErrorDialog('please try again later');
                    // };
                    return PlayingControlBig(
                      isPlaying: isPlaying,
                      onPlay: () async {
                        // didChangeDependencies();
                        // if (_assetsAudioPlayer.current.value == null) {
                        //   try {
                        //     _assetsAudioPlayer
                        //         .open(widget.audioPlayer.audio,
                        //             autoStart: true)
                        //         .catchError((onError) {
                        //       throw onError;
                        //     });
                        //   } catch (error) {
                        //     return ErrorDialog(//not working
                        //         'please try again later');
                        //   }
                        // } else {
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
                        // didChangeDependencies();
                        // setState(() {
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
                        // didChangeDependencies();
                        // setState(() {
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
}
