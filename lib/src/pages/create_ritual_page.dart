import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/utils/selectable_text_exporter.dart';
import 'package:gurps_rpm_app/src/widgets/casting_summary_text.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/link.dart';

import '../models/casting_model.dart';
import '../widgets/markdown_text_with_copy.dart';
import '../widgets/provider_aware_textfield.dart';
import '../widgets/ritual_modifier_list.dart';
import '../widgets/spell_effect_list.dart';

const url = 'https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf';

class CreateRitualPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: CreateRitualPanel(),
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

  void _titleUpdated(String value) async =>
      Provider.of<CastingModel>(context, listen: false).name = value;

  void _notesUpdated(String value) async =>
      Provider.of<CastingModel>(context, listen: false).notes = value;

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
        title: 'Spell Effects',
        selector: (_, model) => model.inherentSpellEffects,
        onEffectDeleted: (index, model) =>
            model.removeInherentSpellEffect(index),
        onEffectUpdated: (index, effect, model) =>
            model.updateInherentSpellEffect(index, effect),
        onEffectAdded: (effect, model) => model.addInherentSpellEffect(effect),
      ),
      RitualModifierList(
        key: Key('InherentModifiers'),
        title: 'Inherent Modifiers',
        selector: (_, model) => model.inherentModifiers,
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
      Container(
        color: Theme.of(context).accentColor.withOpacity(0.05),
        child: Tooltip(
          message: 'Tap to open editor',
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0.0),
            title: Text('Description',
                style: TextStyle(fontStyle: FontStyle.italic)),
            initiallyExpanded: false,
            children: [
              ProviderSelectorTextField<CastingModel>(
                valueProvider: (context, model) =>
                    (model as CastingModel).notes,
                maxLines: 6,
                onSubmitted: _notesUpdated,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
              Link(
                uri: Uri.parse(url),
                target: LinkTarget.blank,
                builder: (_, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Text('Use Markdown syntax'),
                ),
              ),
            ],
          ),
        ),
      ),
      Text(
        'Typical Casting:',
        style: textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
      ),
      SpellEffectList(
        key: Key('AdditionalSpellEffects'),
        title: 'Additional Effects',
        selector: (_, model) => model.additionalSpellEffects,
        onEffectAdded: (effect, model) =>
            model.addAdditionalSpellEffect(effect),
        onEffectDeleted: (index, model) =>
            model.removeAdditionalSpellEffect(index),
        onEffectUpdated: (index, effect, model) =>
            model.updateAdditionalSpellEffect(index, effect),
      ),
      RitualModifierList(
        title: 'Additional Modifiers',
        selector: (_, model) => model.addtionalModifiers,
        onModifierDeleted: (index, model) =>
            model.removeAdditionalModifier(index),
        onModifierUpdated: (index, modifier, model) =>
            model.updateAdditionalModifier(index, modifier),
        onModifierAdded: (name, model) => model.addAdditionalModifier(name),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Divider(),
      ),
      Selector<CastingModel, SelectableTextExporter>(
        selector: (_, model) => model.exporter,
        builder: (context, exporter, child) =>
            CastingSummaryText(exporter: exporter),
      ),
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
