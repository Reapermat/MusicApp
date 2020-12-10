import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/get_user.dart' show GetUser;
import '../providers/user_tracklist.dart' show Tracklist;
import '../widgets/user_item_info.dart';
import '../screens/screen_arguments.dart';

class UserInfo extends StatelessWidget {
  static const routeName = '/user';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<GetUser>(context, listen: false);
    final tracklistProvider = Provider.of<Tracklist>(context, listen: false);
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final String token = args.token;
    return Scaffold(
        appBar: AppBar(
          title: Text('Front Page'),
        ),
        body: FutureBuilder(
          future: userProvider.getUser(token),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<GetUser>(
                  builder: (ctx, userData, child) => ListView.builder(
                    itemCount: userData.users.length,
                    itemBuilder: (ctx, i) => UserItemInfo(userData.users[i]),
                  ),
                );
              }
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
        // onPressed: testAuthorize,
        onPressed: () {
          // tracklistProvider.getTracklist()
        },
        label: Text('Authorize'),
        icon: Icon(Icons.lock_open),
      ),
        );
  }
}
