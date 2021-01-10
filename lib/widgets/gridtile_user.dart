import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../providers/models/audio_player.dart';
import '../widgets/error_dialog.dart';

class GridtileUser extends StatefulWidget {
  Playlist playlist = Playlist();

  int i;

  final Function(bool) onSongChange;

  final Future Function(AudioPlayer) onAudioplayerChange;

  GridtileUser(
      {@required this.playlist,
      @required this.i,
      @required this.onSongChange,
      @required this.onAudioplayerChange});
  @override
  _GridtileUserState createState() => _GridtileUserState();
}

class _GridtileUserState extends State<GridtileUser> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: GridTile(
        child: GestureDetector(
          onTap: () async {
            widget.onSongChange(true);
            try {
              if (_assetsAudioPlayer.isPlaying.value) {
                _assetsAudioPlayer.stop();
              }

              await startMusicOnClick();
            } catch (error) {
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
        ));

    await _assetsAudioPlayer.playlistPlayAtIndex(widget.i).then((_) {
      _audioPlayer = AudioPlayer(
          audio: widget.playlist.audios.elementAt(widget.i),
          title: widget.playlist.audios.elementAt(widget.i).metas.title,
          imageUrl:
              widget.playlist.audios.elementAt(widget.i).metas.image.path);

      widget.onAudioplayerChange(_audioPlayer);
    });

    _assetsAudioPlayer.playlistAudioFinished.listen((stopped) async {
      Future.delayed(Duration(seconds: 1)).then((_) {
        if (_assetsAudioPlayer.current.value.audio.audio.path !=
            _audioPlayer.audio.path) {
          print('currently changed');
          _audioPlayer = AudioPlayer(
              audio: _assetsAudioPlayer.current.value.audio.audio,
              title: _assetsAudioPlayer.current.value.audio.audio.metas.title,
              imageUrl: _assetsAudioPlayer
                  .current.value.audio.audio.metas.image.path);

          widget.onAudioplayerChange(_audioPlayer);
        }
      });
    });
  }
}
