import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/widgets/int_spinner.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import 'editor_dialog.dart';
import 'modifier_row.dart';

class RangeDimensionalRow extends ModifierRow {
  RangeDimensionalRow({RangeDimensional modifier, int index})
      : super(modifier: modifier, index: index);

  RangeDimensional get _range => super.modifier;

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: _range, index: index);

  @override
  String get effectText => '${_range.numberDimensions}';

  @override
  String get suffixText => 'dimensions';
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final int index;
  final RangeDimensional modifier;

  @override
  __EditorState createState() => __EditorState();
}

class __EditorState extends State<_Editor> {
  int _range;

  @override
  void initState() {
    super.initState();
    _range = widget.modifier.numberDimensions;
  }

  RangeDimensional _createModifier() =>
      RangeDimensional(numberDimensions: _range);

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
        initialValue: _range,
        minValue: 0,
        textFieldWidth: 80.0,
        onChanged: (value) => setState(() => _range = value),
        decoration: InputDecoration(labelText: 'Number Dimensions'),
      )
    ];
  }
}
