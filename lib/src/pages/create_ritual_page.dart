import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:gurps_rpm_app/src/models/ritual_model.dart';
import 'package:gurps_rpm_app/src/widgets/provider_aware_textfield.dart';
import 'package:gurps_rpm_app/src/widgets/dynamic_list_header.dart';
import 'package:gurps_rpm_app/src/widgets/spell_effects_editor.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CreateRitualPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: ChangeNotifierProvider(
          create: (context) => CastingModel(),
          builder: (context, _) => CreateRitualPanel(),
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

  List<String> pathOptions = [
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

  @override
  void dispose() {
    _titleEditingController.dispose();
    _notesEditingController.dispose();
    super.dispose();
  }

  void _titleUpdated(String value) async {
    print('onSubmitted($value)');
    Provider.of<CastingModel>(context, listen: false).name = value;
  }

  void _notesUpdated(String value) async {
    print('onSubmitted($value)');
    Provider.of<CastingModel>(context, listen: false).notes = value;
  }

  Future<void> _addPath(BuildContext context) async {
    showMaterialSelectionPicker(
        context: context,
        title: 'Select Path:',
        items: pathOptions,
        selectedItem: 'Body',
        onChanged: (value) => Provider.of<CastingModel>(context, listen: false)
            .addInherentSpellEffect(value));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProviderSelectorTextField<CastingModel>(
          valueProvider: () =>
              Provider.of<CastingModel>(context, listen: false).name,
          onSubmitted: _titleUpdated,
          autofocus: true,
          style: textTheme.headline5,
          decoration: InputDecoration(
            labelText: 'Ritual name',
            border: const OutlineInputBorder(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: DynamicListHeader(
            title: 'Spell Effects:',
            onPressed: () => _addPath(context),
          ),
        ),
        SpellEffectList(),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: DynamicListHeader(title: 'Inherent Modifiers:'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  'Greater Effects: ',
                  style:
                      textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
                ),
                Selector<CastingModel, Tuple2<int, int>>(
                    selector: (_, model) => Tuple2<int, int>(
                        model.greaterEffects, model.effectsMultiplier),
                    builder: (context, tuple, child) {
                      return Text(
                        '${tuple.item1} (×${tuple.item2}).',
                        style: TextStyle(fontSize: 16.0),
                      );
                    }),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0.0),
            title: Text('Description',
                style: TextStyle(fontStyle: FontStyle.italic)),
            initiallyExpanded: false,
            children: [
              ProviderSelectorTextField<CastingModel>(
                valueProvider: () =>
                    Provider.of<CastingModel>(context, listen: false).notes,
                maxLines: 6,
                onSubmitted: _notesUpdated,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        Text(
          'Typical Casting:',
          style: textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: DynamicListHeader(title: 'Additional Effects:'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: DynamicListHeader(title: 'Additional Modifiers:'),
        ),
      ],
    );
  }
}

class SpellEffectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CastingModel, List<SpellEffect>>(
      selector: (_, model) => model.inherentSpellEffects,
      builder: (context, effects, child) {
        List<Widget> widgets = [];
        for (var index = 0; index < effects.length; index++) {
          widgets.add(SpellEffectEditor(effect: effects[index], index: index));
        }
        return Column(
          children: widgets,
        );
      },
    );
  }
}
