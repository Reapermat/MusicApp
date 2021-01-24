import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authentication.dart';

import '../providers/models/user.dart';

class UserDataScreen extends StatelessWidget {
  static final routeName = 'user-route';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Authentication>(context, listen: false);

    var userInfo = provider.getUserList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your data',
          style: TextStyle(
              color: Theme.of(context).primaryTextTheme.bodyText1.color),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(userInfo.pictureMedium, fit: BoxFit.cover),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Name',
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userInfo.name,
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color),
                  
            ),
          ),
          // Divider(),
          // ListTile(
          //   title: Text(
          //     'First name',
          //     style: TextStyle(
          //         color: Theme.of(context).primaryTextTheme.bodyText1.color,
          //         fontWeight: FontWeight.bold),
                  
          //   ),
          //   subtitle: Text(
          //     userInfo.firstname,
          //     style: TextStyle(
          //         color: Theme.of(context).primaryTextTheme.bodyText1.color),
          //   ),
          // ),
          // Divider(),
          // ListTile(
          //   title: Text(
          //     'Last name',
          //     style: TextStyle(
          //         color: Theme.of(context).primaryTextTheme.bodyText1.color,
          //         fontWeight: FontWeight.bold),
          //   ),
          //   subtitle: Text(
          //     userInfo.name,
          //     style: TextStyle(
          //         color: Theme.of(context).primaryTextTheme.bodyText1.color),
          //   ),
          // ),
          Divider(),
          ListTile(
            title: Text(
              'Birthday',
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userInfo.birthday,
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Email',
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userInfo.email,
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
