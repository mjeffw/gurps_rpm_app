import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

const rowSpacer = const Padding(padding: EdgeInsets.only(right: 8.0));
const rowWideSpacer = const Padding(padding: EdgeInsets.only(right: 16.0));
const columnSpacer = const Padding(padding: EdgeInsets.only(bottom: 8.0));

bool _isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}

class AfflictionWidget extends StatelessWidget {
  const AfflictionWidget(this.modifier, this.index)
      : assert(modifier is Affliction);

  final Affliction modifier;
  final int index;

  @override
  Widget build(BuildContext context) {
    _ModifierUpdaterCommand updater = _ModifierUpdaterCommand(context: context);

    return Expanded(
      child: Row(
        children: [
          Text('${modifier.name}'),
          rowWideSpacer,
          Text('(${modifier.effect}, '),
          if (_isMediumScreen(context))
            IconButton(
              padding: EdgeInsets.all(0.0),
              icon: RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.blue,
                ),
              ),
              onPressed: () =>
                  updater.update(index, modifier.incrementEffect(-1)),
            ),
          Text('${(modifier.percent >= 0) ? '+' : ''}${modifier.percent}%'),
          if (_isMediumScreen(context))
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: Colors.blue,
              ),
              onPressed: () =>
                  updater.update(index, modifier.incrementEffect(1)),
            ),
          Text(')'),
          Spacer(),
          Text('[${modifier.energyCost}]'),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _Editor(
                  modifier: modifier,
                  index: index,
                  updater: updater,
                ),
                barrierDismissible: false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModifierUpdaterCommand {
  const _ModifierUpdaterCommand({this.context});

  final BuildContext context;

  void update(int index, RitualModifier modifier) {
    Provider.of<CastingModel>(context, listen: false)
        .updateInherentModifier(index, modifier);
  }
}

class _Editor extends StatefulWidget {
  _Editor({this.modifier, this.index, this.updater});

  final Affliction modifier;
  final int index;
  final _ModifierUpdaterCommand updater;

  @override
  _EditorState createState() => _EditorState(modifier);
}

class _EditorState extends State<_Editor> {
  _EditorState(this.modifier);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _effectController;
  TextEditingController _percentController;
  Affliction modifier;

  @override
  void initState() {
    super.initState();
    _effectController = TextEditingController(text: widget.modifier.effect);
    _percentController =
        TextEditingController(text: widget.modifier.energyCost.toString());
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
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            widget.updater.update(widget.index, modifier);
            Navigator.of(context).pop();
          },
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Affliction Editor'),
            Divider(),
            columnSpacer,
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _effectController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Effect',
                  border: const OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: getSuggestions,
              itemBuilder: (context, suggestion) => ListTile(
                  title: Text('${suggestion.key} (${suggestion.value})')),
              onSuggestionSelected: (suggestion) {
                modifier = modifier.copyWith(
                    effect: suggestion.key, percent: suggestion.value);
                _effectController.text = modifier.effect;
                _percentController.text = modifier.percent.toString();
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
