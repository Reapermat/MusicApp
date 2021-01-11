import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';

import './screen_arguments.dart';
import '../providers/models/search.dart';
import '../providers/search_content.dart';
import '../widgets/error_dialog.dart';
import '../providers/models/audio_player.dart';
import '../widgets/search_listview.dart';
import '../widgets/player_widget.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = 'search-screen';

  // SearchScreen({this.search});
  // String search;
  Playlist playlist;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future _searchFuture;
  Search _searchElem;
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  // final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  // Audio _audio;
  AudioPlayer _audioPlayer;
  String search;
  bool _isPlaying = false;

  @override
  void didChangeDependencies() {
    print('dependecies');

    ScreenArguments args = ModalRoute.of(context).settings.arguments;

    if (args.search != null) {
      search = args.search;
    }
    if (args.audioPlayer != null) {
      _audioPlayer = args.audioPlayer;
      _isPlaying = true;
      print('args is playing');
    }

    if (_isInit) {
      _searchFuture = _getSearch();
    }
    _searchFuture.then((searchElem) {
      _searchElem = searchElem;
    });
    super.didChangeDependencies();
  }

  _getSearch() async {
    var provider = Provider.of<SearchContent>(context, listen: false);
    try {
      print('from getSearch $search');
      return await provider.getSearchContent(search);
    } catch (error) {
      return throw error;
    }
  }

  _submit(String input) {
    print('should be in here');
    _isInit = false;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    search = input;
    _searchFuture = _getSearch();
    _searchFuture.then((searchElem) {
      _searchElem = searchElem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print('pop');
            Navigator.of(context).pop(_audioPlayer);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Search'),
                        initialValue: search,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (input) {
                          search = input;
                          // ScreenArguments(search: search);
                          try {
                            _submit(search);
                          } catch (error) {
                            return ErrorDialog('Try again later');
                          }
                        }, // buttona tu na pewno trza dac
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      )
                    ],
                  )),
              fit: FlexFit.tight,
            ), //what to do when in this page
            Flexible(
              flex: 4,
              child: FutureBuilder(
                future: _searchFuture,
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      print(dataSnapshot.error);
                      return ErrorDialog('Try again later');
                    } else {
                      return ListView.builder(
                        itemCount: _searchElem.data.length,
                        itemBuilder: (ctx, i) {
                          return SearchListView(
                            searchElem: _searchElem,
                            i: i,
                            onSongChange: (bool val) {
                              _isPlaying = val;
                              print('isPlaying $_isPlaying');
                            },
                            onAudioplayerChange: (AudioPlayer audio) {
                              setState(() {
                                _audioPlayer = audio;
                              });
                            },
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
            //need to put player below
            _isPlaying
                ? Flexible(
                    child: PlayerWidget(audioPlayer: _audioPlayer),
                    flex: 1,
                  )
                : Flexible(child: Container(), flex: 0),
          ],
        ),
      ),
    );
  }
}
