import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import 'ritual_factory.dart';

class CastingModel with ChangeNotifier {
  CastingModel({this.casting = const Casting(Ritual())});

  Casting casting = Casting(Ritual());

  Ritual get _ritual => casting.ritual;

  void _updateRitual(Ritual updated) {
    if (updated != _ritual) {
      casting = casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }

  String get name => casting.ritual.name;

  set name(String name) => _updateRitual(_ritual.copyWith(name: name));

  String get notes => casting.ritual.notes;

  set notes(String notes) => _updateRitual(_ritual.copyWith(notes: notes));

  int get effectsMultiplier => _ritual.effectsMultiplier;

  int get greaterEffects => _ritual.greaterEffects;

  // == Inherent SpellEffect mutators ==

  List<SpellEffect> get inherentSpellEffects => casting.ritual.effects;

  void addInherentSpellEffect(String pathName) => _updateRitual(
      _ritual.addSpellEffect(SpellEffect(Path.fromString(pathName),
          effect: Effect.sense, level: Level.lesser)));

  void updateInherentSpellEffect(int index, SpellEffect value) =>
      _updateRitual(_ritual.updateSpellEffect(index, value));

  void removeInherentSpellEffect(int index) =>
      _updateRitual(_ritual.removeSpellEffect(index));

  // == Inherent RitualModifier mutators ==

  get inherentModifiers => _ritual.modifiers;

  void addInherentModifier(String name) =>
      _updateRitual(_ritual.addModifier(modifierFactories[name]()));

  void updateInherentModifier(int index, RitualModifier newValue) =>
      _updateRitual(_ritual.updateModifier(index, newValue));

  void removeInherentModifier(int index) =>
      _updateRitual(_ritual.removeModifier(index));
}
