import 'package:flutter/material.dart';

import '../providers/models/audio_player.dart';
import '../widgets/player_widget_big.dart';
import 'screen_arguments.dart';

class CurrentSongScreen extends StatefulWidget {
  static const routeName = '/current-song-page';
  // AudioPlayer audioPlayer;

  // CurrentSongScreen({this.audioPlayer});
  @override
  _CurrentSongScreenState createState() => _CurrentSongScreenState();
}

class _CurrentSongScreenState extends State<CurrentSongScreen> {
  // AudioPlayer _audioPlayer;
  @override
  void didChangeDependencies() {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    // if (args.audioPlayer != null) {
    //   _audioPlayer = args.audioPlayer;

    // }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer _audioPlayer;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_audioPlayer);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Now playing'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_audioPlayer);
            },
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 10),
            child: PlayerWidgetBig(
              onAudioplayerChange: (AudioPlayer audio) {
                _audioPlayer = audio;
              },
            )),
      ),
    );
  }
}
