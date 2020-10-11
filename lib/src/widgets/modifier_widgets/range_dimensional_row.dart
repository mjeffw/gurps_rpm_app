import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/widgets/int_spinner.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../arrow_button.dart';
import '../utils.dart';
import 'modifier_row.dart';

class RangeDimensionalRow extends ModifierRow {
  RangeDimensionalRow({RangeDimensional modifier, int index})
      : super(modifier: modifier, index: index);

  RangeDimensional get _range => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _range.incrementEffect(-1)),
        ),
      Text('${_range.numberDimensions} dimensions'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _range.incrementEffect(1)),
        ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: _range, index: index);
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
            Text('${widget.modifier.name} Editor'),
            Divider(),
            columnSpacer,
            IntSpinner(
              initialValue: _range,
              minValue: 0,
              textFieldWidth: 80.0,
              onChanged: (value) => setState(() => _range = value),
            )
          ],
        ),
      ),
    );
  }
}
