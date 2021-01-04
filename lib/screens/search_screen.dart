import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen_arguments.dart';
import '../providers/models/search.dart';
import '../providers/search_content.dart';
import '../widgets/error_dialog.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = 'search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future searchFuture;
  Search _searchElem;
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  String _search;

  @override
  void initState() {
    super.initState();

    setState(() {
      print('initState');
      // searchFuture = _getSearch();
      // searchFuture.then((searchElem) {
      //   _searchElem = searchElem;
      // });
    });
  }

  @override
  void didChangeDependencies() {
    print('dependecies');
    if (_isInit) {
      searchFuture = _getSearch();
    } else {
      searchFuture = _getSearch(search: _search);
    }
    searchFuture.then((searchElem) {
      _searchElem = searchElem;
    });
    super.didChangeDependencies();
  }

  _getSearch({String search}) async {
    var provider = Provider.of<SearchContent>(context, listen: false);

    if (_isInit) {
      final ScreenArguments args = ModalRoute.of(context)
          .settings
          .arguments;
          search = args.search;
      _search = search;
    }
    _search = search;

    try{
      return await provider.getSearchContent(_search);
    }catch(error){
      return throw error;
    }
  }

  _submit(String input) {
    _isInit = false;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    _getSearch(search: input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Page'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        // tu jakies errory albo duperele by siem przydalo dac
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Search'),
                          initialValue: _search,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (input) {
                            _search = input;
                            ScreenArguments(search: _search);
                            try{
                            _submit(_search);
                            }catch(error){
                             return ErrorDialog('Try again later');
                            }
                          }, // buttona tu na pewno trza dac
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                        )
                      ],
                    )),
                fit: FlexFit.tight,
              ), //what to do when in this page
              Flexible(
                flex: 5,
                child: FutureBuilder(
                  future: searchFuture,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (dataSnapshot.error != null) {
                        print(dataSnapshot.error);
                        // ...
                        // Do error handling stuff
                        // return Center(
                        //   child: Text('An error occurred!'),
                        // );
                        return ErrorDialog('Try again later');
                      } else {
                        //tu ten listView
                        return ListView.builder(
                          itemCount: _searchElem.data.length,
                          itemBuilder: (ctx, i) {
                            var searchList = _searchElem.data.elementAt(i);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(searchList.album.coverSmall),
                              ),
                              title: Text(searchList.title),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
