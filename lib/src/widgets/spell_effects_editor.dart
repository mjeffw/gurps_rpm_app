import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/delete_button_visible.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import 'delete_button.dart';
import '../utils/utils.dart';

typedef OnEffectUpdated = void Function(int, SpellEffect, CastingModel);
typedef OnEffectDeleted = void Function(int, CastingModel);

class SpellEffectEditor extends StatelessWidget {
  SpellEffectEditor({
    @required Key key,
    @required this.effect,
    @required this.index,
    @required this.onEffectUpdated,
    @required this.onEffectDeleted,
  }) : super(key: key);

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
                onChanged: (value) {
                  print('');
                  var model = Provider.of<CastingModel>(context, listen: false);
                  model.updateInherentSpellEffect(
                      index, effect.withLevel(value));
                },
                value: effect.level,
              ),
              rowSpacer,
              DropdownButton(
                key: Key('$_keyText-EFFECT'),
                items: _effectItems(context),
                onChanged: (value) => Provider.of<CastingModel>(context,
                        listen: false)
                    .updateInherentSpellEffect(index, effect.withEffect(value)),
                value: effect.effect,
              ),
              rowSpacer,
              Text('${effect.path}'),
              Spacer(),
              if (deleteVisible.value && isMediumScreen(context))
                DeleteButton(
                  key: Key('$_keyText-DEL'),
                  onPressed: () => _deleteAction(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

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
