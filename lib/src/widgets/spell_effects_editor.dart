import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/delete_button_visible.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/casting_model.dart';
import 'delete_button.dart';
import 'utils.dart';

class SpellEffectEditor extends StatelessWidget {
  const SpellEffectEditor({
    Key key,
    @required this.effect,
    @required this.index,
  }) : super(key: key);

  final SpellEffect effect;
  final int index;

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
    final Color oddBackground = Theme.of(context).accentColor.withOpacity(0.05);

    return Consumer<DeleteButtonVisible>(
      key: Key('IntrinsicSpellEffectEditorWrapper:$index'),
      builder: (_, deleteVisible, __) => IntrinsicHeight(
        child: Dismissible(
          key: Key('IntrinsicSpellEffectEditor:$index'),
          background: Container(color: Colors.red),
          onDismissed: (_) => _deleteAction(context),
          child: Container(
            color: (index.isOdd) ? oddBackground : null,
            padding: EdgeInsets.only(right: 24.0),
            child: Row(
              children: [
                DropdownButton(
                  items: _levelItems(context),
                  onChanged: (value) =>
                      Provider.of<CastingModel>(context, listen: false)
                          .updateInherentSpellEffect(
                              index, effect.withLevel(value)),
                  value: effect.level,
                ),
                rowSpacer,
                DropdownButton(
                  items: _effectItems(context),
                  onChanged: (value) =>
                      Provider.of<CastingModel>(context, listen: false)
                          .updateInherentSpellEffect(
                              index, effect.withEffect(value)),
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
    Provider.of<CastingModel>(context, listen: false)
        .removeInherentModifier(index);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Effect $effect deleted'),
      ),
    );
  }
}
