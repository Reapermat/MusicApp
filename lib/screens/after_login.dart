

import '../providers/get_user.dart';
import '../providers/authentication.dart';

import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './user_info.dart';
import './screen_arguments.dart';

class AfterLogin extends StatelessWidget {
  static final routeName = 'after-login';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Authentication>(context, listen: false);
    final apiProvider = Provider.of<GetUser>(context, listen: false);
    String token;
    return Scaffold(
      body: Center(
        child: Text(provider.getCode == null ? 'What' : provider.getCode),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: testAuthorize,
        onPressed: () async {
          await provider.getToken();
          token = provider.getAccessToken;
          print('token from after $token');
          if (token != null) {
            //await apiProvider.getUser(token);
            Navigator.of(context).pushNamed(UserInfo.routeName, arguments: ScreenArguments(token: token));
          }
        },
        label: Text('Authorize'),
        icon: Icon(Icons.lock_open),
      ), //
    );
  }
}
