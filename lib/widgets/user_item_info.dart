import 'package:flutter/material.dart';

import '../providers/authentication.dart' as usr;
import '../screens/screen_arguments.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';
import '../providers/models/tracklist.dart';
import '../providers/models/user.dart';

class UserItemInfo extends StatefulWidget {
  // final usr.UserItem user;

  // UserItemInfo(this.user);

  @override
  _UserItemInfoState createState() =>
      _UserItemInfoState(); //tu chyba najlepiej callnąć tą funkcję async essa
}

class _UserItemInfoState extends State<UserItemInfo> {
  //chyba tutaj trza bedzie listView robic dla tego
  Future tokenFuture;
  Tracklist _tracklist;
  User _userList;

  @override
  void initState() {
    setState(() {
      tokenFuture = _getToken();
      tokenFuture.then((user) {
        _userList = user[0];
        _tracklist = user[1]; // got to return the stuff here
      });
    });
    super.initState();
  }

  _getToken() async {
    return await Provider.of<Authentication>(context, listen: false).getToken();
  }

  @override
  Widget build(BuildContext context) {
    Tracklist tracklist = _tracklist;
    User userList = _userList;

    //   return Container(
    //     padding: EdgeInsets.all(15),
    //     height: MediaQuery.of(context).size.height * 0.1,
    //     width: MediaQuery.of(context).size.width,
    //     child: ListTile(
    //       leading: ClipRRect(
    //         borderRadius: BorderRadius.circular(4.0),
    //         child: Image.network(widget.user.pictureMedium, fit: BoxFit.cover),
    //       ),
    //       title: Text(
    //         'hello, ${widget.user.name}',
    //         style: TextStyle(fontSize: 20),
    //       ),
    //     ),
    //   );
    return FutureBuilder(
      future: tokenFuture,
      builder: (ctx, dataSnapshot) {
        // want name etc then below tracklist maybe put in Column or smth
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
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network(
                          userList
                              .pictureMedium, //cos sie dzieje ze nie czeka na "userList" jakis await gdzies moze idk 
                          fit: BoxFit.cover),
                    ),
                    title: Text(
                      'hello, ${userList.name}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _tracklist.data.length,
                    itemBuilder: (context, index) {
                      tracklist = _tracklist;
                      // Data tracklist = _tracklist.data.elementAt(index);
                      //dziala juz
                      return ListTile(
                          title: Text(tracklist.data.elementAt(index).title));
                    })
                // Consumer<Authentication>(
                // builder: (ctx, userData, child) => ListView.builder(
                //   itemCount: userData.users.length,
                //   itemBuilder: (ctx, i) => UserItemInfo(userData.users[i]),
                // ),
                // builder: (ctx, userData, _) => UserItemInfo(userData.users.first)), //tu ten container co jest na gorze ale trzeba jakos dane wyciagnac
                //tu jebnac kwadraciki jak bylo w szopie
              ],
            );
          }
        }
      },
    );
  }
}
