import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import '../models/ritual_factory.dart';
import 'delete_button.dart';
import 'dynamic_list_header.dart';
import 'modifier_widgets/affliction_row.dart';
import 'modifier_widgets/altered_traits_row.dart';
import 'modifier_widgets/area_effect_row.dart';
import 'modifier_widgets/bestows_row.dart';
import 'modifier_widgets/damage_row.dart';
import 'modifier_widgets/duration_row.dart';
import 'modifier_widgets/extra_energy_row.dart';
import 'modifier_widgets/healing_row.dart';
import 'modifier_widgets/meta_magic_row.dart';
import 'modifier_widgets/range_crosstime_row.dart';
import 'modifier_widgets/range_dimensional_row.dart';
import 'modifier_widgets/range_info_row.dart';
import 'modifier_widgets/range_row.dart';

typedef WidgetBuilder = Widget Function(RitualModifier, int);

final Map<Type, WidgetBuilder> _map = {
  AfflictionStun: (mod, i) => AfflictionStunRow(modifier: mod, index: i),
  Affliction: (mod, i) => AfflictionRow(modifier: mod, index: i),
  AlteredTraits: (mod, i) => AlteredTraitsRow(modifier: mod, index: i),
  AreaOfEffect: (mod, i) => AreaOfEffectRow(modifier: mod, index: i),
  Bestows: (mod, i) => BestowsRow(modifier: mod, index: i),
  Damage: (mod, i) => DamageRow(modifier: mod, index: i),
  DurationModifier: (mod, i) => DurationRow(modifier: mod, index: i),
  ExtraEnergy: (mod, i) => ExtraEnergyRow(modifier: mod, index: i),
  Healing: (mod, i) => HealingRow(modifier: mod, index: i),
  MetaMagic: (mod, i) => MetaMagicRow(modifier: mod, index: i),
  Range: (mod, i) => RangeRow(modifier: mod, index: i),
  RangeInfo: (mod, i) => RangeInfoRow(modifier: mod, index: i),
  RangeCrossTime: (mod, i) => RangeCrossTimeRow(modifier: mod, index: i),
  RangeDimensional: (mod, i) => RangeDimensionalRow(modifier: mod, index: i),
};

class RitualModifierList extends StatelessWidget {
  const RitualModifierList({
    Key key,
  }) : super(key: key);

  Future<void> _addModifier(BuildContext context) async {
    showMaterialSelectionPicker(
        context: context,
        title: 'Select Modifier:',
        items: modifierFactories.keys.toList(),
        selectedItem: AfflictionStun.label,
        onChanged: (value) => Provider.of<CastingModel>(context, listen: false)
            .addInherentModifier(value));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DeleteButtonVisible(),
      child: Column(
        children: [
          Consumer<DeleteButtonVisible>(
            builder: (_, deleteVisible, __) => DynamicListHeader(
              title: 'Inherent Modifiers:',
              deleteActive: deleteVisible.value,
              onAddPressed: () => _addModifier(context),
              onDelPressed: () => deleteVisible.value = !deleteVisible.value,
            ),
          ),
          Selector<CastingModel, List<RitualModifier>>(
            selector: (_, model) => model.inherentModifiers,
            builder: (context, modifiers, child) {
              var widgets = <Widget>[];
              for (var index = 0; index < modifiers.length; index++) {
                widgets.add(RitualModifierLine(
                    modifier: modifiers[index], index: index));
              }
              return Column(children: widgets);
            },
          )
        ],
      ),
    );
  }
}

class RitualModifierLine extends StatelessWidget {
  const RitualModifierLine({this.modifier, this.index});

  final int index;
  final RitualModifier modifier;

  Widget buildModifierEditor() => _map[modifier.runtimeType](modifier, index);

  @override
  Widget build(BuildContext context) {
    final Color oddBackground = Theme.of(context).accentColor.withOpacity(0.05);

    final widget = buildModifierEditor();

    return Consumer<DeleteButtonVisible>(
      key: Key('RitualModifierLineWrapper:$index'),
      builder: (_, deleteVisible, __) => IntrinsicHeight(
        child: Dismissible(
          key: Key('RitualModifierLine:$index'),
          background: Container(color: Colors.red),
          onDismissed: (direction) => _deleteAction(context),
          child: Container(
            color: (index.isOdd) ? oddBackground : null,
            padding: EdgeInsets.only(right: 24.0),
            child: Row(
              children: [
                widget,
                if (deleteVisible.value)
                  DeleteButton(
                    onPressed: () => _deleteAction(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteAction(BuildContext context) {
    Provider.of<CastingModel>(context, listen: false)
        .removeInherentModifier(index);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Modifier ${modifier.name} deleted'),
    ));
  }
}

class DeleteButtonVisible extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  set value(bool newvalue) {
    if (_value != newvalue) {
      _value = newvalue;
      notifyListeners();
    }
  }
}
