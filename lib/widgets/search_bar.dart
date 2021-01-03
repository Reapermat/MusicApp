import 'package:MusicApp/screens/screen_arguments.dart';
import 'package:flutter/material.dart';

import '../providers/search_content.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  
  final _form = GlobalKey<FormState>();

  void _submit(String input) /*async*/ {
    _form.currentState.save();
    // await Provider.of<SearchContent>(context, listen: false).getSearchContent(input); // tu raczej wyslac tego stringa i tam zbudowac liste odrazu w search_screen
    //czyli navigator
    Navigator.of(context).pushNamed(SearchScreen.routeName, arguments: ScreenArguments(search: input));
    print(input);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
        child: Column(
      children: [       // tu jakies errory albo duperele by siem przydalo dac
        TextFormField(
          decoration: InputDecoration(labelText: 'Search'),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (input) {
            _submit(input);
          },  // buttona tu na pewno trza dac
        )
      ],
    ));
  }
}
