import 'package:flutter/material.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../../models/typedefs.dart';
import '../../utils/utils.dart';
import '../int_spinner.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class AfflictionStunRow extends ModifierRow {
  const AfflictionStunRow(
      {RitualModifier modifier, int index, OnModifierUpdated onModifierUpdated})
      : assert(modifier is AfflictionStun),
        super(
            index: index,
            modifier: modifier,
            onModifierUpdated: onModifierUpdated);

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) => [];

  @override
  String get label => '${modifier.name}';

  String get effectText => null;

  @override
  bool get isEditable => false;

  @override
  Widget dialogBuilder(BuildContext context) => throw UnimplementedError();
}

class AfflictionRow extends ModifierRow {
  const AfflictionRow(
      {RitualModifier modifier, int index, OnModifierUpdated onModifierUpdated})
      : assert(modifier is Affliction),
        super(
            modifier: modifier,
            index: index,
            onModifierUpdated: onModifierUpdated);

  Affliction get _affliction => super.modifier;

  String get detailText => '${_affliction.effect}, ';

  String get effectText =>
      '${(_affliction.percent >= 0) ? '+' : ''}${_affliction.percent}%';

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

class IntEditingController extends ValueNotifier<int> {
  IntEditingController(int value) : super(value);
}

class _EditorState extends State<_Editor> {
  _EditorState(this.modifier);

  Affliction modifier;

  TextEditingController _effectController;

  ValueNotifier<int> _percent;

  int get percent => _percent.value;

  set percent(int value) {
    _percent.value = value;
  }

  @override
  void initState() {
    super.initState();
    _effectController = TextEditingController(text: modifier.effect);
    _percent = ValueNotifier(modifier.percent);
  }

  @override
  void dispose() {
    _effectController.dispose();
    _percent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditorDialog(
      provider: _createModifier,
      name: widget.modifier.name,
      widgets: _modifierWidgets(),
    );
  }

  Affliction _createModifier() {
    return modifier.copyWith(
      effect: _effectController.text,
      percent: percent,
    );
  }

  List<Widget> _modifierWidgets() {
    return [
      TypeAheadField<MapEntry<String, int>>(
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
        itemBuilder: (context, suggestion) =>
            ListTile(title: Text('${suggestion.key} (${suggestion.value})')),
        onSuggestionSelected: (suggestion) {
          setState(() {
            _effectController.text = suggestion.key;
            percent = suggestion.value;
          });
        },
      ),
      columnSpacer,
      IntSpinner(
        onChanged: (value) => setState(() => percent = value),
        valueNotifier: _percent,
        initialValue: percent,
        bigStep: 50,
        smallStep: 5,
        minValue: 0,
        textFieldWidth: 90.0,
        decoration: InputDecoration(
          suffixText: '%',
          labelText: 'Percent',
        ),
      ),
    ];
  }

  List<MapEntry<String, int>> getSuggestions(String pattern) {
    RegExp regex = RegExp(pattern.toLowerCase());
    return enhancements.entries
        .where((entry) => regex.hasMatch(entry.key.toLowerCase()))
        .toList();
  }
}
