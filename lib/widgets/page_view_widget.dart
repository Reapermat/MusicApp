import 'package:flutter/material.dart';

class PageViewWidget extends StatelessWidget {
  final String title;
  final String text;
  final Color color;

  PageViewWidget({this.title, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            // alignment: Alignment.topRight,
            fit: StackFit.loose,
            // overflow: Overflow.clip,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15),
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(15)),
                ),
                child: SizedBox(
                  height: constraints.biggest.height * 0.55,
                ),
                //has to have child
                //maybe boxdecoration
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
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.035,
              left: 20,
              right: 20,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: EdgeInsets.only(left: 20, right: 20), //check this
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                // color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );
    });
  }
}
