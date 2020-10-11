import 'package:flutter/material.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/modifier_row.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'dice_spinner.dart';

class HealingRow extends ModifierRow {
  HealingRow({Healing modifier, int index})
      : super(modifier: modifier, index: index);

  Healing get _healing => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _healing.incrementEffect(-1)),
        ),
      Text('${_healing.dice}'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _healing.incrementEffect(1)),
        ),
      Text('${_healing.type == HealingType.fp ? 'FP' : 'HP'}'),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: _healing, index: index);
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final Healing modifier;
  final int index;

  @override
  __EditorState createState() => __EditorState();
}

class __EditorState extends State<_Editor> {
  DieRoll _dice;
  HealingType _type;

  @override
  void initState() {
    super.initState();

    _dice = widget.modifier.dice;
    _type = widget.modifier.type;
  }

  Healing _createModifier() => Healing(dice: _dice, type: _type);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () =>
              Navigator.of(context).pop<RitualModifier>(_createModifier()),
        ),
      ],
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 100.0,
          maxWidth: MediaQuery.of(context).size.width - 40.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${widget.modifier.name} Editor'),
            Divider(),
            columnSpacer,
            DiceSpinner(
              onChanged: (value) => setState(() => _dice = value),
              initialValue: _dice,
              textFieldWidth: 90.0,
            ),
            columnSpacer,
            Container(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<HealingType>(
                underline: Container(),
                value: _type,
                items: [
                  DropdownMenuItem(
                    child: Text('Hit Points'),
                    value: HealingType.hp,
                  ),
                  DropdownMenuItem(
                    child: Text('Fatigue'),
                    value: HealingType.fp,
                  ),
                ],
                onChanged: (value) => setState(() => _type = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
