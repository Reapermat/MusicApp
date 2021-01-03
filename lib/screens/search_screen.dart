import 'package:flutter/material.dart';

import '../widgets/search_bar.dart';
import './screen_arguments.dart';
import 'package:provider/provider.dart';
import '../providers/search_content.dart';
import '../providers/models/search.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = 'search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future searchFuture;
  Search _searchElem;

  @override
  void initState() {
    super.initState();
    setState(() {
      searchFuture = _getSearch();
      searchFuture.then((searchElem) {
        _searchElem = searchElem;
        print(_searchElem);
      });
    });
  }

  _getSearch() async {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final String search = args.search;
    await Provider.of<SearchContent>(context, listen: false)
        .getSearchContent(search);
    print('hey');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Page'),
        ),
        body: FutureBuilder(
          future: _getSearch(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                print(dataSnapshot.error);
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                //tu ten listView
                return ListView.builder(
                  itemCount: _searchElem.total, //zwraca null jakby nie czekalo na ta funkcja juz takie cos mialem niby
                  itemBuilder: (ctx, i) {
                    //print (_searchElem.total.toString());
                    var searchList = _searchElem.data.elementAt(i);
                    //listile
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(searchList.album.coverSmall),
                      ),
                      trailing: Text(searchList.title),
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
