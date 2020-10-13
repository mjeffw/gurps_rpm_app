import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../utils.dart';
import 'modifier_row.dart';

class EditorDialog extends StatelessWidget {
  const EditorDialog({
    Key key,
    @required this.provider,
    @required this.name,
    @required this.widgets,
  }) : super(key: key);

  final ModifierProvider provider;
  final List<Widget> widgets;
  final String name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            var copy = provider();
            Navigator.of(context).pop<RitualModifier>(copy);
          },
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
            Text('$name Editor'),
            Divider(),
            columnSpacer,
            ...widgets,
          ],
        ),
      ),
    );
  }
}
