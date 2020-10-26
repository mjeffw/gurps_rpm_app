import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import 'casting_model.dart';

typedef OnModifierDeleted = void Function(int, CastingModel);
typedef OnModifierAdded = void Function(String, CastingModel);
typedef OnModifierUpdated = void Function(int, RitualModifier, CastingModel);

typedef OnEffectUpdated = void Function(int, SpellEffect, CastingModel);
typedef OnEffectDeleted = void Function(int, CastingModel);
typedef OnEffectAdded = void Function(String, CastingModel);
