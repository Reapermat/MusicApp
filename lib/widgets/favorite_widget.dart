import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../providers/models/audio_player.dart';
import '../providers/models/playlist_songs.dart';
import 'error_dialog.dart';

class FavoriteWidget extends StatefulWidget {
  PlaylistSongs playlistSongs;

  AudioPlayer audioPlayer;

  final int i;

  final Function(bool) onSongChange;

  final Future Function(AudioPlayer) onAudioplayerChange;

  final Function(bool) onSongDeleted;

  FavoriteWidget(
      {this.playlistSongs,
      this.i,
      this.onSongChange,
      this.onAudioplayerChange,
      this.onSongDeleted,
      this.audioPlayer});

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  Audio _audio;
  AudioPlayer _audioPlayer;

  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  var _isFavorite = false;

  @override
  void initState() {
    // if assetAudioplayer is playing then send onsongChange=true, onAudioPlayerChange....
    //audioplayer=assetAudioPlayer...

    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    _audioPlayer = widget.audioPlayer;
    var playlistSongs = widget.playlistSongs.data.elementAt(widget.i);
    var provider = Provider.of<Authentication>(context, listen: false);

    if (_assetsAudioPlayer.currentLoopMode.index == 2) {
      _listen();
    }

    return ListTile(
      contentPadding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child:
            Image.network(playlistSongs.album.coverMedium, fit: BoxFit.cover),
      ),
      title: Text(
        '${playlistSongs.title}',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${playlistSongs.artist.name}',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          onPressed: () {
            provider.deleteSong(playlistSongs.id.toString());

            widget.onSongDeleted(true);
          }),
      onTap: () async {
        try {
          if (_assetsAudioPlayer.isPlaying.value) {
            _assetsAudioPlayer.stop();
          }
          _audio = Audio.network(
            playlistSongs.preview,
            metas: Metas(
              id: playlistSongs.id.toString(),
              title: playlistSongs.title,
              artist: playlistSongs.artist.name,
              album: playlistSongs.album.title,
              image: MetasImage.network(playlistSongs.album.coverMedium),
            ),
          );

          // _audioPlayer = AudioPlayer(
          //     audio: _audio,
          //     title: playlistSongs.title,
          //     imageUrl: playlistSongs.album.coverMedium);

          await _assetsAudioPlayer //listen like in gridTileView
              .open(_audio,
                  showNotification: true,
                  loopMode: LoopMode.single,
                  notificationSettings: NotificationSettings(
                    stopEnabled: false,
                  ))
              .then((_) async {
            // await _getFavorite().then(() {
            _audioPlayer = AudioPlayer(
                audio: _audio,
                title: playlistSongs.title,
                imageUrl: playlistSongs.album.coverMedium,
                isFavorite: _isFavorite);
            // });
          })
              //when song ends then start playing that playlist from main?

              .catchError((error) {
            return throw error;
          });
        } catch (error) {
          widget.onSongChange(false);
          await showDialog(
            context: context,
            builder: (ctx) => ErrorDialog('Try again later'),
          );
        }
        widget.onSongChange(true);
        widget.onAudioplayerChange(_audioPlayer);
      },
      onLongPress: () {
        //can go to big player
      },
    );
  }

  _listen() async {
    _assetsAudioPlayer.playlistAudioFinished.listen((stopped) async {
      print('you in here 1');
      //when goes previous it doesnt call this
      //when i click prev button then call this??
      Future.delayed(Duration(seconds: 1)).then((_) async {
        print('you in here 2');
        print(_assetsAudioPlayer.current.value.audio.audio.path);
        print(_audioPlayer.audio.path);
        if (_assetsAudioPlayer.current.value.audio.audio.path !=
            _audioPlayer.audio.path) {
          print('you in here 3');
          _audioPlayer = AudioPlayer(
              audio: _assetsAudioPlayer.current.value.audio.audio,
              title: _assetsAudioPlayer.current.value.audio.audio.metas.title,
              imageUrl:
                  _assetsAudioPlayer.current.value.audio.audio.metas.image.path,
              isFavorite: _isFavorite);

          widget.onAudioplayerChange(_audioPlayer);
        }
      });
    });
  }

  // _getFavorite() async {
  //   //spierdolone to jest //trzeba porownac po porstu czy ten id jest w liscie czy nie jak jest to value smienic i tyle!!
  //   Provider.of<Authentication>(context, listen: false)
  //       .getPlaylist()
  //       .then((songs) {
  //     _isFavorite = false;
  //     for (int i = 0; i < songs.data.length; i++) {
  //       if (_assetsAudioPlayer.current.value.audio.audio.metas.id ==
  //           songs.data.elementAt(i).id.toString()) {
  //         print(i);
  //         // setState(() {
  //         _isFavorite = true;
  //         // });
  //         // break;
  //       }
  //     }
  //   });
  //   return _isFavorite;
  // }
}
