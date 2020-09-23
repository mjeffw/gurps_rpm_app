import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/ritual_model.dart';
import 'package:gurps_rpm_app/src/widgets/ProviderAwareTextField.dart';
import 'package:provider/provider.dart';

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
              labelText: 'Ritual name', border: const OutlineInputBorder()),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Spell Effects:',
                  style:
                      textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
                ),
                Expanded(
                  child: Divider(
                    indent: 8.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Inherent Modifiers:',
                  style:
                      textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
                ),
                Expanded(
                  child: Divider(
                    indent: 8.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Text(
                'Greater Effects: ',
                style:
                    textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
              ),
              Text('0 (×1).', style: TextStyle(fontSize: 16.0))
            ],
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Additional Effects:',
                  style:
                      textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
                ),
                Expanded(
                  child: Divider(
                    indent: 8.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Additional Modifiers:',
                  style:
                      textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
                ),
                Expanded(
                  child: Divider(
                    indent: 8.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
