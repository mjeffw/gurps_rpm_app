import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/modifier_row.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

class DamageRow extends ModifierRow {
  DamageRow({RitualModifier modifier, int index})
      : assert(modifier is Damage),
        super(modifier: modifier, index: index);

  Damage get damage => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      Text('${damage.direct ? '' : 'External, '}${damage.type.label}'),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) {
    // TODO: implement dialogBuilder
    throw UnimplementedError();
  }
}
