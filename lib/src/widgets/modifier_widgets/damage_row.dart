import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';
import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import '../delete_button.dart';
import '../dice_spinner.dart';
import '../dynamic_list_header.dart';
import '../../utils/utils.dart';
import 'editor_dialog.dart';
import 'modifier_row.dart';

class DamageRow extends ModifierRow {
  DamageRow({RitualModifier modifier, int index})
      : assert(modifier is Damage),
        super(modifier: modifier, index: index);

  Damage get damage => super.modifier;

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);

  @override
  String get suffixText => (damage.modifiers.isEmpty)
      ? ''
      : '(' +
          damage.modifiers
              .map((it) => it.summaryText)
              .reduce((a, b) => a + ', ' + b) +
          ')';

  @override
  String get detailText =>
      '${damage.direct ? 'Internal' : 'External'} ${damage.type.label},';

  @override
  String get effectText => '${damage.damageDice}';
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index});

  final Damage modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  DieRoll _dice;
  bool _direct;
  bool _explosive;
  DamageType _type;
  List<TraitModifier> _modifiers = [];

  @override
  void initState() {
    super.initState();
    _dice = widget.modifier.dice;
    _direct = widget.modifier.direct;
    _explosive = widget.modifier.explosive;
    _type = widget.modifier.type;
    _modifiers.addAll(widget.modifier.modifiers);
  }

  Damage _createModifier() => Damage(
      dice: _dice,
      direct: _direct,
      explosive: _explosive,
      type: _type,
      modifiers: _modifiers);

  @override
  Widget build(BuildContext context) {
    return EditorDialog(
      provider: _createModifier,
      name: widget.modifier.name,
      widgets: _modifierWidgets(),
    );
  }

  List<Widget> _modifierWidgets() {
    return [
      DiceSpinner(
        onChanged: (value) => setState(() => _dice = value),
        initialValue: _dice,
        textFieldWidth: 90.0,
      ),
      columnSpacer,
      Container(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButton<DamageType>(
          underline: Container(),
          value: _type,
          items: _damageTypeItems(),
          onChanged: (value) => setState(() => _type = value),
        ),
      ),
      columnSpacer,
      SwitchListTile(
        value: _direct,
        onChanged: (state) => setState(() => _direct = state),
        title: Text(_direct ? 'Internal (Direct)' : 'External (Indirect)'),
      ),
      if (!_direct) ...<Widget>[
        columnSpacer,
        CheckboxListTile(
          value: _explosive,
          onChanged: (state) => setState(() => _explosive = state),
          title: Text('Explosive'),
        ),
      ],
      columnSpacer,
      DynamicListHeader(
        title: 'Enhancements/Limitations',
        onAddPressed: () => setState(
            () => _modifiers.add(TraitModifier(name: 'Undefined', percent: 0))),
      ),
      Flexible(
        fit: FlexFit.loose,
        child:
            // ListView.builder(
            //   shrinkWrap: true,
            //   padding: EdgeInsets.all(0.0),
            //   scrollDirection: Axis.vertical,
            //   itemCount: _modifiers.length,
            //   itemBuilder: _itemBuilder,
            // ),
            SingleChildScrollView(
          child: ListBody(
            children: _enhancementList(),
          ),
        ),
      ),
    ];
  }

  // ignore: unused_element
  Widget _itemBuilder(BuildContext context, int index) {
    return _EnhancerEditor(
      _modifiers[index],
      index: index,
      onChanged: (index, enhancer) =>
          setState(() => _modifiers[index] = enhancer),
      onDeleted: (index, enhancer) =>
          setState(() => _modifiers.removeAt(index)),
    );
  }

  // ignore: unused_element
  List<Widget> _enhancementList() {
    var list = <Widget>[];
    _modifiers.forEach(
      (element) {
        list.add(
          _EnhancerEditor(
            element,
            index: _modifiers.indexOf(element),
            onChanged: (index, enhancer) =>
                setState(() => _modifiers[index] = enhancer),
            onDeleted: (index, enhancer) =>
                setState(() => _modifiers.removeAt(index)),
          ),
        );
      },
    );
    return list;
  }

  List<DropdownMenuItem<DamageType>> _damageTypeItems() =>
      DamageType.map.entries
          .map((entry) => DropdownMenuItem<DamageType>(
              child: Text(entry.key), value: entry.value))
          .toList();
}

typedef TraitModifierCallback = void Function(int, TraitModifier);

class _EnhancerEditor extends StatefulWidget {
  _EnhancerEditor(this.enhancer,
      {@required this.onChanged,
      @required this.onDeleted,
      @required this.index});

  final TraitModifier enhancer;
  final TraitModifierCallback onChanged;
  final TraitModifierCallback onDeleted;
  final int index;

  @override
  __EnhancerEditorState createState() => __EnhancerEditorState();
}

class __EnhancerEditorState extends State<_EnhancerEditor> {
  TextEditingController _nameController;
  TextEditingController _percentController;
  bool _validInput = true;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.enhancer.name);
    _nameController.addListener(_onChanged);

    _percentController =
        TextEditingController(text: widget.enhancer.percent.toString());
    _percentController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onChanged);
    _nameController.dispose();

    _percentController.removeListener(_onChanged);
    _percentController.dispose();

    super.dispose();
  }

  void _onChanged() {
    String text = _percentController.text.trim();
    setState(() {
      int value = int.tryParse(text);
      _validInput = (value != null);

      if (_validInput) {
        widget.onChanged(widget.index,
            TraitModifier(name: _nameController.text, percent: value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TypeAheadField<MapEntry<String, int>>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enhancement/Limitation',
                    border: const OutlineInputBorder(),
                  ),
                ),
                hideOnEmpty: true,
                suggestionsCallback: getSuggestions,
                itemBuilder: (context, suggestion) => ListTile(
                  title: Text('${suggestion.key} (${suggestion.value}%)'),
                ),
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _nameController.text = suggestion.key;
                    _percentController.text = suggestion.value.toString();
                  });
                },
              ),
            ),
            rowSpacer,
            SizedBox(
              width: 80.0,
              child: TextField(
                controller: _percentController,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))
                ],
                decoration: const InputDecoration(
                  suffixText: '%',
                  labelText: 'Percent',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            DeleteButton(
              onPressed: () => widget.onDeleted(widget.index, widget.enhancer),
            )
          ],
        ),
      ),
    );
  }

  List<MapEntry<String, int>> getSuggestions(String pattern) {
    RegExp regex = RegExp(pattern.toLowerCase());
    return enhancements.entries
        .where((entry) => regex.hasMatch(entry.key.toLowerCase()))
        .toList();
  }
}

const enhancements = <String, int>{
  'Double Knockback': 20,
  'Jet': 0,
  'No Wounding': -50,
};
