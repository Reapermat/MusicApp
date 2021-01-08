import 'package:MusicApp/providers/models/tracklist.dart';
import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import '../providers/models/audio_player.dart';
import '../widgets/error_dialog.dart';
import '../screens/screen_arguments.dart';

class GridtileUser extends StatefulWidget {
  Playlist playlist = Playlist();

  AudioPlayer audioPlayer;

  int i;

  Tracklist tracklist;

  GridtileUser({this.playlist, this.audioPlayer, this.tracklist, this.i});
  @override
  _GridtileUserState createState() => _GridtileUserState();
}

class _GridtileUserState extends State<GridtileUser> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");

  @override
  Widget build(BuildContext context) {
    return ClipRRect( 
      //maybe use streams so it changes that thing at the bottom
      borderRadius: BorderRadius.circular(7),
      child: GridTile(
        child: GestureDetector(
          onTap: () async {
            print(
                'this is gridTile ${widget.playlist.audios.elementAt(widget.i).metas.title}');
            try {
              // setState(() { //set state doesnt change the state for the other screen
                if (_assetsAudioPlayer.isPlaying.value) {
                  _assetsAudioPlayer.stop();
                }
              // });

              print('this is gridTile one ${widget.i}');
              widget.audioPlayer = AudioPlayer(
                  audio: widget.playlist.audios.elementAt(widget.i),
                  title: widget.playlist.audios.elementAt(widget.i).metas.title,
                  imageUrl: widget.playlist.audios
                      .elementAt(widget.i)
                      .metas
                      .image
                      .path);
              await startMusic(widget.playlist, widget.i);
              ScreenArguments(audioPlayer: widget.audioPlayer);
            } catch (error) {
              await showDialog(
                context: context,
                builder: (ctx) => ErrorDialog('Try again later'),
              );
            }
          },
          child: Image.network(
            widget.tracklist.data.elementAt(widget.i).album.coverMedium,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            widget.tracklist.data
                .elementAt(widget.i)
                .title, // spoko by bylo jakos caly teskt pokazac jak by byl za dlugi - taka animacje
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future startMusic(Playlist playlist, int _index) async {
    await _assetsAudioPlayer.open(playlist,
        loopMode: LoopMode.playlist, showNotification: true);
    await _assetsAudioPlayer.playlistPlayAtIndex(_index);
  }
}
