import 'package:MusicApp/screens/screen_arguments.dart';
import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _form = GlobalKey<FormState>();

  void _submit(String input) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    //check which page you're in a then do bla bla
    //if in after login then:
    print('route is ${ModalRoute.of(context).settings.name}');
    if (ModalRoute.of(context).settings.name != 'search-screen') {
      Navigator.of(context).pushNamed(SearchScreen.routeName,
          arguments: ScreenArguments(search: input));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Form(
        key: _form,
        child: Column(
          children: [
            // tu jakies errory albo duperele by siem przydalo dac
            TextFormField(
              decoration: InputDecoration(labelText: 'Search'),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (input) {
                _submit(input);
              }, // buttona tu na pewno trza dac
              // initialValue: args == null ? null : args.search, // when you come back it would be nice to show the other text
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
            )
          ],
        ));
  }
}
