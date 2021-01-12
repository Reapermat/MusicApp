import 'dart:io';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../providers/models/audio_player.dart';
import 'position_seek_widget.dart';
import 'playing_control_big.dart';
import '../widgets/error_dialog.dart';

class PlayerWidgetBig extends StatefulWidget {
  final AudioPlayer audioPlayer;

  PlayerWidgetBig({this.audioPlayer});
  @override
  _PlayerWidgetBigState createState() => _PlayerWidgetBigState();
}

class _PlayerWidgetBigState extends State<PlayerWidgetBig> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  bool _getError = false;
  @override
  Widget build(BuildContext context) {
    //hero to sie ta animacja nazywa!
    return StreamBuilder(
        //could implement swipe to dissapear
        stream: _assetsAudioPlayer.isPlaying,
        initialData: false,
        builder: (context, snapshotPlaying) {
          final isPlaying = snapshotPlaying.data;
          return Column(
            //need on error or smth
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: 8,
                          surfaceIntensity: 1,
                          shape: NeumorphicShape.concave,
                        ),
                        child: Image.network(
                          _assetsAudioPlayer
                              .current.value.audio.audio.metas.image.path,
                          // widget.audioPlayer.imageUrl,
                          // widget.playlist.audios.elementAt(index).
                          // height: contraints.maxHeight * 0.585,
                          // width: 25,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        // child: Text(this.widget.audioPlayer.title),
                        child: Text(_assetsAudioPlayer
                            .current.value.audio.audio.metas.title),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: PlayerBuilder.isPlaying(
                        player: _assetsAudioPlayer,
                        builder: (context, isPlaying) {
                          print(
                              'big player assetPlayer ${_assetsAudioPlayer.current.value.audio.audio.metas.title}');
                          print(
                              'big player widget ${widget.audioPlayer.title}');
                          // _assetsAudioPlayer.onErrorDo = (_) {
                          //   print('smth fucked');
                          //   return ErrorDialog('please try again later');
                          // };
                          return PlayingControlBig(
                            isPlaying: isPlaying,
                            onPlay: () async {
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
                                _getError = false;
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
                                  builder: (ctx) =>
                                      ErrorDialog('Try again later'),
                                );
                              }

                              // }
                            },
                            onNext: () async {
                              // setState(() {
                              try {
                                _getError = false;
                                await _assetsAudioPlayer
                                    .next()
                                    .catchError((onError) {
                                  print('onError');
                                  throw onError;
                                });
                              } catch (error) {
                                print('error');
                                _getError = true;
                                await showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      ErrorDialog('Try again later'),
                                );
                              }

                              // });
                            },
                            onPrevious: () async {
                              // setState(() {
                              try {
                                _getError = false;
                                await _assetsAudioPlayer
                                    .previous()
                                    .catchError((onError) {
                                  throw onError;
                                });
                              } catch (error) {
                                _getError = true;
                                await showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      ErrorDialog('Try again later'),
                                );
                              }

                              // });
                            },
                          );
                        },
                      ),
                    ),
                    StreamBuilder(
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
                  ],
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
