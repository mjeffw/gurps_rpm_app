import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/modifier_row.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import 'arrow_button.dart';

class ExtraEnergyRow extends ModifierRow {
  ExtraEnergyRow({ExtraEnergy modifier, int index})
      : super(modifier: modifier, index: index);

  ExtraEnergy get _energy => super.modifier;

  @override
  bool get isEditable => false;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      DoubleLeftArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _energy.incrementEffect(-5)),
      ),
      LeftArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _energy.incrementEffect(-1)),
      ),
      Text('${_energy.energy}'),
      RightArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _energy.incrementEffect(1)),
      ),
      DoubleRightArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _energy.incrementEffect(5)),
      ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) => throw UnimplementedError();
}
