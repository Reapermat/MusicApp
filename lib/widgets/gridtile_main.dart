import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/models/audio_player.dart';
import 'error_dialog.dart';
import '../providers/authentication.dart';

class GridtileMain extends StatefulWidget {
  Playlist playlist = Playlist();

  int i;

  final Function(bool) onSongChange;

  final Future Function(AudioPlayer) onAudioplayerChange;

  GridtileMain(
      {@required this.playlist,
      @required this.i,
      @required this.onSongChange,
      @required this.onAudioplayerChange});
  @override
  _GridtileMainState createState() => _GridtileMainState();
}

class _GridtileMainState extends State<GridtileMain> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  AudioPlayer _audioPlayer;
  var _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () async {
            try {
              if (_assetsAudioPlayer.isPlaying.value) {
                _assetsAudioPlayer.stop();
              }

              await startMusicOnClick();
            } catch (error) {
              widget.onSongChange(false);
              await showDialog(
                context: context,
                builder: (ctx) => ErrorDialog('Try again later'),
              );
            }
          },
          child: Image.network(
            widget.playlist.audios.elementAt(widget.i).metas.image.path,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            widget.playlist.audios.elementAt(widget.i).metas.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future startMusicOnClick() async {
    await _assetsAudioPlayer.open(widget.playlist,
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings: NotificationSettings(
          stopEnabled: false,
          customPrevAction: ((player) async {
            //make onAudioPlayer chaged when this is clicked
            //check how the prev button actually works in the file
            player.previous();
            Future.delayed(Duration(seconds: 1)).then((_) {
              print(
                  'player is ${player.current.value.audio.audio.metas.title}');
              print(
                  'player is assest: ${_assetsAudioPlayer.current.value.audio.audio.metas.title}');
              _audioPlayer = AudioPlayer(
                  audio: player.current.value.audio.audio,
                  title: player.current.value.audio.audio.metas.title,
                  imageUrl: player.current.value.audio.audio.metas.image.path);
              widget.onAudioplayerChange(_audioPlayer);
            });
          }),
        ));

    await _assetsAudioPlayer.playlistPlayAtIndex(widget.i).then((_) async {
      _audioPlayer = AudioPlayer(
          audio: widget.playlist.audios.elementAt(widget.i),
          title: widget.playlist.audios.elementAt(widget.i).metas.title,
          imageUrl: widget.playlist.audios.elementAt(widget.i).metas.image.path,
          isFavorite: _isFavorite);

      widget.onSongChange(true);
      widget.onAudioplayerChange(_audioPlayer);
      // });
    });
    _assetsAudioPlayer.playlistAudioFinished.listen((stopped) async {
      //when goes previous it doesnt call this one
      //when i click prev button then call this??
      Future.delayed(Duration(seconds: 1)).then((_) async {
        if (_assetsAudioPlayer.current.value.audio.audio.path !=
            _audioPlayer.audio.path) {
          _audioPlayer = AudioPlayer(
              audio: _assetsAudioPlayer.current.value.audio.audio,
              title: _assetsAudioPlayer.current.value.audio.audio.metas.title,
              imageUrl:
                  _assetsAudioPlayer.current.value.audio.audio.metas.image.path,
              isFavorite: _isFavorite);

          widget.onAudioplayerChange(_audioPlayer);

          print('currently changed');
        }
      });
    });
  }
}
