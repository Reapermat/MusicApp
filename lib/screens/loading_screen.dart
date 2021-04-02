import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';


import '../widgets/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('height ${MediaQuery.of(context).size.height}');
    print('width ${MediaQuery.of(context).size.width}');
    return Column(
      children: [
        Stack(
          // alignment: Alignment.topRight,
          fit: StackFit.loose,
          children: [
            Container(
              // margin: EdgeInsets.only(left: 60.0),
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15),
              alignment: Alignment.topRight,
              child: Image(
                image: AssetImage('assets/images/image.png'),
              ),
            ),
            Positioned(
              bottom: 45,
              right: 90,
              height: MediaQuery.of(context).size.height * 0.035,
              child: Image(
                image: AssetImage('assets/images/2.0x/logo2.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
        Container(
          // margin: EdgeInsets.only(top: 100),
          margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - 531 /*height of the image should change this later */) * 0.5),
          child: Text(
            //can implement jumping dots
            'Smoothing your music...',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.all(20),
            child: LoadingIndicator()),
      ],
    );
  }
}
