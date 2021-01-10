import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../providers/models/audio_player.dart';
import 'playing_control.dart';

class PlayerWidget extends StatefulWidget {
  final AudioPlayer audioPlayer;

  PlayerWidget({this.audioPlayer});
  // final Playlist playlist;

  // PlayerWidget({this.playlist});
  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, contraints) {
        return StreamBuilder(
            //Layout builder brooo like in the vid udemy
            stream: _assetsAudioPlayer.isPlaying,
            initialData: false,
            builder: (context, snapshotPlaying) {
              final isPlaying = snapshotPlaying.data;
              return Neumorphic(
                margin: EdgeInsets.all(4),
                style: NeumorphicStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Row(
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
                                    widget.audioPlayer.imageUrl,
                                    // widget.playlist.audios.elementAt(index).
                                    height: contraints.maxHeight * 0.585,
                                    // width: 25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(this.widget.audioPlayer.title),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: PlayingControl(
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
                      ],
                    ),
                    // StreamBuilder(
                    //     stream: _assetsAudioPlayer.realtimePlayingInfos,
                    //     builder: (context, snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return SizedBox();
                    //       }
                    //       RealtimePlayingInfos infos = snapshot.data;
                    //       return PositionSeekWidget(
                    //         seekTo: (to) {
                    //           _assetsAudioPlayer.seek(to);
                    //         },
                    //         duration: infos.duration,
                    //         currentPosition: infos.currentPosition,
                    //       );
                    //     }),
                  ],
                ),
              );
            });
      },
    );
  }
}
