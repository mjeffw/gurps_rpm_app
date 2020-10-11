import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../arrow_button.dart';
import '../utils.dart';
import 'modifier_row.dart';

class MetaMagicRow extends ModifierRow {
  MetaMagicRow({MetaMagic modifier, int index})
      : super(modifier: modifier, index: index);

  MetaMagic get _energy => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _energy.incrementEffect(-1)),
        ),
      Text('${_energy.energy} energy'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, _energy.incrementEffect(1)),
        ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final MetaMagic modifier;
  final int index;

  @override
  __EditorState createState() => __EditorState();
}

class __EditorState extends State<_Editor> {
  MetaMagic _metaMagic;

  @override
  void initState() {
    super.initState();

    _metaMagic = widget.modifier;
  }

  MetaMagic _createModifier() => _metaMagic;

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
            Row(
              children: [
                DoubleLeftArrowButton(
                  onPressed: () => setState(() {
                    _metaMagic = _metaMagic.incrementEffect(-5);
                  }),
                ),
                LeftArrowButton(
                  onPressed: () => setState(() {
                    _metaMagic = _metaMagic.incrementEffect(-1);
                  }),
                ),
                Expanded(
                  child: Center(child: Text(_metaMagic.energy.toString())),
                ),
                RightArrowButton(
                  onPressed: () => setState(() {
                    _metaMagic = _metaMagic.incrementEffect(1);
                  }),
                ),
                DoubleRightArrowButton(
                  onPressed: () => setState(() {
                    _metaMagic = _metaMagic.incrementEffect(5);
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
