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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 12,
            ),
            NeumorphicButton(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              padding: EdgeInsets.all(8),
              onPressed: this.onPlay,
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size:
                    min(constraints.biggest.height, constraints.biggest.width) /
                        5,
              ),
            ),
            if (onStop != null)
              NeumorphicButton(
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                padding: EdgeInsets.all(16),
                onPressed: this.onPlay,
                child: Icon(
                  Icons.stop,
                  size: min(constraints.biggest.height,
                          constraints.biggest.width) /
                      5,
                ),
              ),
          ],
        );
      },
    );
  }
}
