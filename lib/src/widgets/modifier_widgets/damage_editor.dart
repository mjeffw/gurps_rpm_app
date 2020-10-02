import 'package:flutter/material.dart';
import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_app/src/widgets/text_converter.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'int_spinner.dart';
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
          IntSpinner(
            onChanged: (value) => setState(() => _dice = _dice + value),
            initialValue: DieRoll.denormalize(_dice),
            textConverter: DieRollConverter(),
            textFieldWidth: 90.0,
            bigStep: 4,
            minValue: 0,
            decoration: InputDecoration(
              labelText: 'Dice',
              errorText: _validate ? 'Not a GURPS dice expression' : null,
            ),
          )
        ],
      ),
    );
  }

  bool get _validate => true;
}

class DieRollConverter extends StringToIntConverter {
  @override
  String toA(int input) => DieRoll(dice: 1, adds: input).toString();

  @override
  int toB(String input) => DieRoll.denormalize(DieRoll.fromString(input));
}
