import 'package:flutter/material.dart';
import '../themes/theme_data.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  ErrorDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: blueTheme.primaryColor,
        actionsPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
        title: Text(
          'An Error Occured!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content:
            Text(message, style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: <Widget>[
          Container(
            width: 110,
            height: 40,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              textColor: Colors.white,
              borderSide: BorderSide(color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ]);
  }
}
