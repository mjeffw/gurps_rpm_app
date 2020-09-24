import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/ritual_model.dart';
import 'dynamic_list_header.dart';

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
              widgets.add(RitualModifierEditor(
                  modifier: modifiers[index], index: index));
            }
            return Column(children: widgets);
          },
        )
      ],
    );
  }
}

class RitualModifierEditor extends StatelessWidget {
  const RitualModifierEditor({this.modifier, this.index});

  final RitualModifier modifier;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Text('${modifier.name} ($index)');
  }
}
