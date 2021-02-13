import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import '../models/delete_button_visible.dart';
import '../models/ritual_factory.dart';
import '../models/typedefs.dart';
import '../utils/utils.dart';
import 'delete_button.dart';
import 'dynamic_list_header.dart';
import 'modifier_widgets/modifier_row.dart';

class RitualModifierList extends StatelessWidget {
  const RitualModifierList({
    Key key,
    @required this.onModifierDeleted,
    @required this.onModifierAdded,
    @required this.onModifierUpdated,
    @required this.title,
    @required this.selector,
  }) : super(key: key);

  final OnModifierDeleted onModifierDeleted;
  final OnModifierAdded onModifierAdded;
  final OnModifierUpdated onModifierUpdated;
  final ModifierSelector selector;
  final String title;

  Future<void> _addModifier(BuildContext context) async {
    showMaterialSelectionPicker(
        context: context,
        title: 'Select Modifier:',
        items: modifierFactories.keys.toList(),
        selectedItem: AfflictionStun.label,
        onChanged: (value) => onModifierAdded(
            value, Provider.of<CastingModel>(context, listen: false)));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeleteButtonVisible(),
      child: Column(
        children: [
          Consumer<DeleteButtonVisible>(
            builder: (_, deleteVisible, __) => DynamicListHeader(
              title: title,
              deleteActive: deleteVisible.value,
              onAddPressed: () => _addModifier(context),
              onDelPressed: () => deleteVisible.value = !deleteVisible.value,
            ),
          ),
          Selector<CastingModel, List<RitualModifier>>(
            selector: selector,
            builder: (context, modifiers, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: modifiers.length,
                itemBuilder: (_, index) => RitualModifierLine(
                  modifier: modifiers[index],
                  index: index,
                  onModifierDeleted: onModifierDeleted,
                  onModifierUpdated: onModifierUpdated,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class RitualModifierLine extends StatelessWidget {
  const RitualModifierLine({
    @required this.modifier,
    @required this.index,
    @required this.onModifierDeleted,
    @required this.onModifierUpdated,
  });

  final int index;
  final RitualModifier modifier;
  final OnModifierDeleted onModifierDeleted;
  final OnModifierUpdated onModifierUpdated;

  Widget buildModifierEditor() => ModifierRow.type(modifier.runtimeType,
      modifier: modifier, index: index, onModifierUpdated: onModifierUpdated);
//  _map[modifier.runtimeType](modifier, index);

  @override
  Widget build(BuildContext context) {
    final Color oddBackground = Theme.of(context).accentColor.withOpacity(0.05);

    return Consumer<DeleteButtonVisible>(
      builder: (_, deleteVisible, __) => Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) => _deleteAction(context),
        child: Container(
          color: (index.isOdd) ? oddBackground : null,
          padding: EdgeInsets.only(right: 24.0),
          child: Row(
            children: [
              buildModifierEditor(),
              if (deleteVisible.value && isMediumScreen(context))
                DeleteButton(
                  onPressed: () => _deleteAction(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAction(BuildContext context) {
    onModifierDeleted(index, Provider.of<CastingModel>(context, listen: false));

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Modifier ${modifier.name} deleted')));
  }
}
