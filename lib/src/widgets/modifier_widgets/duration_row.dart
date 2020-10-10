import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/modifier_row.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import 'arrow_button.dart';

class DurationRow extends ModifierRow {
  DurationRow({DurationModifier modifier, int index})
      : super(modifier: modifier, index: index);

  DurationModifier get _duration => super.modifier;
  int get _seconds => _duration.duration.inSeconds;

  @override
  bool get isEditable => false;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      DoubleLeftArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _duration.incrementEffect(-5)),
      ),
      LeftArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _duration.incrementEffect(-1)),
      ),
      Text('${_seconds == 0 ? 'Momentary' : _duration.duration}'),
      RightArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _duration.incrementEffect(1)),
      ),
      DoubleRightArrowButton(
        onPressed: () => Provider.of<CastingModel>(context, listen: false)
            .updateInherentModifier(index, _duration.incrementEffect(5)),
      ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) => throw UnimplementedError();
}
