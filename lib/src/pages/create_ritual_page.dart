import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../models/casting_model.dart';
import '../widgets/dynamic_list_header.dart';
import '../widgets/provider_aware_textfield.dart';
import '../widgets/ritual_modifier_list.dart';
import '../widgets/spell_effect_list.dart';

class CreateRitualPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CastingModel(),
      builder: (context, _) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: CreateRitualPanel(),
        ),
      ),
    );
  }
}

class CreateRitualPanel extends StatefulWidget {
  const CreateRitualPanel() : super(key: const Key('__CreateRitual__'));

  @override
  _CreateRitualPanelState createState() => _CreateRitualPanelState();
}

class _CreateRitualPanelState extends State<CreateRitualPanel> {
  final _titleEditingController = TextEditingController();
  final _notesEditingController = TextEditingController();

  @override
  void dispose() {
    _titleEditingController.dispose();
    _notesEditingController.dispose();
    super.dispose();
  }

  void _titleUpdated(String value) async {
    Provider.of<CastingModel>(context, listen: false).name = value;
  }

  void _notesUpdated(String value) async {
    Provider.of<CastingModel>(context, listen: false).notes = value;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    var children2 = [
      ProviderSelectorTextField<CastingModel>(
        key: Key('__ritualname__'),
        valueProvider: (_, model) => (model as CastingModel).name,
        onSubmitted: _titleUpdated,
        style: textTheme.headline5,
        decoration: InputDecoration(
          labelText: 'Ritual name',
          border: const OutlineInputBorder(),
        ),
      ),
      SpellEffectList(
        key: Key('InherentSpellEffects'),
        onEffectDeleted: (index, model) =>
            model.removeInherentSpellEffect(index),
        onEffectUpdated: (index, effect, model) =>
            model.updateInherentSpellEffect(index, effect),
        onEffectAdded: (effect, model) => model.addInherentSpellEffect(effect),
      ),
      RitualModifierList(
        key: Key("InherentModifiers"),
        onModifierDeleted: (index, model) =>
            model.removeInherentModifier(index),
        onModifierUpdated: (index, modifier, model) =>
            model.updateInherentModifier(index, modifier),
        onModifierAdded: (name, model) => model.addInherentModifier(name),
      ),
      IntrinsicHeight(
        child: Row(
          children: [
            Text(
              'Greater Effects: ',
              style: textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
            ),
            Selector<CastingModel, Tuple2<int, int>>(
              selector: (_, model) => Tuple2<int, int>(
                  model.greaterEffects, model.effectsMultiplier),
              builder: (context, tuple, child) {
                return Text(
                  '${tuple.item1} (×${tuple.item2}).',
                  style: TextStyle(fontSize: 16.0),
                );
              },
            ),
          ],
        ),
      ),
      ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 0.0),
        title:
            Text('Description', style: TextStyle(fontStyle: FontStyle.italic)),
        initiallyExpanded: false,
        children: [
          ProviderSelectorTextField<CastingModel>(
            valueProvider: (context, model) => (model as CastingModel).notes,
            maxLines: 6,
            onSubmitted: _notesUpdated,
            style: textTheme.headline5,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      Text(
        'Typical Casting:',
        style: textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
      ),
      DynamicListHeader(title: 'Additional Effects:'),
      DynamicListHeader(title: 'Additional Modifiers:'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children2
          .map((e) =>
              Padding(padding: const EdgeInsets.only(bottom: 12.0), child: e))
          .toList(),
    );
  }
}
