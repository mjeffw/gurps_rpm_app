import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

class CastingModel with ChangeNotifier {
  Casting _casting = Casting(Ritual());

  String get name => _casting.ritual.name;

  set name(String name) {
    Ritual updated = _casting.ritual.copyWith(name: name);
    if (updated != _casting.ritual) {
      print('update name: $name');
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }

  String get notes => _casting.ritual.notes;

  set notes(String notes) {
    Ritual updated = _casting.ritual.copyWith(notes: notes);
    if (updated != _casting.ritual) {
      print('update name: $name');
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }
}
