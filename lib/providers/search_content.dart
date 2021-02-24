import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './models/search.dart';

class SearchContent extends ChangeNotifier {
  Search _search;

  Future<Search> getSearchContent(String content) async {
    final url = 'https://api.deezer.com/search?q=$content';

    try {
      final response = await http.get(url);   //oczekiwanie na pobranie danych za pomocą funkcji get
      _search = searchFromJson(response.body);
      return _search;
    } catch (error) {
      return throw error;
    }
  }
}
