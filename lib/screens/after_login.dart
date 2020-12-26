import '../providers/authentication.dart';

import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './user_info.dart';
import './screen_arguments.dart';
import '../widgets/user_item_info.dart';

class AfterLogin extends StatefulWidget {
  static final routeName = 'after-login';

  @override
  _AfterLoginState createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  Future tokenFuture;

  @override
  void initState() {
    // tokenFuture = _getToken();
    super.initState();
  }

  _getToken() async {
    return await Provider.of<Authentication>(context, listen: false).getToken();
  }


  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<Authentication>(context, listen: false);
    // final apiProvider = Provider.of<GetUser>(context, listen: false);
    // String token;
    // return Scaffold(
    //   body: Center(
    //     child: Text(provider.getCode == null ? 'What' : provider.getCode),
    //   ),
    //   floatingActionButton: FloatingActionButton.extended(
    //     // onPressed: testAuthorize,
    //     onPressed: () async {
    //       await provider.getToken();
    //       token = provider.getAccessToken;
    //       print('token from after $token');
    //       if (token != null) {
    //         //await apiProvider.getUser(token);
    //         Navigator.of(context).pushNamed(UserInfo.routeName, arguments: ScreenArguments(token: token));  //sends token
    //       }
    //     },
    //     label: Text('Authorize'),
    //     icon: Icon(Icons.lock_open),
    //   ), //
    // );

    String tracklist;
    return Scaffold(
      appBar: AppBar(
        title: Text('Front Page'),
      ),
      body: UserItemInfo(),
      // body: FutureBuilder(
      //   future: tokenFuture,
      //   builder: (ctx, dataSnapshot) {
      //     if (dataSnapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else {
      //       if (dataSnapshot.error != null) {
      //         print(dataSnapshot.error);
      //         // ...
      //         // Do error handling stuff
      //         return Center(
      //           child: Text('An error occurred!'),
      //         );
      //       } else {
      //         return Consumer<Authentication>(
      //           // builder: (ctx, userData, child) => ListView.builder(
      //           //   itemCount: userData.users.length,
      //           //   itemBuilder: (ctx, i) => UserItemInfo(userData.users[i]),
      //           // ),
      //           builder: (ctx, userData, _) => UserItemInfo(userData.users.first)
      //         );
      //       }
      //     }
      //   },
        
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   // onPressed: testAuthorize,
      //   onPressed: () {
      //     // tracklistProvider.getTracklist()
      //   },
      //   label: Text('Authorize'),
      //   icon: Icon(Icons.lock_open),
      // ),
    );
  }
}
