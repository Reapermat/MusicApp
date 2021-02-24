import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './providers/authentication.dart';
import './providers/search_content.dart';
import './screens/loading_screen.dart';
import './themes/theme_data.dart';
import './themes/theme_notifier.dart';
import 'screens/current_song_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/user_data_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SearchContent(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeNotifier(blueTheme),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (ctx) => Authentication(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (ctx) => SearchContent(),
    //     ),
    //     ChangeNotifierProvider(create: (ctx) => ThemeNotifier(blueTheme))
    //   ],
    //   child:
    final themeProvider = Provider.of<ThemeNotifier>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: blueTheme.primaryColor,
    ));

    return MaterialApp(
      title: 'Moosic',
      theme: themeProvider.getTheme(),
      home: MyHomePage(title: 'Home Page'),
      initialRoute: '/',
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        SearchScreen.routeName: (ctx) => SearchScreen(),
        CurrentSongScreen.routeName: (ctx) => CurrentSongScreen(),
        FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
        OnBoardScreen.routeName: (ctx) => OnBoardScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        UserDataScreen.routeName: (ctx) => UserDataScreen(),
      },
      // ),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LoadingScreen(),
        // child: OnBoardScreen(),
      ),
    );
  }
}
