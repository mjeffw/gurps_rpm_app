import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/casting_model.dart';
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

  Widget createRitualPage = CreateRitualPage();
  Widget gatherEnergyPage = GatherEnergyPage();
  Widget optionsPage = OptionsPage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CastingModel(),
      builder: (context, _) => AdaptiveScaffold(
        title: Text('GURPS: Ritual Path Magic (BETA)'),
        actions: [
          InkWell(
            onTap: _launchURL,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'images/BuyMeACoffee_dark@small.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
        currentIndex: _pageIndex,
        destinations: [
          AdaptiveScaffoldDestination(
            title: 'Create Ritual',
            icon: Icons.home,
          ),
          AdaptiveScaffoldDestination(
            title: 'Gather Energy',
            icon: Icons.add_sharp,
          ),
          AdaptiveScaffoldDestination(
            title: 'Options',
            icon: Icons.cake,
          ),
        ],
        body: _pageAtIndex(_pageIndex),
        onNavigationIndexChange: (newIndex) {
          setState(() {
            _pageIndex = newIndex;
          });
        },
      ),
    );
  }

  _launchURL() async {
    const urlString = 'https://ko-fi.com/nickcoffinpi';
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  Widget _pageAtIndex(int index) {
    if (index == 0) return createRitualPage;
    if (index == 1) return gatherEnergyPage;
    return optionsPage;
  }
}
