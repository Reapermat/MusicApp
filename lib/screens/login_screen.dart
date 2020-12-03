import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../providers/authentication.dart';
import 'package:provider/provider.dart';
import 'after_login.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-page';
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String code;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith('https://www.google.com/oauth2redirect')) {
            RegExp regExp = new RegExp("code=(.*)");
            this.code = regExp.firstMatch(url)?.group(1);
            print("code $code");
            Provider.of<Authentication>(context, listen: false).setCode(code);
            // Tutaj juz mozna sie wyjebac gdzies np
            Navigator.of(context).pushNamedAndRemoveUntil(
                AfterLogin.routeName, (Route<dynamic> route) => false);
            flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String appId = '448382';
    final String redirectUri = 'https://www.google.com/oauth2redirect';
    final String loginUrl =
        "https://connect.deezer.com/oauth/auth.php?app_id=$appId&redirect_uri=$redirectUri&perms=basic_access,email";

    return new WebviewScaffold(
        url: loginUrl,
        appBar: new AppBar(
          title: new Text("Login to Deezer..."),
        ));
  }
}
