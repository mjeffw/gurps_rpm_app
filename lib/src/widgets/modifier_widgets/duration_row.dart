import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/modifier_row.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';

class DurationRow extends ModifierRow {
  DurationRow({DurationModifier modifier, int index})
      : super(modifier: modifier, index: index);

  DurationModifier get _duration => super.modifier;
  int get _seconds => _duration.duration.inSeconds;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _duration.incrementEffect(-1)),
        ),
      Text('${_seconds == 0 ? 'Momentary' : _duration.duration}'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _duration.incrementEffect(1)),
        ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
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
    return AlertDialog(
      actions: [
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () =>
              Navigator.of(context).pop<RitualModifier>(_createModifier()),
        ),
      ],
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 100.0,
          maxWidth: MediaQuery.of(context).size.width - 40.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Damage Editor'),
            Divider(),
            columnSpacer,
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
            )
          ],
        ),
      ),
    );
  }
}
