import '../providers/authentication.dart';

import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './user_info.dart';
import './screen_arguments.dart';
import '../widgets/user_item_info.dart';

class AfterLogin extends StatelessWidget {
  static final routeName = 'after-login';

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

    final provider = Provider.of<Authentication>(context, listen: false);
    String tracklist;
    return Scaffold(
      appBar: AppBar(
        title: Text('Front Page'),
      ),
      body: FutureBuilder(
        future: provider.getToken(),
        //future: userProvider.getUser('freeQZ4bvEgzDfprGT4N9ohNRG9HSF0SdLgKsR8WZXruuUnIq5t'),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              print(dataSnapshot.error);
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Authentication>(
                builder: (ctx, userData, child) => ListView.builder(
                  // tu null zwraca
                  itemCount: userData.users.length,
                  itemBuilder: (ctx, i) => UserItemInfo(userData.users[i]),
                ),
              );
            }
          }
        },
      ),
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
