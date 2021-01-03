import 'dart:async';

import 'package:flutter/material.dart';
import './models/search.dart';
import 'package:http/http.dart' as http;

class SearchContent extends ChangeNotifier {
  

  Search _search;

  Future<Search> getSearchContent(String content) async {
    final url = 'https://api.deezer.com/search?q=$content';

    try {
      final response = await http.get(url);
      _search = searchFromJson(response.body);
      print(response.body);
      print(url);
      print(_search);
      return _search;
    } catch (error) {
      throw error;
    }
  }
}
