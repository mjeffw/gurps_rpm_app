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

  List<SpellEffect> get inherentSpellEffects => _casting.ritual.effects;

  void addInherentSpellEffect(String pathName) {
    print('add inherent spell effect: $pathName');
    Path path = Path.fromString(pathName);
    SpellEffect effect =
        SpellEffect(path, effect: Effect.sense, level: Level.lesser);

    Ritual updated = _casting.ritual.addSpellEffect(effect);
    _casting = _casting.copyWith(ritual: updated);
    notifyListeners();
  }

  void updateInherentSpellEffectLevel(int index, Level level) {
    var effect = _casting.ritual.effects[index];
    SpellEffect value = effect.withLevel(level);
    if (value != effect) {
      Ritual updated = _casting.ritual.updateSpellEffect(index, value);
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }

  void updateInherentSpellEffectEffect(int index, Effect e) {
    var effect = _casting.ritual.effects[index];
    SpellEffect value = effect.withEffect(e);
    if (value != effect) {
      Ritual updated = _casting.ritual.updateSpellEffect(index, value);
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }
}
