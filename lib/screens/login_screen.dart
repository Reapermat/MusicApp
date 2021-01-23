import 'dart:async';

import 'package:MusicApp/screens/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import 'main_screen.dart';
import 'onboard_screen.dart';

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
  StreamSubscription<WebViewHttpError> _onError;

  String code;

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onError.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {});

    _onStateChanged = flutterWebviewPlugin.onStateChanged
        .listen((WebViewStateChanged state) {});

    _onError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError state) {
      if (state.code == '-2') {
        flutterWebviewPlugin.close().then((_) {
          Future.delayed(Duration(seconds: 2)).then((_) {
            Navigator.of(context).pushNamed(OnBoardScreen.routeName,
                arguments: ScreenArguments(error: true));
          });
        });
        dispose();
      }
    });

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.startsWith('https://www.google.com/oauth2redirect')) {
            RegExp regExp = new RegExp("code=(.*)");
            this.code = regExp.firstMatch(url)?.group(1);
            Provider.of<Authentication>(context, listen: false).setCode(code);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName, (Route<dynamic> route) => false);
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
        "https://connect.deezer.com/oauth/auth.php?app_id=$appId&redirect_uri=$redirectUri&perms=basic_access,email,manage_library,delete_library,offline_access";

    return new WebviewScaffold(
      url: loginUrl,
      appBar: new AppBar(
        title: new Text("Login to Deezer..."),
      ),
    );
  }
}
