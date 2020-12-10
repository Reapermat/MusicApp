import 'package:flutter/material.dart';

import '../providers/get_user.dart' as usr;

class UserItemInfo extends StatefulWidget {
  final usr.UserItem user;

  UserItemInfo(this.user);

  @override
  _UserItemInfoState createState() => _UserItemInfoState();
}

class _UserItemInfoState extends State<UserItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(widget.user.pictureMedium, fit: BoxFit.cover),
        ),
        title: Text(
          'hello, ${widget.user.name}',
          style: TextStyle(fontSize: 20),
        ),
      ),
      
    );
  }
}
