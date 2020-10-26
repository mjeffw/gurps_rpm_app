import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../../models/typedefs.dart';
import '../arrow_button.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class DurationRow extends ModifierRow {
  DurationRow(
      {DurationModifier modifier,
      int index,
      OnModifierUpdated onModifierUpdated})
      : super(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);

  DurationModifier get _duration => super.modifier;
  int get _seconds => _duration.duration.inSeconds;

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);

  @override
  String get detailText => null;

  // TODO Change DurationModifier to add an effectToString method
  @override
  String get effectText =>
      '${_seconds == 0 ? 'Momentary' : _duration.duration}';
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final DurationModifier modifier;
  final int index;

  @override
  __EditorState createState() => __EditorState();
}

class __EditorState extends State<_Editor> {
  DurationModifier _duration;

  @override
  void initState() {
    super.initState();

    _duration = widget.modifier;
  }

  DurationModifier _createModifier() => _duration;

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
              _duration = _duration.incrementEffect(-5);
            }),
          ),
          LeftArrowButton(
            onPressed: () => setState(() {
              _duration = _duration.incrementEffect(-1);
            }),
          ),
          Expanded(
            child: Text(_duration.toString()),
          ),
          RightArrowButton(
            onPressed: () => setState(() {
              _duration = _duration.incrementEffect(1);
            }),
          ),
          DoubleRightArrowButton(
            onPressed: () => setState(() {
              _duration = _duration.incrementEffect(5);
            }),
          ),
        ],
      ),
    ];
  }
}
