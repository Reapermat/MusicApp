import 'package:MusicApp/providers/authentication.dart';

import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AfterLogin extends StatelessWidget {
  static final routeName = 'after-login';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Authentication>(context);
    return Scaffold(
      body: Center(
        child: Text(provider.getCode == null ? 'What' : provider.getCode),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: testAuthorize,
        onPressed: provider.getUser,
        label: Text('Authorize'),
        icon: Icon(Icons.lock_open),
      ), //
    );
  }
}
