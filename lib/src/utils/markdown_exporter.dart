import 'package:gurps_rpm_model/gurps_rpm_model.dart';

class MyMarkdownCastingExporter extends CastingExporter {
  @override
  String get title => '## ${super.title == null ? '' : '_${super.title}_'}';

  @override
  String toString() => '$title\n'
      '* _Spell Effects:_ $_inherentEffects.\n'
      '* _Inherent Modifiers:_ ${_inherentModifiers()}.\n'
      '* _Greater Effects:_ $greaterEffects (×$effectsMultiplier).\n'
      '\n'
      '${description ?? ''}\n'
      '\n'
      '* _Typical Casting:_ $_allComponents. '
      '_$energy energy ($baseEnergyCost×$totalEffectsMultiplier)._\n';

  String _inherentModifiers() => ritualModifiers.isNotEmpty
      ? ritualModifiers.map((a) => a.shortText).reduce(foldWithPlus)
      : 'None';

  String get _inherentEffects => ritualEffects.isNotEmpty
      ? ritualEffects.asShortText.reduce(foldWithPlus)
      : 'None';

  String get _allComponents =>
      components.isNotEmpty ? components.reduce(foldWithPlus) : 'None';
}
