import 'package:MusicApp/screens/screen_arguments.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../providers/models/audio_player.dart';
import 'playing_control_small.dart';
import '../screens/current_song_screen.dart';

class PlayerWidgetSmall extends StatefulWidget {
  AudioPlayer audioPlayer;

  final Future Function(AudioPlayer) onAudioplayerChange;

  PlayerWidgetSmall({this.audioPlayer, this.onAudioplayerChange});
  // final Playlist playlist;

  // PlayerWidget({this.playlist});
  //Future needed

  @override
  _PlayerWidgetSmallState createState() => _PlayerWidgetSmallState();
}

class _PlayerWidgetSmallState extends State<PlayerWidgetSmall> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  AudioPlayer _poppedAudioPlayer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        
        print('player widget height ${constraints.biggest.height}');
        print('player widget width ${constraints.biggest.width}');
        return StreamBuilder(
            stream: _assetsAudioPlayer.isPlaying,
            initialData: false,
            builder: (context, snapshotPlaying) {
              final isPlaying = snapshotPlaying.data;
              return Container(
                // margin: EdgeInsets.all(4),
                // style: NeumorphicStyle(
                //   boxShape:
                //       NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                // ),
                padding: const EdgeInsets.all(12.0),
                child: 
                // Column(
                //   children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              //await zrobic
                              final result = await Navigator.of(context)
                                  .pushNamed(CurrentSongScreen.routeName);
                                  print(result);
                              if (result != null) {
                                _poppedAudioPlayer = result;
                                if (widget.audioPlayer != null) {
                                  print(
                                      'widget is ${widget.audioPlayer.title}');
                                  if (_poppedAudioPlayer.audio.path !=
                                      widget.audioPlayer.audio.path) {
                                    widget.audioPlayer = _poppedAudioPlayer;
                                    widget.onAudioplayerChange(
                                        widget.audioPlayer);
                                  }
                                } else {
                                  widget
                                      .onAudioplayerChange(_poppedAudioPlayer);
                                }
                              }
                              // Navigator.of(context).pushNamed(
                              //     CurrentSongScreen.routeName);
                              // arguments: ScreenArguments(
                              //     audioPlayer: widget.audioPlayer));
                              //                               final result = await Navigator.of(context).pushNamed(
                              //   SearchScreen.routeName,
                              //   arguments:
                              //       ScreenArguments(search: input, audioPlayer: widget.audioPlayer),
                              //   // maybe its not sending it correctly
                              // );

                              // if (result != null) {
                              //   _poppedAudioPlayer = result;
                              //   if (widget.audioPlayer != null) {
                              //     print('widget is ${widget.audioPlayer.title}');
                              //     if (_poppedAudioPlayer.audio.path != widget.audioPlayer.audio.path) {
                              //       widget.audioPlayer = _poppedAudioPlayer;
                              //       widget.onAudioplayerChange(widget.audioPlayer);
                              //       widget.onSongChange(true);
                              //       //callback
                              //     }
                              //   } else {
                              //     //callback
                              //     //_poppedAudioPlayer
                              //     widget.onAudioplayerChange(_poppedAudioPlayer);
                              //     widget.onSongChange(true);
                              //     print('should call?');
                              //   }
                              // }
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      widget.audioPlayer.imageUrl,
                                      // _assetsAudioPlayer.current.value.audio.audio.metas.image.path,
                                      // widget.playlist.audios.elementAt(index).
                                      height: constraints.maxHeight * 0.585,
                                      // width: 25,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(this.widget.audioPlayer.title, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
                                    // child: Text(_assetsAudioPlayer.current.value.audio.audio.metas.title),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: PlayingControlSmall(
                                    isPlaying: isPlaying,
                                    onPlay: () {
                                      if (_assetsAudioPlayer.current.value ==
                                          null) {
                                        _assetsAudioPlayer.open(
                                            widget.audioPlayer.audio,
                                            autoStart: true);
                                      } else {
                                        _assetsAudioPlayer.playOrPause();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                //   ],
                // ),
              );
            });
      },
    );
  }
}
