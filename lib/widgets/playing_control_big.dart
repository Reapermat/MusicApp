import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PlayingControlBig extends StatelessWidget {
  final bool isPlaying;
  final Function() onPlay;
  final Function() onStop;
  final Function() onNext;
  final Function() onPrevious;

  PlayingControlBig({
    @required this.isPlaying,
    @required this.onPlay,
    this.onStop,
    this.onNext,
    this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 12,
            ),
            Container(
              // margin: EdgeInsets.only(left: 50),
              // padding: EdgeInsets.all(4),
              // height: 64,
              height: constraints.biggest.height * 0.58,
              width: constraints.biggest.width * 0.16,
              child: RaisedButton(
                elevation: 8,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(8),
                onPressed: this.onPrevious,
                child: Icon(
                  Icons.skip_previous_rounded,
                  color: Colors.white,
                  size: min(constraints.biggest.height,
                          constraints.biggest.width) *
                      0.4,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: constraints.biggest.height * 0.58,
              width: constraints.biggest.width * 0.16,
              child: RaisedButton(
                elevation: 8,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(8),
                onPressed: this.onPlay,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: min(constraints.biggest.height,
                          constraints.biggest.width) *
                      0.4,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: constraints.biggest.height * 0.58,
              width: constraints.biggest.width * 0.16,
              child: RaisedButton(
                elevation: 8,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(8),
                onPressed: this.onNext,
                child: Icon(
                  Icons.skip_next_sharp,
                  color: Colors.white,
                  size: min(constraints.biggest.height,
                          constraints.biggest.width) *
                      0.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
