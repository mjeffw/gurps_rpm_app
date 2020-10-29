import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../../models/typedefs.dart';
import '../../utils/utils.dart';
import '../arrow_button.dart';
import '../edit_button.dart';
import 'affliction_row.dart';
import 'altered_traits_row.dart';
import 'area_effect_row.dart';
import 'bestows_row.dart';
import 'damage_row.dart';
import 'duration_row.dart';
import 'extra_energy_row.dart';
import 'healing_row.dart';
import 'meta_magic_row.dart';
import 'range_crosstime_row.dart';
import 'range_dimensional_row.dart';
import 'range_info_row.dart';
import 'range_row.dart';
import 'speed_row.dart';
import 'subject_weight_row.dart';

typedef ModifierProvider = RitualModifier Function();

abstract class ModifierRow extends StatelessWidget {
  const ModifierRow(
      {@required this.modifier,
      @required this.index,
      @required this.onModifierUpdated});

  final OnModifierUpdated onModifierUpdated;
  final RitualModifier modifier;
  final int index;

  /// If true, the Edit button is displayed at the end of the row.
  ///
  /// Subclasses should override this to return false if the Modifier has no
  /// edit dialog.
  bool get isEditable => true;

  /// Return the widget that represents the Modifier edit dialog.
  ///
  /// The edit dialog must return a RitualModifier in its pop() method.
  Widget dialogBuilder(BuildContext context);

  String get label => '${modifier.name},';
  String get detailText => null;
  String get effectText;
  String get suffixText => null;

  /// Subclasses must override to eturn the list of Widgets that make up the
  /// Modifier list row.
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      if (detailText != null) Text(detailText),
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => onModifierUpdated(
              index,
              modifier.incrementEffect(-1),
              Provider.of<CastingModel>(context, listen: false)),
        ),
      Text(effectText),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => onModifierUpdated(
            index,
            modifier.incrementEffect(1),
            Provider.of<CastingModel>(context, listen: false),
          ),
        ),
      if (suffixText != null)
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            suffixText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ];
  }

  void buildShowDialog(BuildContext context) async {
    RitualModifier newModifier = await showDialog<RitualModifier>(
        context: context,
        barrierDismissible: false,
        builder: (context) => dialogBuilder(context));

    if (newModifier != null) {
      onModifierUpdated(index, newModifier,
          Provider.of<CastingModel>(context, listen: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Text(label),
        rowSpacer,
        Expanded(
          child: Row(children: buildModifierRowWidgets(context) ?? []),
        ),
        rowSpacer,
        Text('[${modifier.energyCost}]'),
        EditButton(
            onPressed: isEditable ? () => buildShowDialog(context) : null),
      ]),
    );
  }

  static ModifierRow type(Type type,
      {RitualModifier modifier, int index, onModifierUpdated}) {
    switch (type) {
      case AfflictionStun:
        return AfflictionStunRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case Affliction: 
        return AfflictionRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case AlteredTraits:
        return AlteredTraitsRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case AreaOfEffect:
        return AreaOfEffectRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case Bestows:
        return BestowsRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case Damage:
        return DamageRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case DurationModifier:
        return DurationRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case ExtraEnergy:
        return ExtraEnergyRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case Healing:
        return HealingRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case MetaMagic:
        return MetaMagicRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case Range:
        return RangeRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case RangeInfo:
        return RangeInfoRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case RangeCrossTime:
        return RangeCrossTimeRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case RangeDimensional:
        return RangeDimensionalRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case Speed:
        return SpeedRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      case SubjectWeight:
        return SubjectWeightRow(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);
      default:
        throw 'No Widget defined for $type';
    }
  }
}

typedef WidgetBuilder = Widget Function(
    {RitualModifier modifier, int index, OnModifierUpdated onModifierUpdated});
