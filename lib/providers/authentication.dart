import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';

import 'models/tracklist.dart';
import 'models/user.dart';
import './user_tracklist.dart';

// class UserItem {
//   final int id;
//   final String name;
//   final String lastName;
//   final String firstName;
//   final String email;
//   final String pictureMedium;
//   final String pictureBig;
//   final String trackList;

//   UserItem({
//     @required this.id,
//     @required this.name,
//     @required this.lastName,
//     @required this.trackList,
//     @required this.firstName,
//     this.email,
//     this.pictureBig,
//     this.pictureMedium,
//   });
// }

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

  // List<UserItem> _userList = [];

  // List<UserItem> get users {
  //   return [..._userList];
  // }

  void setCode(String code) {
    _code = code;
  }

  String get getCode {
    return _code;
  }

  String get getAccessToken {
    return _accessToken;
  }

  Future<void> getToken() async {
    final url =
        'https://connect.deezer.com/oauth/access_token.php?app_id=$appId&secret=$appSecret&code=$getCode&output=json';
    try {
      await http.post(url).then((response) {
        // errory porobic dla wszystkich
        final responseData = response.body;
        print('responseData $responseData');
        // notifyListeners();
        var tknresp = AccessTokenResponse.fromHttpResponse(response);
        _accessToken = tknresp.accessToken;
        print('token $_accessToken');
      });
      await getUser(_accessToken);
      // .then((user) {
      //   _userList = user;
      //   return _userList;
      // });
    } catch (error) {
      throw error;
    }
    print('last');
    notifyListeners();
    return [
      _userList,
      _tracklistList
    ]; //trza bedzie returnąć trackList i user, albo jakos dostac ten User znowu
  }

  Future<User> getUser(String token) async {
    final url = 'https://api.deezer.com/user/me?access_token=$token';
    print(url);
    try {
      final response = await http.get(url);
      _userList = userFromJson(response.body);
      print(response.body);

      //   final extractedData = json.decode(response.body);
      //   print('this is extracted $extractedData');
      //   if (extractedData == null) {
      //     return;
      //   }
      //   loadedUser.add(
      //     UserItem(
      //       id: extractedData['id'],
      //       name: extractedData['name'],
      //       lastName: extractedData['lastname'],
      //       trackList: extractedData['tracklist'],
      //       firstName: extractedData['firstname'],
      //       email: extractedData['email'],
      //       pictureBig: extractedData['picture_big'],
      //       pictureMedium: extractedData['picture_medium'],
      //     ),
      //   );
      //   _userList = loadedUser;
      //   _tracklist = extractedData['tracklist'];
      // });

      await getTracklist(_userList.tracklist);
      // .then((list) {  // tu 
      //   _tracklistList = list;
      //   return _tracklistList;
      // });
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
