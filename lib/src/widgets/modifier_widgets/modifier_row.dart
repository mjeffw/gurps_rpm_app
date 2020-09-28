import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'edit_button.dart';

abstract class ModifierRow extends StatelessWidget {
  const ModifierRow({this.modifier, this.index});

  final RitualModifier modifier;
  final int index;

  /// Subclasses must override to eturn the list of Widgets that make up the
  /// Modifier list row.
  List<Widget> buildModifierRowWidgets(BuildContext context);

  /// If true, the Edit button is displayed at the end of the row.
  ///
  /// Subclasses should override this to return false if the Modifier has no
  /// edit dialog.
  bool get isEditable => true;

  /// Return the widget that represents the Modifier edit dialog.
  ///
  /// The edit dialog must return a RitualModifier in its pop() method.
  Widget dialogBuilder(BuildContext context);

  void buildShowDialog(BuildContext context) async {
    RitualModifier newModifier = await showDialog<RitualModifier>(
        context: context,
        barrierDismissible: false,
        builder: (context) => dialogBuilder(context));

    Provider.of<CastingModel>(context, listen: false)
        .updateInherentModifier(index, newModifier);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Text('${modifier.name}'),
        rowWideSpacer,
        ...buildModifierRowWidgets(context),
        Spacer(),
        Text('[${modifier.energyCost}]'),
        EditButton(
            onPressed: isEditable ? () => buildShowDialog(context) : null),
      ]),
    );
  }
}
