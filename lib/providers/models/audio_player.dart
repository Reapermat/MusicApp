import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayer with ChangeNotifier {
  //thanks to this i could access the stuff

  Audio audio;
  String title;
  String imageUrl;

  AudioPlayer(this.audio, this.title, this.imageUrl);
}
