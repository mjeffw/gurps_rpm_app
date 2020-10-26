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
        onChanged: (value) {
          var model = Provider.of<CastingModel>(context, listen: false);
          model.addInherentSpellEffect(value);
        });
  }

  String get _keyText =>
      (key is ValueKey) ? (key as ValueKey).value : key.toString();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeleteButtonVisible(),
      child: Column(
        children: [
          Consumer<DeleteButtonVisible>(
            builder: (_, deleteVisible, __) => DynamicListHeader(
              key: Key('$_keyText-HEADER'),
              title: 'Spell Effects:',
              deleteActive: deleteVisible.value,
              onAddPressed: () => _addPath(context),
              onDelPressed: () => deleteVisible.value = !deleteVisible.value,
            ),
          ),
          Selector<CastingModel, List<SpellEffect>>(
            selector: (_, model) => model.inherentSpellEffects,
            builder: (context, effects, child) {
              return ListView.builder(
                key: Key('$_keyText-LIST'),
                shrinkWrap: true,
                itemCount: effects.length,
                itemBuilder: (_, index) => SpellEffectEditor(
                  key: UniqueKey(),
                  effect: effects[index],
                  index: index,
                  onEffectDeleted: (index, model) =>
                      _deleteAction(index, model, context),
                  onEffectUpdated: (index, effect, model) =>
                      model.updateInherentSpellEffect(index, effect),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _deleteAction(int index, CastingModel model, BuildContext context) {
    SpellEffect effect = model.inherentSpellEffects[index];
    model.removeInherentSpellEffect(index);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Effect $effect deleted')));
  }
}
