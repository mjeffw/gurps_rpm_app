import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../../models/typedefs.dart';
import '../int_spinner.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class ExtraEnergyRow extends ModifierRow {
  ExtraEnergyRow(
      {ExtraEnergy modifier, int index, OnModifierUpdated onModifierUpdated})
      : super(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);

  ExtraEnergy get _energy => super.modifier;

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);

  @override
  String get effectText => '${_energy.energy}';
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final ExtraEnergy modifier;
  final int index;

  @override
  __EditorState createState() => __EditorState();
}

class __EditorState extends State<_Editor> {
  TextEditingController _controller;
  int _energy;

  @override
  void initState() {
    super.initState();
    _energy = widget.modifier.energy;
    _controller = TextEditingController(text: _energy.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ExtraEnergy _createModifier() => widget.modifier.copyWith(energy: _energy);

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
      IntSpinner(
        onChanged: (value) => setState(() => _energy = value),
        initialValue: _energy,
        textFieldWidth: 90.0,
        decoration: InputDecoration(
          labelText: 'Energy',
        ),
      ),
    ];
  }
}
