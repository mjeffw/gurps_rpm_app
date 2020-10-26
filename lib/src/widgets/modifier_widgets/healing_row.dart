import 'package:flutter/material.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../../models/typedefs.dart';
import '../../utils/utils.dart';
import '../dice_spinner.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class HealingRow extends ModifierRow {
  HealingRow({Healing modifier, int index, OnModifierUpdated onModifierUpdated})
      : super(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);

  Healing get _healing => super.modifier;

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: _healing, index: index);

  @override
  String get effectText => '${_healing.dice}';

  @override
  String get suffixText => '${_healing.type == HealingType.fp ? 'FP' : 'HP'}';
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
    return EditorDialog(
      provider: _createModifier,
      name: widget.modifier.name,
      widgets: _modifierWidgets(),
    );
  }

  List<Widget> _modifierWidgets() {
    return [
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
    ];
  }
}
