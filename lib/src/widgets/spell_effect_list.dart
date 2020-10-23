import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import '../models/delete_button_visible.dart';
import 'dynamic_list_header.dart';
import 'spell_effects_editor.dart';

class SpellEffectList extends StatelessWidget {
  const SpellEffectList({
    Key key,
  }) : super(key: key);

  static List<String> _pathOptions = [
    'Body',
    'Chance',
    'Crossroads',
    'Energy',
    'Magic',
    'Matter',
    'Mind',
    'Spirit',
    'Undead',
  ];

  Future<void> _addPath(BuildContext context) async {
    showMaterialSelectionPicker(
        context: context,
        title: 'Select Path:',
        items: _pathOptions,
        selectedItem: 'Body',
        onChanged: (value) => Provider.of<CastingModel>(context, listen: false)
            .addInherentSpellEffect(value));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeleteButtonVisible(),
      child: Column(
        children: [
          Consumer<DeleteButtonVisible>(
            builder: (_, deleteVisible, __) => DynamicListHeader(
              title: 'Spell Effects:',
              deleteActive: deleteVisible.value,
              onAddPressed: () => _addPath(context),
              onDelPressed: () => deleteVisible.value = !deleteVisible.value,
            ),
          ),
          Selector<CastingModel, List<SpellEffect>>(
            selector: (_, model) => model.inherentSpellEffects,
            builder: (context, effects, child) {
              List<Widget> widgets = [];
              for (var index = 0; index < effects.length; index++) {
                widgets.add(SpellEffectEditor(
                  key: ValueKey<String>('InherentEffects'),
                  effect: effects[index],
                  index: index,
                  onEffectDeleted: (index, model) {
                    model.removeInherentSpellEffect(index);
                  },
                  onEffectUpdated: (index, effect, model) =>
                      model.updateInherentSpellEffect(index, effect),
                ));
              }
              return Column(
                children: widgets,
              );
            },
          ),
        ],
      ),
    );
  }
}
