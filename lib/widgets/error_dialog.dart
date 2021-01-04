import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  String message;

  ErrorDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ]);
  }
}
