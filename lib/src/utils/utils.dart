import 'package:flutter/widgets.dart';

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 960.0;
}

bool isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}

const rowSmallSpacer = const Padding(padding: EdgeInsets.only(right: 4.0));
const rowSpacer = const Padding(padding: EdgeInsets.only(right: 8.0));
const rowWideSpacer = const Padding(padding: EdgeInsets.only(right: 16.0));
const columnSpacer = const Padding(padding: EdgeInsets.only(bottom: 8.0));
