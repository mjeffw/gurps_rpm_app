import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'int_spinner.dart';
import 'modifier_row.dart';

const rangeLabels = <BestowsRange, String>{
  BestowsRange.broad: 'Broad',
  BestowsRange.moderate: 'Moderate',
  BestowsRange.narrow: 'Narrow',
};

class BestowsRow extends ModifierRow {
  BestowsRow(RitualModifier modifier, int index)
      : assert(modifier is Bestows),
        super(modifier: modifier, index: index);

  Bestows get _bestows => super.modifier;

  @override
  String get label => 'Bestows a ${_isNegative() ? 'Penalty' : 'Bonus'},';

  bool _isNegative() => _bestows.value.isNegative;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _bestows.incrementEffect(-1)),
        ),
      Text('${_isNegative() ? '' : '+'}${_bestows.value}'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _bestows.incrementEffect(1)),
        ),
      rowSmallSpacer,
      Text('to ${_bestows.roll} (${rangeLabels[_bestows.range]})'),
    ];
  }

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
    return AlertDialog(
        actions: [
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              var copy = widget.modifier.copyWith(
                range: _range,
                value: _bonus,
                roll: _controller.text,
              );
              Navigator.of(context).pop<RitualModifier>(copy);
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bestows a (Bonus or Penalty) Editor'),
            Divider(),
            columnSpacer,
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: 'Rolls affected',
                  border: const OutlineInputBorder()),
            ),
            columnSpacer,
            DropdownButton<BestowsRange>(
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
            columnSpacer,
            IntSpinner(
              onChanged: (value) => setState(() => _bonus = value),
              initialValue: _bonus,
              textFieldWidth: 90.0,
              decoration: InputDecoration(
                labelText: 'Modifier',
              ),
            ),
          ],
        ));
  }
}
