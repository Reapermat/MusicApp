import 'dart:async';
import 'dart:convert';

import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './deezer_oauth2_client.dart';

class Authentication extends ChangeNotifier {
  final String appId = '448382';
  final String appSecret = 'e0ffd93069935ddca1c8ae6dfddb2d7d';
  final String redirectUri = 'https://www.google.com/oauth2redirect';
  final String customUriScheme = 'google.com';
  String _code;
  String _accessToken;
  WebView _webView;

  void setCode(String code) {
    _code = code;
  }

  String get getCode {
    return _code;
  }

  Future<void> getUser() async {
    final url =
        'https://connect.deezer.com/oauth/access_token.php?app_id=$appId&secret=$appSecret&code=$getCode&output=json';
    try {
      http.post(url).then((response) {
        final responseData = response.body;
        print('responseData $responseData');
        // notifyListeners();
        var tknresp = AccessTokenResponse.fromHttpResponse(response);
        _accessToken = tknresp.accessToken;
        print('tokeeen $_accessToken');
      });
    } catch (error) {
      throw error;
    }
  }
}
