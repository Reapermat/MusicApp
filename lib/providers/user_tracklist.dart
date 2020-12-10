import 'package:flutter/material.dart';

import 'models/tracklist_artist.dart';
import 'models/tracklist_album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserTracklist {
  final String id;
  final String title;
  final List<TracklistArtist> artist;
  final List<TracklistAlbum> album;

  UserTracklist({this.id, this.title, this.artist, this.album});
}

class Tracklist with ChangeNotifier {
  List<UserTracklist> _tracklist = [];

  List<UserTracklist> get tracklist {
    return [..._tracklist];
  }

  Future<void> getTracklist(String tracklistUrl) async{
    final url = tracklistUrl;
    final response = await http.get(url);
    final List<UserTracklist> loadedTracklist = [];
    final extractedData = json.decode(response.body);
    print(extractedData);
  }
}
