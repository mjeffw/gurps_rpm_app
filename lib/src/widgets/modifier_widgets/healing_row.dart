import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/modifier_row.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import 'arrow_button.dart';

class HealingRow extends ModifierRow {
  HealingRow({Healing modifier, int index})
      : super(modifier: modifier, index: index);

  Healing get _healing => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      LeftArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _healing.incrementEffect(-1)),
      ),
      Text('${_healing.dice}'),
      RightArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _healing.incrementEffect(1)),
      ),
      Text('${_healing.type == HealingType.fp ? 'FP' : 'HP'}'),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) => throw UnimplementedError();
}
