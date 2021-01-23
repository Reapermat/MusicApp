import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/screen_arguments.dart';
import '../themes/theme_data.dart';
import '../widgets/page_view_widget.dart';

class OnBoardScreen extends StatefulWidget {
  static final routeName = 'on-board';
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context).settings.arguments != null) {
      final ScreenArguments args = ModalRoute.of(context).settings.arguments;
      error = args.error;
    }
    super.didChangeDependencies();
  }

  bool error = false;
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color.fromRGBO(94, 94, 94, 1),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: error == true
          ? AlertDialog(
              backgroundColor: blueTheme.primaryColor,
              title: Text(
                'An Error Occured!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              content: Text('Check internet connection',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              actionsPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
                        setState(() {
                          error = false;
                        });
                      },
                      child: Text(
                        'Okay',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ])
          : Column(
              children: [
                Container(
                  // margin: EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      PageViewWidget(
                        title: 'Hello',
                        text:
                            'Bacon ipsum dolor amet capicola buffalo pork belly, biltong chislic pork chop cupim chicken. Spare ribs shoulder biltong capicola landjaeger pork chop. Capicola pork turducken hamburger cupim strip steak chislic leberkas shoulder landjaeger ribeye chicken sirloin tenderloin. Brisket jowl bacon, meatloaf tenderloin pork belly corned beef sausage rump',
                        color: blueAccent,
                      ),
                      PageViewWidget(
                        title: 'Hello 2',
                        text:
                            'Bacon ipsum dolor amet capicola buffalo pork belly, biltong chislic pork chop cupim chicken. Spare ribs shoulder biltong capicola landjaeger pork chop. Capicola pork turducken hamburger cupim strip steak chislic leberkas shoulder landjaeger ribeye chicken sirloin tenderloin. Brisket jowl bacon, meatloaf tenderloin pork belly corned beef sausage rump',
                        color: pinkAccent,
                      ),
                      PageViewWidget(
                        title: 'Hello 3',
                        text:
                            'Bacon ipsum dolor amet capicola buffalo pork belly, biltong chislic pork chop cupim chicken. Spare ribs shoulder biltong capicola landjaeger pork chop. Capicola pork turducken hamburger cupim strip steak chislic leberkas shoulder landjaeger ribeye chicken sirloin tenderloin. Brisket jowl bacon, meatloaf tenderloin pork belly corned beef sausage rump',
                        color: yellowAccent,
                      ),
                    ],
                  ),
                ),
                _currentPage == _numPages - 1
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.all(10),
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          textColor: Colors.white,
                          borderSide: BorderSide(color: Colors.white),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                          child: Text(
                            'sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.11,
                      ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                )
              ],
            ),
    );
  }
}
