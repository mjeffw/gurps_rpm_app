import 'package:gurps_rpm_model/gurps_rpm_model.dart';

typedef ModifierFactory = RitualModifier Function();

Map<String, ModifierFactory> modifierFactories = {
  AfflictionStun.label: () => AfflictionStun(),
  Affliction.label: () => Affliction(),
  AlteredTraits.label: () => AlteredTraits(Trait(name: 'Undefined')),
  AreaOfEffect.label: () => AreaOfEffect(),
  Bestows.label: () => Bestows('Undefined'),
  Damage.label: () => Damage(),
  DurationModifier.label: () => DurationModifier(),
  ExtraEnergy.label: () => ExtraEnergy(),
  Healing.label: () => Healing(),
  MetaMagic.label: () => MetaMagic(),
  Range.label: () => Range(),
  RangeInfo.label: () => RangeInfo(),
  RangeCrossTime.label: () => RangeCrossTime(),
  RangeDimensional.label: () => RangeDimensional(),
  Speed.label: () => Speed(),
  SubjectWeight.label: () => SubjectWeight()
};
