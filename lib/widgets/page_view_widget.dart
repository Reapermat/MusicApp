import 'package:flutter/material.dart';

class PageViewWidget extends StatelessWidget {
  final String title;
  final String text;
  final Color color;

  PageViewWidget({this.title, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(    //sizes and stuff here is bad
        children: [
          Stack(
            // alignment: Alignment.topRight,
            fit: StackFit.loose,
            // overflow: Overflow.clip,
            children: [
              Container(
                //this is the container
                margin: EdgeInsets.only(left: 60.0),
                alignment: Alignment.topRight,
                // width: ,
                // color: color,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                ),
                child: SizedBox(
                  height: constraints.biggest.height *0.55,

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
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.035),
            child: Text(
              //can implement jumping dots
              title,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.3,
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Text(
              //can implement jumping dots
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    });
  }
}
