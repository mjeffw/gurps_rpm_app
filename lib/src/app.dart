import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';

/// The global state the app.
class AppState {}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppState _appState;

  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _appState,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
