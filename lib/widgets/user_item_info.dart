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

  @override
  void didChangeDependencies() {
    print('dependecies');
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _audioPlayer = args.audioPlayer;
      print('is nul?');
    }

    super.didChangeDependencies();
  }

  _getToken() async {
    return await Provider.of<Authentication>(context, listen: false).getToken();
  }

  _getTracklist() async {
    var provider = Provider.of<Authentication>(context, listen: false);
    return await provider.getTracklist(provider.getTrack).then((tracklist) {
      setState(() {
        _tracklist = tracklist;
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
            // ...
            // Do error handling stuff
            return ErrorDialog('Try again later');
          } else {
            //tu stworzyc ta liste np _playlist
            creatingPlaylist();
            return Column(
              // tu flexible jakis dac bo jest problem z umieszczeniem tego wszystkiego
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
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
                Flexible(child: SearchBar()),
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
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: _tracklist.data.length,
                        itemBuilder: (ctx, i) {
                          return GridtileUser(
                              audioPlayer: _audioPlayer,
                              playlist: _playlist,
                              tracklist: _tracklist,
                              i: i);
                          // var tracklist = _tracklist.data.elementAt(i);
                          //tu ciagle usuwa tile ktory nie jest widoczny i psuje to czasami klikadlo
                          // https://stackoverflow.com/questions/51071906/how-to-keep-the-state-of-my-widgets-after-scrolling
                          // _playlist.audios.insert(
                          //     i,
                          //     Audio.network(
                          //       '${tracklist.preview}',
                          //       metas: Metas(
                          //         title: tracklist.title,
                          //         artist: tracklist.artist.name,
                          //         album: tracklist.album.title,
                          //         image: MetasImage.network(
                          //             tracklist.album.coverMedium),
                          //       ),
                          //     ));
                          // print(
                          //     'this is playlist ${_playlist.audios.elementAt(i).metas.title}');
                          // return ClipRRect(
                          //   borderRadius: BorderRadius.circular(7),
                          // child: GridTile(
                          //   child: GestureDetector(
                          //     onTap: () async {
                          //       try {
                          //         _index = i;
                          //         setState(() {
                          //           if (_assetsAudioPlayer.isPlaying.value) {
                          //             _assetsAudioPlayer.stop();
                          //           }
                          //         });

                          //         print('this is the main one $i');
                          //         _audioPlayer = AudioPlayer(
                          //             audio: _playlist.audios.elementAt(i),
                          //             title: _playlist.audios
                          //                 .elementAt(i)
                          //                 .metas
                          //                 .title,
                          //             imageUrl: _playlist.audios
                          //                 .elementAt(i)
                          //                 .metas
                          //                 .image
                          //                 .path);
                          //         print(
                          //             'this is main title ${_playlist.audios.elementAt(i).metas.title}');
                          //         await startMusic(_playlist, i);
                          //         ScreenArguments(audioPlayer: _audioPlayer);
                          //       } catch (error) {
                          //         await showDialog(
                          //           context: context,
                          //           builder: (ctx) =>
                          //               ErrorDialog('Try again later'),
                          //         );
                          //       }
                          //     },
                          //     child: Image.network(
                          //       tracklist.album.coverMedium,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          //   footer: GridTileBar(
                          //     backgroundColor: Colors.black87,
                          //     title: Text(
                          //       tracklist
                          //           .title, // spoko by bylo jakos caly teskt pokazac jak by byl za dlugi - taka animacje
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                          // );
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
                _audioPlayer != null
                    ? Flexible(
                        //tutaj jak zacznie grac to sie powinno pokazac np na dole TO JEST W PLIKU MAIN_MULTIPLES.DART i dziala raczej
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

  // Future startMusic(Playlist playlist, int index) async {
  //   print('this is name ${playlist.audios.elementAt(index).metas.title}');
  //   await _assetsAudioPlayer.open(
  //     // to w funkcje xD
  //     playlist.audios.elementAt(index),
  //     //problem that when i click it doesn know which one will be next i think
  //     // before was _playlist - then click doesnt work it just goes by the list
  //     showNotification: true, //when clicked next then index+1?
  //     notificationSettings: NotificationSettings(
  //       customNextAction: (player) async {
  //         if (_index < _playlist.audios.length - 1) {
  //           _index++;
  //           print('this is NOT main $_index');
  //         } else {
  //           _index = 0;
  //         }

  //         // startMusic(_playlist, _index);
  //         //player to jest tylko ten na tym indexie trza znalezc sposob zeby do nast isc
  //         //tu tez jakis setState chyba
  //         // player.open(_playlist.audios
  //         //     .elementAt(index));
  //       },
  //     ),
  //   ).catchError((error) {
  //     return throw error;
  //   });
  // }

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
