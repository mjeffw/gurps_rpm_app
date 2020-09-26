import 'package:flutter/material.dart';
import 'package:gurps_rpm_app/src/models/ritual_model.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

const spacer = const Padding(
  padding: EdgeInsets.only(right: 8.0),
);

const wideSpacer = const Padding(
  padding: EdgeInsets.only(right: 16.0),
);

class AfflictionWidget extends StatelessWidget {
  const AfflictionWidget(this.modifier, this.index)
      : assert(modifier is Affliction);

  final Affliction modifier;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text('${modifier.name}'),
          wideSpacer,
          Text('Effect: ${modifier.effect}'),
          spacer,
          IconButton(
            icon: Icon(
              Icons.arrow_left_rounded,
              color: Colors.blue,
            ),
            onPressed: () => Provider.of<CastingModel>(context)
                .incrementInherentModifier(index, -1),
          ),
          Text('${modifier.percent}%'),
          IconButton(
            icon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.blue,
            ),
            onPressed: () => Provider.of<CastingModel>(context)
                .incrementInherentModifier(index, 1),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            onPressed: () => print('edit pressed'),
          ),
        ],
      ),
    );
  }
}
