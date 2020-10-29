import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import '../models/delete_button_visible.dart';
import '../models/typedefs.dart';
import 'dynamic_list_header.dart';
import 'spell_effects_editor.dart';

class SpellEffectList extends StatelessWidget {
  const SpellEffectList({
    Key key,
    @required this.onEffectDeleted,
    @required this.onEffectUpdated,
    @required this.onEffectAdded,
    @required this.title,
    @required this.selector,
  }) : super(key: key);

  final OnEffectDeleted onEffectDeleted;
  final OnEffectUpdated onEffectUpdated;
  final OnEffectAdded onEffectAdded;
  final String title;
  final SpellEffectSelector selector;

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
        onChanged: (value) => onEffectAdded(
            value, Provider.of<CastingModel>(context, listen: false)));
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
              title: title,
              deleteActive: deleteVisible.value,
              onAddPressed: () => _addPath(context),
              onDelPressed: () => deleteVisible.value = !deleteVisible.value,
            ),
          ),
          Selector<CastingModel, List<SpellEffect>>(
            selector: selector,
            builder: (context, effects, child) {
              return ListView.builder(
                key: Key('$_keyText-LIST'),
                shrinkWrap: true,
                itemCount: effects.length,
                itemBuilder: (_, index) => SpellEffectEditor(
                  key: Key('InherentSpellEffectEditor'),
                  effect: effects[index],
                  index: index,
                  onEffectDeleted: onEffectDeleted,
                  onEffectUpdated: onEffectUpdated,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
