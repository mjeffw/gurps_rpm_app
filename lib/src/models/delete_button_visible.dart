import 'package:flutter/foundation.dart';

class DeleteButtonVisible extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  set value(bool newvalue) {
    if (_value != newvalue) {
      _value = newvalue;
      notifyListeners();
    }
  }
}
