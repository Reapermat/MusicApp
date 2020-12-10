import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';

class UserItem {
  final int id;
  final String name;
  final String lastName;
  final String firstName;
  final String email;
  final String pictureMedium;
  final String pictureBig;
  final String trackList;

  UserItem({
    @required this.id,
    @required this.name,
    @required this.lastName,
    @required this.trackList,
    @required this.firstName,
    this.email,
    this.pictureBig,
    this.pictureMedium,
  });
}

class GetUser with ChangeNotifier {
  List<UserItem> _userList = [];

  List<UserItem> get users {
    return [..._userList];
  }

  Future<void> getUser(String token) async {
    final url = 'https://api.deezer.com/user/me?access_token=$token';
    final List<UserItem> loadedUser = [];
    print(url);
    try {
      await http.get(url).then((response) {
        final extractedData = json.decode(response.body);
        print('this is extracted $extractedData');
        if (extractedData == null) {
          return;
        }
        loadedUser.add(
          UserItem(
            id: extractedData['id'],
            name: extractedData['name'],
            lastName: extractedData['lastname'],
            trackList: extractedData['tracklist'],
            firstName: extractedData['firstname'],
            email: extractedData['email'],
            pictureBig: extractedData['picture_big'],
            pictureMedium: extractedData['picture_medium'],
          ),
        );
        _userList = loadedUser;
      });
    } catch (error) {
      throw error;
    }
  }
}
