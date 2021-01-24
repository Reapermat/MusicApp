import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../providers/models/audio_player.dart';
import '../screens/current_song_screen.dart';
import 'playing_control_small.dart';

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
        return StreamBuilder(
            stream: _assetsAudioPlayer.isPlaying,
            initialData: false,
            builder: (context, snapshotPlaying) {
              final isPlaying = snapshotPlaying.data;
              return Container(
                color: Theme.of(context).primaryColorLight,
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          //await zrobic
                          final result = await Navigator.of(context)
                              .pushNamed(CurrentSongScreen.routeName);
                          if (result != null) {
                            _poppedAudioPlayer = result;
                            if (widget.audioPlayer != null) {
                              if (_poppedAudioPlayer.audio.path !=
                                  widget.audioPlayer.audio.path) {
                                widget.audioPlayer = _poppedAudioPlayer;
                                widget.onAudioplayerChange(widget.audioPlayer);
                              }
                            } else {
                              widget.onAudioplayerChange(_poppedAudioPlayer);
                            }
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  widget.audioPlayer.imageUrl,
                                  height: constraints.maxHeight * 0.585,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  this.widget.audioPlayer.title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
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
              );
            });
      },
    );
  }
}
