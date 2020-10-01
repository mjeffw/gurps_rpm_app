import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/int_spinner.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'modifier_row.dart';

class AreaOfEffectRow extends ModifierRow {
  AreaOfEffectRow(RitualModifier modifier, int index)
      : assert(modifier is AreaOfEffect),
        super(modifier: modifier, index: index);

  AreaOfEffect get area => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    var label = area.excludes ? 'excluding' : 'including';

    return [
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, area.incrementEffect(-1)),
        ),
      Text('(${area.radius}) yards'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, area.incrementEffect(1)),
        ),
      if (area.numberTargets > 0) Text('$label ${area.numberTargets} target(s)')
    ];
  }

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
              radius: _radius,
              excludes: _excludes,
              numberTargets: _numberTargets,
            );

            Navigator.of(context).pop<RitualModifier>(copy);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Area of Effect Editor'),
          Divider(),
          columnSpacer,
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
        ],
      ),
    );
  }
}
