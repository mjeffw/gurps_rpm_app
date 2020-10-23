import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/delete_button_visible.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import 'delete_button.dart';
import 'utils.dart';

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

  List<DropdownMenuItem> _levelItems(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Level.labels
        .map(
          (it) => DropdownMenuItem<Level>(
            value: Level.fromString(it),
            child: Text(it, style: textTheme.subtitle2),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem> _effectItems(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Effect.labels
        .map(
          (it) => DropdownMenuItem<Effect>(
            value: Effect.fromString(it),
            child: Text(it, style: textTheme.subtitle2),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    this.key.toString();
    final Color oddBackground = Theme.of(context).accentColor.withOpacity(0.05);

    return Consumer<DeleteButtonVisible>(
      key: ValueKey<String>('${(key as ValueKey).value}:$index'),
      builder: (_, deleteVisible, __) => IntrinsicHeight(
        child: Dismissible(
          key: ValueKey<String>('${(key as ValueKey).value}:$index'),
          background: Container(color: Colors.red),
          onDismissed: (_) => _deleteAction(context),
          child: Container(
            color: (index.isOdd) ? oddBackground : null,
            padding: EdgeInsets.only(right: 24.0),
            child: Row(
              children: [
                DropdownButton(
                  items: _levelItems(context),
                  onChanged: (value) => onEffectUpdated(
                      index,
                      effect.withLevel(value),
                      Provider.of<CastingModel>(context, listen: false)),
                  value: effect.level,
                ),
                rowSpacer,
                DropdownButton(
                  items: _effectItems(context),
                  onChanged: (value) => onEffectUpdated(
                      index,
                      effect.withEffect(value),
                      Provider.of<CastingModel>(context, listen: false)),
                  value: effect.effect,
                ),
                rowSpacer,
                Text('${effect.path}'),
                Spacer(),
                if (deleteVisible.value && isMediumScreen(context))
                  DeleteButton(
                    onPressed: () => _deleteAction(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteAction(BuildContext context) {
    onEffectDeleted(index, Provider.of<CastingModel>(context, listen: false));

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Effect "$effect" deleted')),
    );
  }
}
