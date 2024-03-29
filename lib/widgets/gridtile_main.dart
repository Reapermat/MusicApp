import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/audio_player.dart';
import 'error_dialog.dart';

class GridtileMain extends StatefulWidget {
  Playlist playlist = Playlist();

  int i;

  // bool initState;
  bool checkFavorite;

  final Function(bool) onSongChange;

  final Future Function(AudioPlayer) onAudioplayerChange;

  GridtileMain({
    @required this.playlist,
    @required this.i,
    @required this.onSongChange,
    @required this.onAudioplayerChange,
    @required this.checkFavorite,
    // @required this.initState
  });
  @override
  _GridtileMainState createState() => _GridtileMainState();
}

class _GridtileMainState extends State<GridtileMain> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  AudioPlayer _audioPlayer;
  var _isFavorite = false;
  var _initState = true;
  var _check = false;

  @override
  Widget build(BuildContext context) {
    _check = widget.checkFavorite;

    if (_initState || _check) {
      // _isFavorite = false;
      print('init state is ${widget.checkFavorite}');
      _checkFavorite(
          widget.playlist.audios.elementAt(widget.i)); //only when refresh
      _initState = false;
      _check = false;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          // Wychwytuje gesty użytkownika
          onTap: () async {
            // Wychwytuje dotyk ekranu
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
            textAlign: TextAlign.left,
          ),
          trailing: IconButton(
            icon: _isFavorite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            onPressed: () {
              //add to Favorites
              _initState = true;
              Provider.of<Authentication>(context, listen: false)
                  .addPlaylistSong(
                      widget.playlist.audios.elementAt(widget.i).metas.id)
                  .then((value) {
                print('the value is $value');
                setState(() {
                  // _initState=true;
                  print('in here');
                  _isFavorite = value;
                });
                // _initState = false;
              });
              _isFavorite = false;
            },
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
      //when goes previous it doesnt call this
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

  Future _checkFavorite(Audio audio) {
    print('checking');
    var provider = Provider.of<Authentication>(context, listen: false);
    return provider.checkSong(audio).then((value) {
      _isFavorite = value;

      print('is favorite is $_isFavorite');
    });
  }
}
