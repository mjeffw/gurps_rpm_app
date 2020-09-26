import 'package:flutter/material.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../models/ritual_model.dart';

const spacer = const Padding(
  padding: EdgeInsets.only(right: 4.0),
);

class SpellEffectEditor extends StatelessWidget {
  const SpellEffectEditor({
    Key key,
    @required this.effect,
    this.index,
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
    return IntrinsicHeight(
      child: Container(
        color: (index.isOdd) ? oddBackground : null,
        padding: EdgeInsets.only(right: 24.0),
        child: Row(
          children: [
            DropdownButton(
              items: _levelItems(context),
              onChanged: (value) =>
                  Provider.of<CastingModel>(context, listen: false)
                      .updateInherentSpellEffectLevel(index, value),
              value: effect.level,
            ),
            spacer,
            DropdownButton(
              items: _effectItems(context),
              onChanged: (value) =>
                  Provider.of<CastingModel>(context, listen: false)
                      .updateInherentSpellEffectEffect(index, value),
              value: effect.effect,
            ),
            spacer,
            Text('${effect.path}'),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.remove_circle_rounded,
                color: Colors.red,
              ),
              onPressed: () => Provider.of<CastingModel>(context, listen: false)
                  .removeInherentSpellEffect(index),
            ),
          ],
        ),
      ),
    );
  }
}
