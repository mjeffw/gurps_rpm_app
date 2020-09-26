import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/ritual_model.dart';
import '../widgets/affliction_editor.dart';
import 'dynamic_list_header.dart';

typedef WidgetBuilder = Widget Function(RitualModifier, int);

final Map<Type, WidgetBuilder> _map = {
  AfflictionStun: (modifier, index) => Text('${modifier.name}'),
  Affliction: (modifier, index) => AfflictionWidget(modifier, index),
};

class RitualModifierList extends StatelessWidget {
  const RitualModifierList({
    Key key,
  }) : super(key: key);

  Future<void> _addModifier(BuildContext context) async {
    showMaterialSelectionPicker(
        context: context,
        title: 'Select Modifier:',
        items: RitualModifier.labels,
        selectedItem: AfflictionStun.label,
        onChanged: (value) => Provider.of<CastingModel>(context, listen: false)
            .addInherentModifier(value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DynamicListHeader(
          title: 'Inherent Modifiers:',
          onPressed: () => _addModifier(context),
        ),
        Selector<CastingModel, List<RitualModifier>>(
          selector: (_, model) => model.inherentModifiers,
          builder: (context, modifiers, child) {
            var widgets = <Widget>[];
            for (var index = 0; index < modifiers.length; index++) {
              widgets.add(
                  RitualModifierLine(modifier: modifiers[index], index: index));
            }
            return Column(children: widgets);
          },
        )
      ],
    );
  }
}

class RitualModifierLine extends StatelessWidget {
  const RitualModifierLine({this.modifier, this.index});

  final RitualModifier modifier;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Color oddBackground = Theme.of(context).accentColor.withOpacity(0.05);

    final widget = buildModifierEditor();

    return IntrinsicHeight(
      child: Container(
        color: (index.isOdd) ? oddBackground : null,
        padding: EdgeInsets.only(right: 24.0),
        child: Row(
          children: [
            widget,
            //Spacer(),
            IconButton(
              icon: Icon(
                Icons.remove_circle_rounded,
                color: Colors.red,
              ),
              onPressed: () => Provider.of<CastingModel>(context, listen: false)
                  .removeInherentSpellEffect(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModifierEditor() {
    var map = _map[modifier.runtimeType];
    return map(modifier, index);
  }
}
