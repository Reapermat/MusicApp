import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/authentication.dart';
import './providers/search_content.dart';
import 'screens/main_screen.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/screen_arguments.dart';
import 'screens/search_screen.dart';
import 'screens/current_song_screen.dart';
import 'screens/playlist_screen.dart';
import 'screens/onboard_screen.dart';
import './screens/loading_screen.dart';
import './themes/theme_notifier.dart';
import './themes/theme_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SearchContent(),
        ),
        ChangeNotifierProvider(create: (ctx) => ThemeNotifier(blueTheme))
      ],
      child: MaterialApp(
        title: 'Moosic',
        theme: blueTheme,
        home: MyHomePage(title: 'Home Page'),
        initialRoute: '/',
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          MainScreen.routeName: (ctx) => MainScreen(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
          CurrentSongScreen.routeName: (ctx) => CurrentSongScreen(),
          PlaylistScreen.routeName: (ctx) => PlaylistScreen(),
          OnBoardScreen.routeName: (ctx) => OnBoardScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool error = false;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (ModalRoute.of(context).settings.arguments != null) {
  //     final ScreenArguments args = ModalRoute.of(context).settings.arguments;
  //     error = args.error;
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // first when set up i want that smoosic and loading indicator

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // body: error == true
      //     ? AlertDialog(
      //         title: Text('An Error Occured!'),
      //         content: Text('Check internet connection'),
      //         actions: <Widget>[
      //             FlatButton(
      //                 child: Text('Okay'),
      //                 onPressed: () {
      //                   setState(() {
      //                     error = false;
      //                   });
      //                 })
      //           ]) :
          body:  Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: LoadingScreen(),
              // child: OnBoardScreen(),
            ),
    );

    // return Scaffold(  //this will be for the last page
    //   body: error == true
    //       ? AlertDialog(
    //           title: Text('An Error Occured!'),
    //           content: Text('Check internet connection'),
    //           actions: <Widget>[
    //               FlatButton(
    //                   child: Text('Okay'),
    //                   onPressed: () {
    //                     setState(() {
    //                       error = false;
    //                     });
    //                   })
    //             ])
    // //       : Container(
    //           margin: EdgeInsets.all(30),
    //           height: MediaQuery.of(context).size.height,
    //           width: MediaQuery.of(context).size.width,
    //         ),
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: () {
    //       Navigator.of(context).pushNamed(LoginScreen.routeName);
    //     },
    //     label: Text('Authorize'),
    //     icon: Icon(Icons.lock_open),
    //   ),
    // );
  }
}
