import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../providers/authentication.dart';
import '../providers/models/tracklist.dart';
import '../providers/models/user.dart';
import 'search_bar_main.dart';

class UserItemInfo extends StatefulWidget {
  @override
  _UserItemInfoState createState() => _UserItemInfoState();
}

class _UserItemInfoState extends State<UserItemInfo> {
  Future tokenFuture;
  Tracklist _tracklist;
  User _userList;

  @override
  void initState() {
    super.initState();
    setState(() {
      tokenFuture = _getToken();
      tokenFuture.then((user) {
        _userList = user[0];
        _tracklist = user[1];
      });
    });
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
    final assetsAudioPlayer = AssetsAudioPlayer();

    return FutureBuilder(
      future: tokenFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            print(dataSnapshot.error);
            // ...
            // Do error handling stuff
            return Center(
              child: Text('An error occurred!'),
            );
          } else {
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
                    onRefresh: () => _getTracklist(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: _tracklist.data.length,
                        itemBuilder: (ctx, i) {
                          var tracklist = _tracklist.data.elementAt(i);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: GridTile(
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    print('tracklist duration ${tracklist.duration}');
                                    await assetsAudioPlayer.open(
                                      Audio.network(tracklist.preview)  //works but when refresh then 2 start playing 
                                    );
                                  } catch (error) {
                                    throw error;
                                  }
                                },
                                child: Image.network(
                                  tracklist.album.coverMedium,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              footer: GridTileBar(
                                backgroundColor: Colors.black87,
                                title: Text(
                                  tracklist
                                      .title, // spoko by bylo jakos caly teskt pokazac jak by byl za dlugi - taka animacje
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
              ],
            );
          }
        }
      },
    );
  }
}
