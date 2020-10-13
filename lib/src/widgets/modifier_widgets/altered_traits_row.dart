import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../int_spinner.dart';
import '../utils.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class AlteredTraitsRow extends ModifierRow {
  AlteredTraitsRow({RitualModifier modifier, int index})
      : assert(modifier is AlteredTraits),
        super(modifier: modifier, index: index);

  AlteredTraits get alteredTrait => super.modifier;

  @override
  String get detailText => '${alteredTrait.trait.nameLevel} ';

  @override
  String get effectText => '(${alteredTrait.characterPoints})';

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
    return EditorDialog(
      provider: _createModifier,
      name: widget.modifier.name,
      widgets: _modifierWidgets(),
    );
  }

  AlteredTraits _createModifier() {
    return modifier.copyWith(
        trait: Trait(
      name: _traitNameController.text,
      hasLevels: _hasLevels,
      baseCost: _baseCost,
      costPerLevel: _costPerLevel,
      levels: _levels,
    ));
  }

  List<Widget> _modifierWidgets() {
    return [
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
    ];
  }
}
