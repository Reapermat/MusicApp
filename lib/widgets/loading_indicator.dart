import 'package:flutter/material.dart';
import 'dart:async';

import '../screens/onboard_screen.dart';

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  double _progress = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    new Timer.periodic(Duration(milliseconds: 100), (Timer timer) { //might have to do that animation..
      if (_progress >= 1) {
        //go to other page
        
        //does a million things before need to delete or dispose this thing
        // setState(() {
        timer.cancel();
        // print(timer.isActive);
        // });

        // setState(() {
        Navigator.of(context).pushNamedAndRemoveUntil(
            OnBoardScreen.routeName, (Route<dynamic> route) => false);
        // });
      } else {
        setState(() {
          // print('hello');
        _progress += 0.001;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return LinearProgressIndicator(
      backgroundColor: Color.fromRGBO(94, 94, 94, 1),
      valueColor: new AlwaysStoppedAnimation(Colors.white),
      value: _progress,
    );
  }
}
