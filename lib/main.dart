import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:MusicApp/screens/after_login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './providers/authentication.dart';
import 'screens/login_screen.dart';
import 'screens/after_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Authentication(),
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
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////////
    final authProvider = Provider.of<Authentication>(context);
    // authProvider.authenticate();
    return Scaffold(
      //   appBar: AppBar(
      //     title: Text(widget.title),
      //   ),
      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //     ),
      //   ),
      //   floatingActionButton: FloatingActionButton(onPressed: () {
      // return Scaffold(
      //   resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        width: 400,

        // child: WebView(

        // initialUrl:
        //     'https://connect.deezer.com/oauth/auth.php?app_id=448382&redirect_uri=https://www.google.com/oauth2redirect&perms=basic_access,email',
        // // initialUrl: 'https://www.facebook.com',
        // javascriptMode: JavascriptMode.unrestricted,
        // onWebViewCreated: (WebViewController controller) {
        //   _controller.complete(controller);
        // },

        //get current url cuz this shit isnt working
      ),
      // child: Text(
      //   authProvider.accessToken == null ? 'Hey' : authProvider.accessToken,
      // ),),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: testAuthorize,
        onPressed: () {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        },
        label: Text('Authorize'),
        icon: Icon(Icons.lock_open),
      ), // This trailing comma make
      // ),

      // ),
    );
  }
}
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wikipedia Explorer'),
//         // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//       ),
//       body: WebView(
//         initialUrl: 'https://en.wikipedia.org/wiki/Kraken',
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller.complete(webViewController);
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:async';

// void main() => runApp(MaterialApp(home: WikipediaExplorer()));

// class WikipediaExplorer extends StatefulWidget {
//   @override
//   _WikipediaExplorerState createState() => _WikipediaExplorerState();
// }

// class _WikipediaExplorerState extends State<WikipediaExplorer> {
//   Completer<WebViewController> _controller = Completer<WebViewController>();
//   final Set<String> _favorites = Set<String>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wikipedia Explorer'),
//         // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//         actions: <Widget>[
//           NavigationControls(_controller.future),
//           Menu(_controller.future, () => _favorites),
//         ],
//       ),
//       body: WebView(
//         initialUrl: 'https://connect.deezer.com/oauth/auth.php?app_id=448382&redirect_uri=https://www.google.com&perms=basic_access,email',
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller.complete(webViewController);
//         },
//       ),
//       floatingActionButton: _bookmarkButton(),
//     );
//   }

//   _bookmarkButton() {
//     return FutureBuilder<WebViewController>(
//       future: _controller.future,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         if (controller.hasData) {
//           return FloatingActionButton(
//             onPressed: () async {
//               var url = await controller.data.currentUrl();
//               _favorites.add(url);
//               Scaffold.of(context).showSnackBar(
//                 SnackBar(content: Text('Saved $url for later reading.')),
//               );
//             },
//             child: Icon(Icons.favorite),
//           );
//         }
//         return Container();
//       },
//     );
//   }
// }

// class Menu extends StatelessWidget {
//   Menu(this._webViewControllerFuture, this.favoritesAccessor);
//   final Future<WebViewController> _webViewControllerFuture;
//   // TODO(efortuna): Come up with a more elegant solution for an accessor to this than a callback.
//   final Function favoritesAccessor;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         if (!controller.hasData) return Container();
//         return PopupMenuButton<String>(
//           onSelected: (String value) async {
//             if (value == 'Email link') {
//               var url = await controller.data.currentUrl();
//               await launch(
//                   'mailto:?subject=Check out this cool Wikipedia page&body=$url');
//             } else {
//               var newUrl = await Navigator.push(context,
//                   MaterialPageRoute(builder: (BuildContext context) {
//                 return FavoritesPage(favoritesAccessor());
//               }));
//               Scaffold.of(context).removeCurrentSnackBar();
//               if (newUrl != null) controller.data.loadUrl(newUrl);
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
//                 const PopupMenuItem<String>(
//                   value: 'Email link',
//                   child: Text('Email link'),
//                 ),
//                 const PopupMenuItem<String>(
//                   value: 'See Favorites',
//                   child: Text('See Favorites'),
//                 ),
//               ],
//         );
//       },
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   FavoritesPage(this.favorites);
//   final Set<String> favorites;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Favorite pages')),
//       body: ListView(
//           children: favorites
//               .map((url) => ListTile(
//                   title: Text(url), onTap: () => Navigator.pop(context, url)))
//               .toList()),
//     );
//   }
// }

// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture)
//       : assert(_webViewControllerFuture != null);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController controller = snapshot.data;
//         return Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () => navigate(context, controller, goBack: true),
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () => navigate(context, controller, goBack: false),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   navigate(BuildContext context, WebViewController controller,
//       {bool goBack: false}) async {
//     bool canNavigate =
//         goBack ? await controller.canGoBack() : await controller.canGoForward();
//     if (canNavigate) {
//       goBack ? controller.goBack() : controller.goForward();
//     } else {
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//             content: Text("No ${goBack ? 'back' : 'forward'} history item")),
//       );
//     }
//   }
// }
