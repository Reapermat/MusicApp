import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';

import './screen_arguments.dart';
import '../providers/models/search.dart';
import '../providers/search_content.dart';
import '../widgets/error_dialog.dart';
import '../providers/models/audio_player.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = 'search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future _searchFuture;
  Search _searchElem;
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  String _search;
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  AudioPlayer _audioPlayer; //musibyc taki sam jak tamten
  Audio _audio;

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    print('dependecies');
    if (_isInit) {
      _searchFuture = _getSearch();
    } else {
      _searchFuture = _getSearch(search: _search);
    }
    _searchFuture.then((searchElem) {
      _searchElem = searchElem;
    });
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _audioPlayer = args.audioPlayer;
    }
    super.didChangeDependencies();
  }

  _getSearch({String search}) async {
    var provider = Provider.of<SearchContent>(context, listen: false);
    if (_isInit) {
      final ScreenArguments args = ModalRoute.of(context).settings.arguments;
      search = args.search;
    }
    _search = search;

    try {
      return await provider.getSearchContent(_search);
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
    _getSearch(search: input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Page'),
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
                          initialValue: _search,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (input) {
                            _search = input;
                            ScreenArguments(search: _search);
                            try {
                              _submit(_search);
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
                flex: 5,
                child: FutureBuilder(
                  future: _searchFuture,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (dataSnapshot.error != null) {
                        print(dataSnapshot.error);
                        // ...
                        // Do error handling stuff
                        // return Center(
                        //   child: Text('An error occurred!'),
                        // );
                        return ErrorDialog('Try again later');
                      } else {
                        return ListView.builder(
                          itemCount: _searchElem.data.length,
                          itemBuilder: (ctx, i) {
                            var searchList = _searchElem.data.elementAt(i);
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  if (_assetsAudioPlayer.isPlaying.value) {
                                    _assetsAudioPlayer.stop();
                                  }
                                  _audio = Audio.network(
                                    '${searchList.preview}',
                                    metas: Metas(
                                      title: searchList.title,
                                      artist: searchList.artist.name,
                                      album: searchList.album.title,
                                      image: MetasImage.network(
                                          searchList.album.coverMedium),
                                    ),
                                  );
                                  // print('you what mate ${_audioPlayer.getTitle}');
                                  _audioPlayer = AudioPlayer(
                                      audio: _audio,
                                      title: searchList.title,
                                      imageUrl: searchList.album
                                          .coverMedium); //musibyc taki sam jak tamten
                                  ScreenArguments(audioPlayer: _audioPlayer);
                                  await _assetsAudioPlayer
                                      .open(
                                    _audio,
                                    showNotification: true,
                                  )
                                      .catchError((error) {
                                    return throw error;
                                  });
                                } catch (error) {
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) =>
                                        ErrorDialog('Try again later'),
                                  );
                                }
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(searchList.album.coverSmall),
                                ),
                                title: Text(searchList.title),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
