import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import '../models/delete_button_visible.dart';
import '../models/typedefs.dart';
import '../utils/utils.dart';
import 'delete_button.dart';

class SpellEffectEditor extends StatelessWidget {
  SpellEffectEditor({
    Key key,
    @required this.effect,
    @required this.index,
    @required this.onEffectUpdated,
    @required this.onEffectDeleted,
  }) : super(key: key ?? UniqueKey());

  final SpellEffect effect;
  final int index;
  final OnEffectUpdated onEffectUpdated;
  final OnEffectDeleted onEffectDeleted;

  String get _keyText =>
      (key is ValueKey) ? (key as ValueKey).value : key.toString();

  @override
  Widget build(BuildContext context) {
    final Color oddBackground = Theme.of(context).accentColor.withOpacity(0.05);

    return Consumer<DeleteButtonVisible>(
      builder: (_, deleteVisible, __) => Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (_) => _deleteAction(context),
        child: Container(
          color: (index.isOdd) ? oddBackground : null,
          padding: EdgeInsets.only(right: 24.0),
          child: Row(
            children: [
              DropdownButton(
                key: Key('$_keyText-LEVEL'),
                items: _levelItems(context),
                onChanged: (value) => onEffectUpdated(
                  index,
                  effect.withLevel(value),
                  _model(context),
                ),
                value: effect.level,
              ),
              rowSpacer,
              DropdownButton(
                key: Key('$_keyText-EFFECT'),
                items: _effectItems(context),
                onChanged: (value) => onEffectUpdated(
                  index,
                  effect.withEffect(value),
                  _model(context),
                ),
                value: effect.effect,
              ),
              rowSpacer,
              Text('${effect.path}'),
              Spacer(),
              if (deleteVisible.value && isMediumScreen(context))
                DeleteButton(
                  key: Key('$_keyText-DEL'),
                  onPressed: () => _deleteEffect(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteEffect(BuildContext context) {
    SpellEffect effect = _model(context).inherentSpellEffects[index];
    onEffectDeleted(index, _model(context));
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Inherent Effect $effect deleted')));
  }

  CastingModel _model(BuildContext context) =>
      Provider.of<CastingModel>(context, listen: false);

  /// Builds the list of "Levels" (Greater, Lesser) to populate the Levels dropdown menu.
  List<DropdownMenuItem> _levelItems(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Level.labels
        .map(
          (it) => DropdownMenuItem<Level>(
            key: Key('$_keyText-LEVEL[$it]'),
            value: Level.fromString(it),
            child: Text(it, style: textTheme.subtitle2),
          ),
        )
        .toList();
  }

  /// Builds the list of "Effects" (Create, Destroy, ...) to populate the Levels dropdown menu.
  List<DropdownMenuItem> _effectItems(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Effect.labels
        .map(
          (it) => DropdownMenuItem<Effect>(
            key: Key('$_keyText-EFFECT[$it]'),
            value: Effect.fromString(it),
            child: Text(it, style: textTheme.subtitle2),
          ),
        )
        .toList();
  }

  void _deleteAction(BuildContext context) {
    Provider.of<CastingModel>(context, listen: false)
        .removeInherentSpellEffect(index);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Effect $effect deleted')));
  }
}
