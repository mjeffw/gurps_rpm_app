import 'package:flutter/material.dart';

import '../widgets/thirdparty/adaptive_scaffold.dart';
import 'create_ritual_page.dart';
import 'gather_energy_page.dart';
import 'options_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  // ignore: unused_field
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: Text('GURPS: Ritual Path Magic'),
      currentIndex: _pageIndex,
      destinations: [
        AdaptiveScaffoldDestination(title: 'Create Ritual', icon: Icons.home),
        AdaptiveScaffoldDestination(
            title: 'Gather Energy', icon: Icons.add_sharp),
        AdaptiveScaffoldDestination(title: 'Options', icon: Icons.cake),
      ],
      body: _pageAtIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          _pageIndex = newIndex;
        });
      },
    );
  }

  static Widget _pageAtIndex(int index) {
    if (index == 0) return CreateRitualPage();
    if (index == 1) return GatherEnergyPage();
    return OptionsPage();
  }
}
