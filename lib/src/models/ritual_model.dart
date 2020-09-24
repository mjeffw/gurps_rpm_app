import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

class CastingModel with ChangeNotifier {
  Casting _casting = Casting(Ritual());

  String get name => _casting.ritual.name;

  Ritual get _ritual => _casting.ritual;

  int get effectsMultiplier => _ritual.effectsMultiplier;

  int get greaterEffects => _ritual.greaterEffects;

  set name(String name) {
    Ritual updated = _ritual.copyWith(name: name);
    if (updated != _ritual) {
      print('update name: $name');
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }

  String get notes => _casting.ritual.notes;

  set notes(String notes) {
    _updateRitual(_ritual.copyWith(notes: notes));
  }

  void _updateRitual(Ritual updated) {
    if (updated != _ritual) {
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }

  List<SpellEffect> get inherentSpellEffects => _casting.ritual.effects;

  void addInherentSpellEffect(String pathName) {
    Path path = Path.fromString(pathName);
    SpellEffect effect =
        SpellEffect(path, effect: Effect.sense, level: Level.lesser);

    _updateRitual(_ritual.addSpellEffect(effect));
  }

  void updateInherentSpellEffectLevel(int index, Level level) {
    var effect = _ritual.effects[index];
    SpellEffect value = effect.withLevel(level);
    if (value != effect) {
      _updateRitual(_ritual.updateSpellEffect(index, value));
    }
  }

  void updateInherentSpellEffectEffect(int index, Effect e) {
    var effect = _ritual.effects[index];
    SpellEffect value = effect.withEffect(e);
    if (value != effect) {
      _updateRitual(_ritual.updateSpellEffect(index, value));
    }
  }

  removeInherentSpellEffect(int index) {
    _updateRitual(_ritual.removeSpellEffect(index));
  }
}
