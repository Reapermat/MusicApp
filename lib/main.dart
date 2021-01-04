import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/authentication.dart';
import './providers/search_content.dart';
import './screens/after_login.dart';
import 'screens/after_login.dart';
import 'screens/login_screen.dart';
import 'screens/search_screen.dart';
import 'screens/screen_arguments.dart';
import 'widgets/error_dialog.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => SearchContent(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: '/',
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          AfterLogin.routeName: (ctx) => AfterLogin(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
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
  bool error = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context).settings.arguments != null) {
      final ScreenArguments args = ModalRoute.of(context).settings.arguments;
      error = args.error;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //tu ten error i jak sie kliknie ok to trza dac wartosc tego shitu na false;
          error == true
              ? AlertDialog(
                  title: Text('An Error Occured!'),
                  content: Text('Check internet connection'),
                  actions: <Widget>[
                      FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            setState(() {
                              error = false;
                            });
                          })
                    ])
              : Container(
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
