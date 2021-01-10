import 'package:MusicApp/providers/models/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../providers/models/search.dart';
import './error_dialog.dart';

class SearchListView extends StatefulWidget {
  Search searchElem;
  int i;
  final Function(bool) onSongChange;

  final Future Function(AudioPlayer) onAudioplayerChange;

  SearchListView(
      {@required this.searchElem,
      @required this.i,
      @required this.onAudioplayerChange,
      @required this.onSongChange});

  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");

  @override
  Widget build(BuildContext context) {
    var searchList = widget.searchElem.data.elementAt(widget.i);
    Audio _audio;
    AudioPlayer _audioPlayer;

    return GestureDetector(
      onTap: () async {
        try {
          if (_assetsAudioPlayer.isPlaying.value) {
            _assetsAudioPlayer.stop();
          }
          _audio = Audio.network(
            '${searchList.preview}',
            metas: Metas(
              title: searchList.title,
              artist: searchList.artist.name,
              album: searchList.album.title,
              image: MetasImage.network(searchList.album.coverMedium),
            ),
          );
          _audioPlayer = AudioPlayer(
              audio: _audio,
              title: searchList.title,
              imageUrl:
                  searchList.album.coverMedium); //musibyc taki sam jak tamten

          await _assetsAudioPlayer
              .open(_audio,
                  showNotification: true,
                  notificationSettings: NotificationSettings(
                    stopEnabled: false,
                  ))
              //when song ends then start playing that playlist?

              .catchError((error) {
            return throw error;
          });
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => ErrorDialog('Try again later'),
          );
        }
        widget.onSongChange(true);
        widget.onAudioplayerChange(_audioPlayer);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(searchList.album.coverSmall),
        ),
        title: Text(searchList.title),
      ),
    );
  }
}
