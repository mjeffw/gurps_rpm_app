import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/editor_dialog.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../int_spinner.dart';
import '../utils.dart';
import 'modifier_row.dart';

class AreaOfEffectRow extends ModifierRow {
  AreaOfEffectRow({RitualModifier modifier, int index})
      : assert(modifier is AreaOfEffect),
        super(modifier: modifier, index: index);

  AreaOfEffect get area => super.modifier;

  @override
  String get effectText => '${area.radius} yards';

  String get excludesText => area.excludes ? 'excluding' : 'including';

  @override
  String get suffixText => (area.numberTargets > 0)
      ? '$excludesText ${area.numberTargets} target(s)'
      : null;

  @override
  Widget dialogBuilder(BuildContext context) {
    return _Editor(modifier: modifier, index: index);
  }
}

class _Editor extends StatefulWidget {
  _Editor({Key key, this.modifier, this.index}) : super(key: key);

  final AreaOfEffect modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  int _radius;
  int _numberTargets;
  bool _excludes;

  @override
  void initState() {
    super.initState();
    _radius = widget.modifier.radius;
    _numberTargets = widget.modifier.numberTargets;
    _excludes = widget.modifier.excludes;
  }

  @override
  Widget build(BuildContext context) {
    return EditorDialog(
      provider: () => widget.modifier.copyWith(
        radius: _radius,
        excludes: _excludes,
        numberTargets: _numberTargets,
      ),
      name: widget.modifier.name,
      widgets: _modifierWidgets(),
    );
  }

  List<Widget> _modifierWidgets() {
    return [
      IntSpinner(
        onChanged: (value) => setState(() => _radius = value),
        initialValue: _radius,
        bigStep: 5,
        minValue: 0,
        textFieldWidth: 120.0,
        decoration: InputDecoration(
          labelText: 'Radius',
          suffixText: 'yds',
        ),
        stepFunction: (currentRadius, increment) {
          int value = AreaOfEffect.radiusToStep(currentRadius);
          value += increment;
          return (value <= 0) ? 0 : AreaOfEffect.stepToRadius(value);
        },
      ),
      columnSpacer,
      SwitchListTile(
        value: _excludes,
        onChanged: (state) => setState(() {
          _excludes = state;
        }),
        title: Text(_excludes ? 'Excludes targets' : 'Includes targets'),
      ),
      columnSpacer,
      IntSpinner(
        initialValue: _numberTargets,
        decoration: InputDecoration(labelText: 'Targets'),
        textFieldWidth: 90.0,
        bigStep: 5,
        minValue: 0,
        onChanged: (value) => setState(() {
          _numberTargets = value;
        }),
      ),
    ];
  }
}
