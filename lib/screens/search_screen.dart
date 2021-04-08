import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen_arguments.dart';
import '../providers/models/audio_player.dart';
import '../providers/models/search.dart';
import '../providers/search_content.dart';
import '../widgets/error_dialog.dart';
import '../widgets/player_widget_small.dart';
import '../widgets/search_listview.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = 'search-screen';

  // SearchScreen({this.search});
  // String search;
  // Playlist playlist;

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
    ScreenArguments args = ModalRoute.of(context).settings.arguments;

    if (args.search != null) {
      search = args.search;
    }
    if (args.audioPlayer != null) {
      _audioPlayer = args.audioPlayer;
      _isPlaying = true;
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
    // Provider - tworzy bezpośredni kanał komunikacyjny z podaną klasą
    try {
      return await provider.getSearchContent(search);
    } catch (error) {
      return throw error;
    }
  }

  _submit(String input) {
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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_audioPlayer);
      },
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Search'),
          centerTitle: true,
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
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(6),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                            ),

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
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )),
                // fit: FlexFit.tight,
              ), //what to do when in this page
              Expanded(
                flex: 4,
                child: FutureBuilder(
                  future: _searchFuture,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (dataSnapshot.error != null) {
                        return ErrorDialog('Try again later');
                      } else {
                        return ListView.builder(
                          itemCount: _searchElem.data.length,
                          itemBuilder: (ctx, i) {
                            return SearchListView(
                              audioPlayer: _audioPlayer,
                              searchElem: _searchElem,
                              i: i,
                              onSongChange: (bool val) {
                                _isPlaying = val;
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
                  ? Expanded(
                      child: PlayerWidgetSmall(audioPlayer: _audioPlayer),
                      flex: 1,
                    )
                  : Expanded(child: Container(), flex: 0),
            ],
          ),
        ),
      ),
    );
  }
}
