import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/editor_dialog.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../int_spinner.dart';
import '../utils.dart';
import 'modifier_row.dart';

const rangeLabels = <BestowsRange, String>{
  BestowsRange.broad: 'Broad',
  BestowsRange.moderate: 'Moderate',
  BestowsRange.narrow: 'Narrow',
};

class BestowsRow extends ModifierRow {
  BestowsRow({RitualModifier modifier, int index})
      : assert(modifier is Bestows),
        super(modifier: modifier, index: index);

  Bestows get _bestows => super.modifier;

  @override
  String get label => 'Bestows ${_isNegative() ? 'Penalty' : 'Bonus'},';

  bool _isNegative() => _bestows.value.isNegative;

  @override
  String get detailText => null;

  @override
  String get effectText => '${_isNegative() ? '' : '+'}${_bestows.value}';

  @override
  String get suffixText =>
      'to ${_bestows.roll} (${rangeLabels[_bestows.range]})';

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final Bestows modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  TextEditingController _controller;
  int _bonus;
  BestowsRange _range;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.modifier.roll);
    _bonus = widget.modifier.value;
    _range = widget.modifier.range;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditorDialog(
      provider: () => widget.modifier.copyWith(
        range: _range,
        value: _bonus,
        roll: _controller.text,
      ),
      name: widget.modifier.name,
      widgets: _modifierWidgets(),
    );
  }

  List<Widget> _modifierWidgets() {
    return [
      TextField(
        controller: _controller,
        decoration: InputDecoration(
            labelText: 'Rolls affected', border: const OutlineInputBorder()),
      ),
      columnSpacer,
      Container(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButton<BestowsRange>(
          underline: Container(),
          value: _range,
          items: [
            DropdownMenuItem(
              child: Text('${rangeLabels[BestowsRange.broad]}'),
              value: BestowsRange.broad,
            ),
            DropdownMenuItem(
              child: Text('${rangeLabels[BestowsRange.moderate]}'),
              value: BestowsRange.moderate,
            ),
            DropdownMenuItem(
              child: Text('${rangeLabels[BestowsRange.narrow]}'),
              value: BestowsRange.narrow,
            ),
          ],
          onChanged: (value) => setState(() => _range = value),
        ),
      ),
      columnSpacer,
      IntSpinner(
        onChanged: (value) => setState(() => _bonus = value),
        initialValue: _bonus,
        textFieldWidth: 90.0,
        decoration: InputDecoration(
          labelText: 'Modifier',
        ),
      ),
    ];
  }
}
