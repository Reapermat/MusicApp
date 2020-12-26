import 'package:flutter/material.dart';

import 'package:MusicApp/screens/after_login.dart';
import 'package:MusicApp/screens/user_info.dart';
import 'package:provider/provider.dart';
import './providers/authentication.dart';
import 'screens/login_screen.dart';
import 'screens/after_login.dart';
import './providers/user_tracklist.dart';

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
        // ChangeNotifierProvider(
        //   create: (ctx) => Tracklist(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          AfterLogin.routeName: (ctx) => AfterLogin(),
          //UserInfo.routeName: (ctx) => UserInfo(),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        width: 400,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        },
        label: Text('Authorize'),
        icon: Icon(Icons.lock_open),
      ),
    );
  }
}
