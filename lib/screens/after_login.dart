import 'package:flutter/material.dart';

import '../widgets/user_item_info.dart';

class AfterLogin extends StatefulWidget {
  static final routeName = 'after-login';

  @override
  _AfterLoginState createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Front Page'),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: UserItemInfo()),
    );
  }
}
