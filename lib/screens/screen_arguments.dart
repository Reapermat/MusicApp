import '../providers/models/audio_player.dart';

class ScreenArguments {
  final String search;
  final bool error;
  final AudioPlayer audioPlayer;

  ScreenArguments({this.search, this.error, this.audioPlayer});
}
