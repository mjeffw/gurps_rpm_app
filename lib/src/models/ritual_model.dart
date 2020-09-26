import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

class CastingModel with ChangeNotifier {
  Casting _casting = Casting(Ritual());

  String get name => _casting.ritual.name;

  Ritual get _ritual => _casting.ritual;

  int get effectsMultiplier => _ritual.effectsMultiplier;

  int get greaterEffects => _ritual.greaterEffects;

  get inherentModifiers => _ritual.modifiers;

  set name(String name) => _updateRitual(_ritual.copyWith(name: name));

  String get notes => _casting.ritual.notes;

  set notes(String notes) => _updateRitual(_ritual.copyWith(notes: notes));

  void _updateRitual(Ritual updated) {
    if (updated != _ritual) {
      _casting = _casting.copyWith(ritual: updated);
      notifyListeners();
    }
  }

  List<SpellEffect> get inherentSpellEffects => _casting.ritual.effects;

  void addInherentSpellEffect(String pathName) => _updateRitual(
      _ritual.addSpellEffect(SpellEffect(Path.fromString(pathName),
          effect: Effect.sense, level: Level.lesser)));

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

  void removeInherentSpellEffect(int index) =>
      _updateRitual(_ritual.removeSpellEffect(index));

  void addInherentModifier(String name) =>
      _updateRitual(_ritual.addModifier(RitualModifier.fromString(name)));

  void incrementInherentModifier(int index, int increment) {
    _updateRitual(_ritual.updateModifier(
        index, _ritual.modifiers[index].incrementEffect(increment)));
  }
}
