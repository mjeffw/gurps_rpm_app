import 'package:flutter/material.dart';
import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_app/src/widgets/dynamic_list_header.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/dice_spinner.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'modifier_row.dart';

class DamageRow extends ModifierRow {
  DamageRow({RitualModifier modifier, int index})
      : assert(modifier is Damage),
        super(modifier: modifier, index: index);

  Damage get damage => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      Text('${damage.direct ? 'Internal' : 'External'} ${damage.type.label},'),
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, damage.incrementEffect(-1)),
        ),
      rowSmallSpacer,
      Text('${damage.damageDice}'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, damage.incrementEffect(1)),
        ),
      rowSmallSpacer,
      Text(
        isMediumScreen(context) ? '(enhancements...)' : '(…)',
        overflow: TextOverflow.ellipsis,
      )
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final Damage modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  DieRoll _dice;
  bool _direct;
  bool _explosive;
  DamageType _type;
  List<TraitModifier> _modifiers;

  @override
  void initState() {
    super.initState();

    _dice = widget.modifier.dice;
    _direct = widget.modifier.direct;
    _explosive = widget.modifier.explosive;
    _type = widget.modifier.type;
    _modifiers = widget.modifier.modifiers;
  }

  Damage _createModifier() {
    return Damage(
        dice: _dice,
        direct: _direct,
        explosive: _explosive,
        type: _type,
        modifiers: _modifiers);
  }

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Damage Editor'),
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
            child: DropdownButton<DamageType>(
              underline: Container(),
              value: _type,
              items: _damageTypeItems(),
              onChanged: (value) => setState(() => _type = value),
            ),
          ),
          columnSpacer,
          SwitchListTile(
            value: _direct,
            onChanged: (state) => setState(() => _direct = state),
            title: Text(_direct ? 'Internal (Direct)' : 'External (Indirect)'),
          ),
          if (!_direct) ...<Widget>[
            columnSpacer,
            CheckboxListTile(
              value: _explosive,
              onChanged: (state) => setState(() => _explosive = state),
              title: Text('Explosive'),
            ),
          ],
          columnSpacer,
          DynamicListHeader(
            title: 'Enhancements/Limitations',
            onPressed: () {},
          ),
          SingleChildScrollView(
            child: Column(
              children: _enhancementList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _enhancementList() {
    return [];
  }

  List<DropdownMenuItem<DamageType>> _damageTypeItems() =>
      DamageType.map.entries
          .map((entry) => DropdownMenuItem<DamageType>(
              child: Text(entry.key), value: entry.value))
          .toList();
}
