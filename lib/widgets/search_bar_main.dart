import 'package:MusicApp/providers/models/audio_player.dart';
import 'package:MusicApp/screens/screen_arguments.dart';
import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class SearchBarMain extends StatefulWidget {
  SearchBarMain(
      {this.audioPlayer, this.onAudioplayerChange, this.onSongChange});

  AudioPlayer audioPlayer;
  //callback function
  final Future Function(AudioPlayer) onAudioplayerChange;

  final Function(bool) onSongChange;

  @override
  _SearchBarMainState createState() => _SearchBarMainState();
}

class _SearchBarMainState extends State<SearchBarMain> {
  final _form = GlobalKey<FormState>();
  AudioPlayer _poppedAudioPlayer;

  void _submit(String input) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    //check which page you're in a then do bla bla
    //if in after login then:
    // print('route is ${ModalRoute.of(context).settings.name}');
    // if (ModalRoute.of(context).settings.name != 'search-screen') {
    final result = await Navigator.of(context).pushNamed(
      SearchScreen.routeName,
      arguments:
          ScreenArguments(search: input, audioPlayer: widget.audioPlayer),
      // maybe its not sending it correctly
    );
    // send result to userItem_info
    // using stream/callback?
    // }
    // if (widget.audioPlayer == null) {

    //   return;
    // }
    if (result != null) {
      _poppedAudioPlayer = result;
      if (widget.audioPlayer != null) {
        print('widget is ${widget.audioPlayer.title}');
        if (_poppedAudioPlayer.audio.path != widget.audioPlayer.audio.path) {
          widget.audioPlayer = _poppedAudioPlayer;
          widget.onAudioplayerChange(widget.audioPlayer);
          widget.onSongChange(true);
          //callback
        }
      } else {
        //callback
        //_poppedAudioPlayer
        widget.onAudioplayerChange(_poppedAudioPlayer);
        widget.onSongChange(true);
        // print('should call?');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Search'),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (input) {
                _submit(input);
              },
              // initialValue: args == null ? null : args.search, // when you come back it would be nice to show the other text
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
            )
          ],
        ));
  }
}
