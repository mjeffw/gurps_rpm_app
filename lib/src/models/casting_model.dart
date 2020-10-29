import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../utils/markdown_exporter.dart';
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

  void _updateCasting(Casting updated) {
    if (updated != casting) {
      casting = updated;
      notifyListeners();
    }
  }

  String get name => casting.ritual.name;

  set name(String name) => _updateRitual(_ritual.copyWith(name: name));

  String get notes => casting.ritual.notes;

  set notes(String notes) => _updateRitual(_ritual.copyWith(notes: notes));

  // TODO when calculating the greater effect multiplier for **this casting**, include greater effects on the casting + the ritual.
  int get effectsMultiplier => _ritual.effectsMultiplier;

  // TODO when calculating the number of greater effects for **this casting**, include greater effects on the casting + the ritual.
  int get greaterEffects => _ritual.greaterEffects;

  String get formattedText {
    CastingExporter exporter = MyMarkdownCastingExporter();
    casting.exportTo(exporter);
    return exporter.toString();
  }

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

  // == Additional SpellEffect mutators ==

  List<SpellEffect> get additionalSpellEffects => casting.additionalEffects;

  void addAdditionalSpellEffect(String pathName) =>
      _updateCasting(casting.addEffect(SpellEffect(Path.fromString(pathName),
          effect: Effect.sense, level: Level.lesser)));

  void updateAdditionalSpellEffect(int index, SpellEffect value) =>
      _updateCasting(casting.updateEffect(index, value));

  void removeAdditionalSpellEffect(int index) =>
      _updateCasting(casting.removeEffect(index));

  // == Aditional RitualModifier mutators ==

  get addtionalModifiers => casting.additionalModifiers;

  void addAdditionalModifier(String name) =>
      _updateCasting(casting.addModifier(modifierFactories[name]()));

  void updateAdditionalModifier(int index, RitualModifier newValue) =>
      _updateCasting(casting.updateModifier(index, newValue));

  void removeAdditionalModifier(int index) =>
      _updateCasting(casting.removeModifier(index));
}
