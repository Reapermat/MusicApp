import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';
import 'package:provider/provider.dart';

class Authentication extends ChangeNotifier {
  final String appId = '448382';
  final String appSecret = 'e0ffd93069935ddca1c8ae6dfddb2d7d';
  final String redirectUri = 'https://www.google.com/oauth2redirect';
  final String customUriScheme = 'google.com';
  String _code;
  String _accessToken;

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
      await http
      .post(url)
      .then((response) {
        final responseData = response.body;
        print('responseData $responseData');
        // notifyListeners();
        var tknresp = AccessTokenResponse.fromHttpResponse(response);
        _accessToken = tknresp.accessToken;
        print('token $_accessToken');
        return _accessToken;
      });
    } catch (error) {
      throw error;
    }
  }
}
