import 'package:flutter/material.dart';
import '../widgets/player_widget_big.dart';

import '../providers/models/audio_player.dart';
import 'screen_arguments.dart';

class CurrentSongScreen extends StatefulWidget {
  static const routeName = '/current-song-page';
  // AudioPlayer audioPlayer;

  // CurrentSongScreen({this.audioPlayer});
  @override
  _CurrentSongScreenState createState() => _CurrentSongScreenState();
}

class _CurrentSongScreenState extends State<CurrentSongScreen> {
  AudioPlayer _audioPlayer;
  @override
  void didChangeDependencies() {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (args.audioPlayer != null) {
      _audioPlayer = args.audioPlayer;
      // _isPlaying = true;
      print('args is playing');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Front Page'),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: PlayerWidgetBig(audioPlayer: _audioPlayer)),
    );
  }
}
