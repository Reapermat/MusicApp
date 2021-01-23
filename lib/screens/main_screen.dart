import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../providers/models/audio_player.dart';
import '../widgets/app_drawer.dart';
import '../widgets/error_dialog.dart';
import '../widgets/main_widget.dart';
import 'screen_arguments.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  static final routeName = 'main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SearchBar _searchBar;
  AudioPlayer _audioPlayer;
  AudioPlayer _poppedAudioPlayer;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      elevation: 0,
      actions: [_searchBar.getSearchAction(context)],
    );
  }

  _MainScreenState() {
    _searchBar = new SearchBar(
        inBar: true,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: _onBackPressed,
    //   child:
    return Scaffold(
      appBar: _searchBar.build(context),
      drawer: AppDrawer(
        audioPlayer:
            _audioPlayer, //when starts in main it doesnt send it need to get the auioPlayer from main
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10),
          child: MainWidget(
            poppedAudioPlayer: _audioPlayer,
            onSongChange: (bool val) {
              // _isPlaying = val;
              // print(_isPlaying);
            },
            onAudioplayerChange: (AudioPlayer audio) {
              setState(() {
                _audioPlayer = audio;
              });
            },
          )),
    );
    // );
  }

  void onSubmitted(String value) async {
    if (value.isEmpty) {
      return showDialog(
        context: context,
        builder: (_) => ErrorDialog('Please enter some text'),
      );
    } else {
      final result = await Navigator.of(context).pushNamed(
        SearchScreen.routeName,
        arguments: ScreenArguments(search: value, audioPlayer: _audioPlayer),
      );

      if (result != null) {
        _poppedAudioPlayer = result;
        if (_audioPlayer != null) {
          if (_poppedAudioPlayer.audio.path != _audioPlayer.audio.path) {
            setState(() {
              _audioPlayer = _poppedAudioPlayer;
            });
          }
        } else {
          setState(() {
            _audioPlayer = _poppedAudioPlayer;
          });
        }
      }
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
            ],
          ),
        ) ??
        false;
  }
}
