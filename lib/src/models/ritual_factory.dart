import 'package:gurps_rpm_model/gurps_rpm_model.dart';

typedef ModifierFactory = RitualModifier Function();

Map<String, ModifierFactory> modifierFactories = {
  AfflictionStun.label: () => AfflictionStun(),
  Affliction.label: () => Affliction(),
  AlteredTraits.label: () => AlteredTraits(Trait(name: 'Undefined')),
  AreaOfEffect.label: () => AreaOfEffect(),
  Bestows.label: () => Bestows('Undefined'),
  'Damage': () => Damage(),
};
