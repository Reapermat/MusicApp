import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayer with ChangeNotifier {
  Audio audio;
  String title;
  String imageUrl;

  AudioPlayer(
      {@required this.audio, @required this.title, @required this.imageUrl});

  Audio get getAudio {
    return audio;
  }

  String get getTitle {
    return title;
  }

  String get getImageUrl {
    return imageUrl;
  }
}
