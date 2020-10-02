import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'int_spinner.dart';
import 'modifier_row.dart';

class AlteredTraitsRow extends ModifierRow {
  AlteredTraitsRow({RitualModifier modifier, int index})
      : assert(modifier is AlteredTraits),
        super(modifier: modifier, index: index);

  AlteredTraits get alteredTrait => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      Text('${alteredTrait.trait.nameLevel} '),
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, alteredTrait.incrementEffect(-1)),
        ),
      Text('(${alteredTrait.characterPoints})'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, alteredTrait.incrementEffect(1)),
        ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
}

/// Widget that contains the edit dialog for AlteredTraits.
class _Editor extends StatefulWidget {
  _Editor({@required this.modifier, @required this.index});

  final AlteredTraits modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState(modifier);
}

class _EditorState extends State<_Editor> {
  _EditorState(this.modifier);

  AlteredTraits modifier;

  TextEditingController _traitNameController;
  bool _hasLevels;
  int _levels;
  int _baseCost;
  int _costPerLevel;

  @override
  void initState() {
    super.initState();

    Trait trait = modifier.trait;
    _hasLevels = trait.hasLevels;
    _baseCost = trait.baseCost;
    _levels = trait.levels;
    _costPerLevel = trait.costPerLevel;

    _traitNameController = TextEditingController(text: trait.name);
  }

  @override
  void dispose() {
    _traitNameController.dispose();
    super.dispose();
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
          onPressed: () {
            var copy = modifier.copyWith(
              trait: Trait(
                name: _traitNameController.text,
                hasLevels: _hasLevels,
                baseCost: _baseCost,
                costPerLevel: _costPerLevel,
                levels: _levels,
              ),
            );
            Navigator.of(context).pop<RitualModifier>(copy);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Altered Trait Editor'),
          Divider(),
          columnSpacer,
          TextField(
            controller: _traitNameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Effect',
              border: const OutlineInputBorder(),
            ),
          ),
          columnSpacer,
          IntSpinner(
            onChanged: (value) => setState(() {
              _baseCost = value;
            }),
            initialValue: _baseCost,
            textFieldWidth: 90.0,
            decoration: InputDecoration(
              labelText: 'Base Cost',
            ),
          ),
          columnSpacer,
          SwitchListTile(
            value: _hasLevels,
            onChanged: (state) => setState(() {
              _hasLevels = state;
            }),
            title: Text('Has Levels'),
          ),
          if (_hasLevels) ...[
            columnSpacer,
            IntSpinner(
              initialValue: _levels,
              decoration: InputDecoration(labelText: 'Levels'),
              textFieldWidth: 90.0,
              bigStep: 5,
              minValue: 0,
              onChanged: (value) => setState(() {
                _levels = value;
              }),
            ),
            columnSpacer,
            IntSpinner(
              onChanged: (value) => setState(() {
                _costPerLevel = value;
              }),
              bigStep: 5,
              textFieldWidth: 90.0,
              decoration: InputDecoration(labelText: 'Cost/Level'),
              initialValue: _costPerLevel,
            )
          ],
        ],
      ),
    );
  }
}
