import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PlayingControlSmall extends StatelessWidget {
  final bool isPlaying;
  final Function() onPlay;
  final Function() onStop;
  final Function() onNext;
  final Function() onPrevious;

  PlayingControlSmall({
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
        print('height ${constraints.biggest.height}');
        print('width ${constraints.biggest.width}');
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(left: 50),
              padding: EdgeInsets.all(4),
              // height: 64,
              height: constraints.biggest.height * 0.74,
              width: constraints.biggest.width * 0.33,
              child: RaisedButton(
                elevation: 8,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),),
                padding: EdgeInsets.all(8),
                onPressed: this.onPlay,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size:
                      min(constraints.biggest.height, constraints.biggest.width) * 0.4,
                      // contraints.maxHeight * 0.585
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
