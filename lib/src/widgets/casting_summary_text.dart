import 'package:flutter/material.dart';
import '../utils/selectable_text_exporter.dart';

class CastingSummaryText extends StatefulWidget {
  final SelectableTextExporter exporter;

  const CastingSummaryText({
    Key key,
    @required this.exporter,
  }) : super(key: key);

  @override
  _CastingSummaryTextState createState() => _CastingSummaryTextState();
}

class _CastingSummaryTextState extends State<CastingSummaryText> {
  SelectableTextExporter get exporter => widget.exporter;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    const italic = TextStyle(fontStyle: FontStyle.italic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 1.0,
            ),
          ),
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: '${exporter.title}\n\n',
                    style:
                        theme.headline6.copyWith(fontStyle: FontStyle.italic)),
                TextSpan(text: '   Spell Effects: ', style: italic),
                TextSpan(text: '${exporter.inherentEffects}.\n'),
                TextSpan(text: '   Inherent Modifiers: ', style: italic),
                TextSpan(text: '${exporter.inherentModifiers}.\n'),
                TextSpan(text: '   Greater Effects: ', style: italic),
                TextSpan(
                    text: '${exporter.greaterEffects} '
                        '(×${exporter.effectsMultiplier}).\n\n'),
                TextSpan(text: '${exporter.description}\n\n'),
                TextSpan(text: '   Typical Casting: ', style: italic),
                TextSpan(text: '${exporter.allComponents}. '),
                TextSpan(
                    text:
                        '${exporter.energy} energy (${exporter.baseEnergyCost}'
                        '×${exporter.totalEffectsMultiplier}).',
                    style: italic)
              ],
            ),
          ),
        )
      ],
    );
  }
}
