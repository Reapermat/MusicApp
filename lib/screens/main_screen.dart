import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../widgets/main_widget.dart';

class MainScreen extends StatefulWidget {
  static final routeName = 'main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SearchBar _searchBar;

  

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      elevation: 0,
      actions: [_searchBar.getSearchAction(context)],
    );
  }

  _MainScreenState() {

    _searchBar = new SearchBar(
        inBar: true,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: _onBackPressed,
    //   child:
    return Scaffold(
      appBar: _searchBar.build(context),
      drawer: Drawer(),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          child: MainWidget()),
    );
    // );
  }

  void onSubmitted(String value) {
    print(value);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
            ],
          ),
        ) ??
        false;
  }
}
