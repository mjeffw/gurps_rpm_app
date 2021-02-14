import 'package:equatable/equatable.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

class SelectableTextExporter extends CastingExporter with EquatableMixin {
  SelectableTextExporter();

  String get inherentModifiers => ritualModifiers.isNotEmpty
      ? ritualModifiers.map((a) => a.shortText).reduce(foldWithPlus)
      : 'None';

  String get inherentEffects => ritualEffects.isNotEmpty
      ? ritualEffects.asShortText.reduce(foldWithPlus)
      : 'None';

  String get allComponents =>
      components.isNotEmpty ? components.reduce(foldWithPlus) : 'None';

  @override
  String get title => super.title ?? '';

  @override
  String get description => super.description ?? '';

  @override
  List<Object> get props => [
        title,
        inherentEffects,
        inherentModifiers,
        greaterEffects,
        effectsMultiplier,
        description,
        allComponents,
        energy,
        baseEnergyCost,
        totalEffectsMultiplier
      ];
}
