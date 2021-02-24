import 'package:MusicApp/providers/models/audio_player.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import './error_dialog.dart';
import '../providers/models/audio_player.dart';
import '../providers/models/search.dart';

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
  // .withId - Pozwala na korzystanie z jednego strumienia muzycznego w calej aplikacji 
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  Audio _audio;
  var _isFavorite = false;

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
            _assetsAudioPlayer.stop(); // gdy utwór już jest grany zatrzymuje ją
          }
          _audio = Audio.network(
            // przypisanie otrzymanych danych audio
            '${searchList.preview}', // link do utworu
            metas: Metas(
              // zapisywanie danych, które pózniej zostaną wyświetlone
              id: searchList.id.toString(),
              title: searchList.title, // tytuł piosenki
              artist: searchList.artist.name, // wykonawca utworu
              album: searchList.album.title, // nazwa albumu
              image:
                  MetasImage.network(searchList.album.coverXl), //zdjęcia albumu
            ),
          );

          await _assetsAudioPlayer
              .open(
                  _audio, // otwarcie strumienia muzycznego, utwór rozpoczyna granie
                  showNotification: true, // pokazuje powiadomienia systemowe
                  loopMode: LoopMode.single, // zapętlenie granej piosenki
                  notificationSettings: NotificationSettings(
                    stopEnabled:
                        false, //wyłączenie funkcji "stop" w powiadomieniach systemowych
                  ))
              .then((_) async {
            // _getFavorite().then(() {
            _audioPlayer = AudioPlayer(
                audio: _audio,
                title: searchList.title,
                imageUrl: searchList.album.coverXl,
                isFavorite: _isFavorite);
            widget.onSongChange(true);
            widget.onAudioplayerChange(_audioPlayer);
            // });
          })
              //when song ends then start playing that playlist from main?
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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            searchList.album.coverMedium,
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

  _listen() async {
    _assetsAudioPlayer.playlistAudioFinished.listen((stopped) async {
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
        }
      });
    });
  }
}
