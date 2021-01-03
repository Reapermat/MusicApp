import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';

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
  Tracklist _tracklistList;
  User _userList;

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
      });
      await getUser(_accessToken);
    } catch (error) {
      throw error;
    }
    print('last');
    notifyListeners();
    print(_userList);
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
      print(response.body);
      print('tracklist is ${_userList.tracklist}');
      print(_userList.pictureMedium);
      _tracklist = _userList.tracklist;

      await getTracklist(_userList.tracklist);
      notifyListeners();
      return _userList;
    } catch (error) {
      throw error;
    }
  }

  Future<Tracklist> getTracklist(String tracklist) async {
    final url = tracklist;
    try {
      final response = await http.get(url);
      _tracklistList = tracklistFromJson(response.body);
      print(response.body);
      return _tracklistList;
    } catch (error) {
      throw error;
    }
  }
}
