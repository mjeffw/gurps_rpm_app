import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../arrow_button.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class RangeRow extends ModifierRow {
  RangeRow({Range modifier, int index})
      : super(modifier: modifier, index: index);

  Range get _range => super.modifier;

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: _range, index: index);

  @override
  String get effectText => '${_range.distance}';
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final int index;
  final Range modifier;

  @override
  __EditorState createState() => __EditorState();
}

class __EditorState extends State<_Editor> {
  Range _range;

  @override
  void initState() {
    super.initState();
    _range = widget.modifier;
  }

  Range _createModifier() => _range;

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
      Row(
        children: [
          DoubleLeftArrowButton(
            onPressed: () => setState(() {
              _range = _range.incrementEffect(-5);
            }),
          ),
          LeftArrowButton(
            onPressed: () => setState(() {
              _range = _range.incrementEffect(-1);
            }),
          ),
          Expanded(
            child: Text(_range.distance.toString()),
          ),
          RightArrowButton(
            onPressed: () => setState(() {
              _range = _range.incrementEffect(1);
            }),
          ),
          DoubleRightArrowButton(
            onPressed: () => setState(() {
              _range = _range.incrementEffect(5);
            }),
          ),
        ],
      )
    ];
  }
}
