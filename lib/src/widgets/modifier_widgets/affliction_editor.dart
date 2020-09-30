import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/modifier_widgets/arrow_button.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'modifier_row.dart';

class AfflictionStunRow extends ModifierRow {
  const AfflictionStunRow(RitualModifier modifier, int index)
      : assert(modifier is AfflictionStun),
        super(index: index, modifier: modifier);

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [];
  }

  @override
  String get label => '${modifier.name}';

  @override
  bool get isEditable => false;

  @override
  Widget dialogBuilder(BuildContext context) => throw UnimplementedError();
}

class AfflictionRow extends ModifierRow {
  const AfflictionRow(RitualModifier modifier, int index)
      : assert(modifier is Affliction),
        super(modifier: modifier, index: index);

  Affliction get affliction => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      Text('${affliction.effect}, '),
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, modifier.incrementEffect(-1)),
        ),
      Text('(${(affliction.percent >= 0) ? '+' : ''}${affliction.percent}%)'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, modifier.incrementEffect(1)),
        ),
      Text(''),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
}

const enhancements = const <String, int>{
  'Advantage': 10,
  'Attribute Penalty': 5,
  'Cumulative': 400,
  'Disadvantage': 1,
  'Agony': 100,
  'Choking': 100,
  'Daze': 50,
  'Ecstacy': 100,
  'Hallucinating': 50,
  'Paralysis': 150,
  'Retching': 50,
  'Seizure': 100,
  'Sleep': 150,
  'Unconsciousness': 200,
  'Coughing': 20,
  'Drunk': 20,
  'Euphoria': 30,
  'Moderate Pain': 20,
  'Nauseated': 30,
  'Severe Pain': 40,
  'Terrible Pain': 60,
  'Tipsy': 10,
  'Coma': 250,
  'Heart Attack': 300,
  'Negated Advantage': 1,
  'Stunning': 10,
};

/// Widget that contains the edit dialog for AfflictionRow.
class _Editor extends StatefulWidget {
  _Editor({@required this.modifier, @required this.index});

  final Affliction modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState(modifier);
}

class _EditorState extends State<_Editor> {
  _EditorState(this.modifier);

  TextEditingController _effectController;
  TextEditingController _percentController;
  Affliction modifier;

  @override
  void initState() {
    super.initState();
    _effectController = TextEditingController(text: modifier.effect);
    _percentController =
        TextEditingController(text: modifier.percent.toString());
  }

  @override
  void dispose() {
    _effectController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            var percent2 = int.parse(_percentController.text);
            var copy = modifier.copyWith(
                effect: _effectController.text, percent: percent2);

            Navigator.of(context).pop<RitualModifier>(copy);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Affliction Editor'),
          Divider(),
          columnSpacer,
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _effectController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Effect',
                border: const OutlineInputBorder(),
              ),
            ),
            hideOnEmpty: true,
            suggestionsCallback: getSuggestions,
            itemBuilder: (context, suggestion) => ListTile(
                title: Text('${suggestion.key} (${suggestion.value})')),
            onSuggestionSelected: (suggestion) {
              setState(() {
                _effectController.text = suggestion.key;
                _percentController.text = suggestion.value.toString();
              });
            },
          ),
          columnSpacer,
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.fast_rewind,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    modifier = modifier.incrementEffect(-10);
                    _percentController.text = modifier.percent.toString();
                  });
                },
              ),
              IconButton(
                icon: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    modifier = modifier.incrementEffect(-1);
                    _percentController.text = modifier.percent.toString();
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  width: 80.0,
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: _percentController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      suffixText: '%',
                      labelText: 'Percent',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    modifier = modifier.incrementEffect(1);
                    _percentController.text = modifier.percent.toString();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_forward,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    modifier = modifier.incrementEffect(10);
                    _percentController.text = modifier.percent.toString();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<MapEntry<String, int>> getSuggestions(String pattern) {
    RegExp regex = RegExp(pattern.toLowerCase());
    return enhancements.entries
        .where((element) => regex.hasMatch(element.key.toLowerCase()))
        .toList();
  }
}
