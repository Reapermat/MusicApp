import 'package:MusicApp/providers/models/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';

import '../providers/models/search.dart';
import './error_dialog.dart';
import '../providers/authentication.dart';
import '../providers/models/audio_player.dart';

class SearchListView extends StatefulWidget {
  Search searchElem;
  int i;
  AudioPlayer audioPlayer;

  final Function(bool) onSongChange;

  final Future Function(AudioPlayer) onAudioplayerChange;

  SearchListView(
      {@required this.searchElem,
      @required this.i,
      @required this.onAudioplayerChange,
      @required this.onSongChange,
      this.audioPlayer});

  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  var _isFavorite = false;
  Audio _audio;
  AudioPlayer _audioPlayer;
  @override
  Widget build(BuildContext context) {
    var searchList = widget.searchElem.data.elementAt(widget.i);

    _audioPlayer = widget.audioPlayer;
    if (_assetsAudioPlayer.currentLoopMode.index == 2) {
      _listen();
    }

    return GestureDetector(
      onTap: () async {
        try {
          if (_assetsAudioPlayer.isPlaying.value) {
            _assetsAudioPlayer.stop();
          }
          _audio = Audio.network(
            '${searchList.preview}',
            metas: Metas(
              id: searchList.id.toString(),
              title: searchList.title,
              artist: searchList.artist.name,
              album: searchList.album.title,
              image: MetasImage.network(searchList.album.coverMedium),
            ),
          );
          // _audioPlayer = AudioPlayer(
          //     audio: _audio,
          //     title: searchList.title,
          //     imageUrl: searchList.album.coverMedium);

          await _assetsAudioPlayer //listen like in gridTileView
              .open(_audio,
                  showNotification: true,
                  loopMode: LoopMode.single,
                  notificationSettings: NotificationSettings(
                    stopEnabled: false,
                  ))
              .then((_) async {
            // _getFavorite().then(() {
            _audioPlayer = AudioPlayer(
                audio: _audio,
                title: searchList.title,
                imageUrl: searchList.album.coverMedium,
                isFavorite: _isFavorite);
            widget.onSongChange(true);
            widget.onAudioplayerChange(_audioPlayer);
            // });
          })
              //when song ends then start playing that playlist from main?!!!!
              //when song ends nothing happens for now

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
      },
      child: ListTile(
        contentPadding:
            EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
        leading:
            // CircleAvatar(
            //   backgroundImage: NetworkImage(searchList.album.coverSmall),
            // ),

            ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            searchList.album.coverMedium,
            // _assetsAudioPlayer.current.value.audio.audio.metas.image.path,
            // widget.playlist.audios.elementAt(index).
            // height: constraints.maxHeight * 0.585,
            // width: 25,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          searchList.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
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
  _listen() async {
    _assetsAudioPlayer.playlistAudioFinished.listen((stopped) async {
      Future.delayed(Duration(seconds: 1)).then((_) async {
        print(_assetsAudioPlayer.current.value.audio.audio.path);
        print(_audioPlayer.audio.path);
        if (_assetsAudioPlayer.current.value.audio.audio.path !=
            _audioPlayer.audio.path) {
          
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
}
