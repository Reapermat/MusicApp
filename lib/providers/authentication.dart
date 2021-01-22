import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';

import 'models/playlist.dart';
import 'models/playlist_songs.dart';
import 'models/tracklist.dart';
import 'models/user.dart';

class Authentication extends ChangeNotifier {
  final String appId = '448382';
  final String appSecret = 'e0ffd93069935ddca1c8ae6dfddb2d7d';
  final String redirectUri = 'https://www.google.com/oauth2redirect';
  final String customUriScheme = 'google.com';

  String _tracklist;
  String _code;
  String _accessToken;
  int _userId;
  String _playlistTracklist;
  Tracklist _tracklistList;
  User _userList;
  Playlist _playlistList;
  PlaylistSongs _playlistSongs;
  int _playlistId;

  void setCode(String code) {
    _code = code;
  }

  String get getCode {
    return _code;
  }

  String get getAccessToken {
    return _accessToken;
  }

  String get getTrack {
    return _tracklist;
  }

  Future<void> getToken() async {
    final url =
        'https://connect.deezer.com/oauth/access_token.php?app_id=$appId&secret=$appSecret&code=$getCode&output=json';
    try {
      await http.post(url).then((response) {
        // errory porobic dla wszystkich
        final responseData = response.body;
        print('responseData $responseData');
        var tknresp = AccessTokenResponse.fromHttpResponse(response);
        _accessToken = tknresp.accessToken;
        print('token $_accessToken');
      }).catchError((error) {
        print('this is error $error');
        throw error;
      });
      await getUser(_accessToken);
    } catch (error) {
      //not really catching the error
      return throw error;
    }
    notifyListeners();
    return [
      _userList,
      _tracklistList,
    ];
  }

  Future<User> getUser(String token) async {
    final url = 'https://api.deezer.com/user/me?access_token=$token';

    print(url);
    try {
      final response = await http.get(url);
      _userList = userFromJson(response.body);
      _tracklist = _userList.tracklist;
      _userId = _userList.id;

      await getTracklist(_userList.tracklist);
      notifyListeners();
      return _userList;
    } catch (error) {
      return throw error;
    }
  }

  Future<Tracklist> getTracklist(String tracklist) async {
    final url = tracklist;
    try {
      final response = await http.get(url);
      _tracklistList = tracklistFromJson(response.body);
      print(response.body);
      print('first song id ${_tracklistList.data.first.id}');
      return _tracklistList;
    } catch (error) {
      return throw error;
    }
  }

  Future<PlaylistSongs> getPlaylist() async {
    final url =
        'https://api.deezer.com/user/${_userId}/playlists?access_token=$_accessToken';
    print(url);
    try {
      final response = await http.get(url);
      _playlistList = playlistFromJson(response.body);
      print('playlist ${response.body}');
      _playlistTracklist = _playlistList.data.first.tracklist;
      _playlistId = _playlistList.data.first.id;
      await getPlaylistSongs(_playlistTracklist);

      return _playlistSongs;
    } catch (error) {
      throw error;
    }
  }

  Future<PlaylistSongs> getPlaylistSongs(String playlistTracklist) async {
    //notifyListeners
    final url = playlistTracklist;
    try {
      final response = await http.get(url);
      print(url);
      print('playlist songs ${response.body}');
      _playlistSongs = playlistSongsFromJson(response.body);
      return _playlistSongs;
      //need to add song then check what the json will spit out
    } catch (error) {
      throw error;
    }
  }

//fix this thing
  // Future<bool> checkSong(AssetsAudioPlayer assetsAudioPlayer) async {
  //   await getPlaylist().then((value) {
  //     for (int i = 0; i < value.total; i++) {
  //       if (value.data.elementAt(i).id.toString() == assetsAudioPlayer.id) {
  //         print('same song!');
  //         notifyListeners();
  //         return true;
  //       }
  //     }
  //   }).catchError((onError) {
  //     throw onError;
  //   });
  //   return false;
  // }

  Future<void> addPlaylistSong(String songId) async {
    if (_playlistId == null) {
      await getPlaylist();
    }
    final url =
        'https://api.deezer.com/playlist/$_playlistId/tracks?access_token=$_accessToken&songs=$songId';
    print(url);
    try {
      await http.post(url).then((response) {
        print(response.body);
        if (response.body != 'true') {
          throw Error();
        }
      });
    } catch (error) {
      throw error;
    }
  }

  Future<PlaylistSongs> deleteSong(String songId) async {
    if (_playlistId == null) {
      await getPlaylist();
    }
    final url =
        'https://api.deezer.com/playlist/$_playlistId/tracks?access_token=$_accessToken&songs=$songId';
    print(url);
    try {
      await http.delete(url).then((response) async {
        print(response.body);
        await getPlaylist();
      });
      return _playlistSongs;
    } catch (error) {
      throw error;
    }
  }

  // Future<void> addPlaylist(String playlistName) async {
  //   final url =
  //       'https://api.deezer.com/user/${_userId}/playlists?access_token=${_accessToken}?title=${playlistName}';
  //   try {
  //     await http.post(url).then((response) {
  //       final responseData = response.body;
  //       print('playlist responseData $responseData');
  //     }).catchError((onError) {
  //       throw onError;
  //     });
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
