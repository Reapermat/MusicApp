import 'package:MusicApp/providers/models/audio_player.dart';

import '../screens/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../providers/authentication.dart';
import '../providers/models/tracklist.dart';
import '../providers/models/user.dart';
import 'search_bar_main.dart';
import 'error_dialog.dart';
import 'player_widget.dart';
import './gridtile_user.dart';

class UserItemInfo extends StatefulWidget {
  @override
  _UserItemInfoState createState() => _UserItemInfoState();
}

class _UserItemInfoState extends State<UserItemInfo> {
  Future _tokenFuture;
  Tracklist _tracklist;
  User _userList;
  Playlist _playlist = Playlist();
  AudioPlayer _audioPlayer;
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("Audio_player");
  bool _isPlaying = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tokenFuture = _getToken();
      _tokenFuture.then((user) {
        _userList = user[0];
        _tracklist = user[1];
      });
    });
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  _getToken() async {
    return await Provider.of<Authentication>(context, listen: false).getToken();
  }

  _getTracklist() async {
    var provider = Provider.of<Authentication>(context, listen: false);
    return await provider.getTracklist(provider.getTrack).then((tracklist) {
      setState(() {
        _tracklist = tracklist;
        creatingPlaylist();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tokenFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            print(dataSnapshot.error);
            return ErrorDialog('Try again later');
          } else {
            if (_isInit) {
              creatingPlaylist();
              _isInit = false;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height * 0.1,
                    // width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.network(_userList.pictureMedium,
                            fit: BoxFit.cover),
                      ),
                      title: Text(
                        'hello, ${_userList.name}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Flexible(
                    flex: 0,
                    child: SearchBarMain(
                      audioPlayer: _audioPlayer,
                      onSongChange: (bool val) {
                        _isPlaying = val;
                      },
                      onAudioplayerChange: (AudioPlayer audio) {
                        print('sent audio $audio');
                        setState(() {
                          _audioPlayer = audio;
                        });
                      },
                    )),
                Flexible(
                  flex: 4,
                  fit: FlexFit.loose,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      try {
                        if (_playlist != null) {
                          _playlist.audios.clear();
                        }
                        await _getTracklist();
                      } catch (error) {
                        await showDialog(
                          context: context,
                          builder: (_) => ErrorDialog('Try again later'),
                        );
                      }
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.6,
                      // width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: _tracklist.data.length,
                        itemBuilder: (ctx, i) {
                          return GridtileUser(
                            playlist: _playlist,
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                _isPlaying
                    ? Flexible(
                        child: PlayerWidget(audioPlayer: _audioPlayer),
                        flex: 1,
                      )
                    : Flexible(child: Container(), flex: 0),
              ],
            );
          }
        }
      },
    );
  }

  void creatingPlaylist() {
    for (int i = 0; i < _tracklist.data.length; i++) {
      var tracklist = _tracklist.data.elementAt(i);
      _playlist.audios.insert(
          i,
          Audio.network(
            '${tracklist.preview}',
            metas: Metas(
              title: tracklist.title,
              artist: tracklist.artist.name,
              album: tracklist.album.title,
              image: MetasImage.network(tracklist.album.coverMedium),
            ),
          ));

      print(
          'playlist is from function ${_playlist.audios.elementAt(i).metas.title}');
    }
  }
}
