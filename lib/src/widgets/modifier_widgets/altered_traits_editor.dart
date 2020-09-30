import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

import '../../models/casting_model.dart';
import '../utils.dart';
import 'arrow_button.dart';
import 'modifier_row.dart';

class AlteredTraitsRow extends ModifierRow {
  AlteredTraitsRow(RitualModifier modifier, int index)
      : assert(modifier is AlteredTraits),
        super(modifier: modifier, index: index);

  AlteredTraits get alteredTrait => super.modifier;

  @override
  List<Widget> buildModifierRowWidgets(BuildContext context) {
    return [
      Text('${alteredTrait.trait.nameLevel} '),
      if (isMediumScreen(context))
        LeftArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, modifier.incrementEffect(-1)),
        ),
      Text('(${alteredTrait.characterPoints})'),
      if (isMediumScreen(context))
        RightArrowButton(
          onPressed: () => Provider.of<CastingModel>(context, listen: false)
              .updateInherentModifier(index, modifier.incrementEffect(1)),
        ),
    ];
  }

  @override
  Widget dialogBuilder(BuildContext context) =>
      _Editor(modifier: modifier, index: index);
}

/// Widget that contains the edit dialog for AlteredTraits.
class _Editor extends StatefulWidget {
  _Editor({@required this.modifier, @required this.index});

  final AlteredTraits modifier;
  final int index;

  @override
  _EditorState createState() => _EditorState(modifier);
}

class _EditorState extends State<_Editor> {
  _EditorState(this.modifier);

  TextEditingController _traitNameController;
  TextEditingController _baseCostController;
  TextEditingController _costLevelController;
  TextEditingController _levelsController;
  bool _hasLevels;
  AlteredTraits modifier;

  Trait get trait => modifier.trait;

  @override
  void initState() {
    super.initState();
    _hasLevels = trait.hasLevels;
    _traitNameController = TextEditingController(text: trait.name);
    _baseCostController =
        TextEditingController(text: trait.baseCost.toString());
    _costLevelController =
        TextEditingController(text: trait.costPerLevel.toString());
    _levelsController =
        TextEditingController(text: trait.costPerLevel.toString());
  }

  @override
  void dispose() {
    _traitNameController.dispose();
    _baseCostController.dispose();
    _costLevelController.dispose();
    _levelsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            var copy = modifier.copyWith(
                trait: Trait(
              name: _traitNameController.text,
              hasLevels: _hasLevels,
              baseCost: int.parse(_baseCostController.text),
              costPerLevel: int.parse(_costLevelController.text),
              levels: int.parse(_levelsController.text),
            ));

            Navigator.of(context).pop<RitualModifier>(copy);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Altered Trait Editor'),
          Divider(),
          columnSpacer,
          TextField(
            controller: _traitNameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Effect',
              border: const OutlineInputBorder(),
            ),
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
                    modifier = modifier.copyWith(
                        trait: Trait(
                            name: trait.name,
                            baseCost: trait.baseCost - 10,
                            costPerLevel: trait.costPerLevel,
                            levels: trait.levels,
                            hasLevels: trait.hasLevels));
                    _baseCostController.text = trait.baseCost.toString();
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
                    modifier = modifier.copyWith(
                        trait: Trait(
                            name: trait.name,
                            baseCost: trait.baseCost - 1,
                            costPerLevel: trait.costPerLevel,
                            levels: trait.levels,
                            hasLevels: trait.hasLevels));
                    _baseCostController.text = trait.baseCost.toString();
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  width: 80.0,
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: _baseCostController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Base Cost',
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
                    modifier = modifier.copyWith(
                        trait: Trait(
                            name: trait.name,
                            baseCost: trait.baseCost + 1,
                            costPerLevel: trait.costPerLevel,
                            levels: trait.levels,
                            hasLevels: trait.hasLevels));
                    _baseCostController.text = trait.baseCost.toString();
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
                    modifier = modifier.copyWith(
                        trait: Trait(
                            name: trait.name,
                            baseCost: trait.baseCost + 10,
                            costPerLevel: trait.costPerLevel,
                            levels: trait.levels,
                            hasLevels: trait.hasLevels));
                    _baseCostController.text = trait.baseCost.toString();
                  });
                },
              ),
            ],
          ),
          SwitchListTile(
            value: trait.hasLevels,
            onChanged: (state) {
              print("click! $state");
              setState(() {
                modifier = modifier.copyWith(
                  trait: Trait(
                    baseCost: modifier.trait.baseCost,
                    costPerLevel: modifier.trait.costPerLevel,
                    hasLevels: state,
                    levels: modifier.trait.levels,
                    name: modifier.trait.name,
                  ),
                );
              });
            },
            title: Text('Has Levels'),
          ),
          if (trait.hasLevels)
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.fast_rewind,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      modifier = modifier.copyWith(
                        trait: Trait(
                            name: trait.name,
                            baseCost: trait.baseCost,
                            costPerLevel: trait.costPerLevel,
                            levels:
                                (trait.levels - 5 < 1) ? 0 : trait.levels - 5,
                            hasLevels: trait.hasLevels),
                      );
                      _levelsController.text = trait.levels.toString();
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
                      modifier = modifier.copyWith(
                        trait: Trait(
                          name: trait.name,
                          baseCost: trait.baseCost,
                          costPerLevel: trait.costPerLevel,
                          levels: (trait.levels == 0) ? 0 : trait.levels - 1,
                          hasLevels: trait.hasLevels,
                        ),
                      );
                      _levelsController.text = trait.levels.toString();
                    });
                  },
                ),
                Expanded(
                  child: SizedBox(
                    width: 80.0,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: _levelsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Base Cost',
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
                      modifier = modifier.copyWith(
                        trait: Trait(
                          baseCost: trait.baseCost,
                          costPerLevel: trait.costPerLevel,
                          levels: trait.levels + 1,
                          hasLevels: trait.hasLevels,
                        ),
                      );
                      _levelsController.text = trait.levels.toString();
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
                      modifier = modifier.copyWith(
                        trait: Trait(
                          baseCost: trait.baseCost,
                          costPerLevel: trait.costPerLevel,
                          levels: trait.levels + 5,
                          hasLevels: trait.hasLevels,
                        ),
                      );
                      _levelsController.text = trait.levels.toString();
                    });
                  },
                ),
              ],
            ),
          if (trait.hasLevels)
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.fast_rewind,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      modifier = modifier.copyWith(
                          trait: Trait(
                              name: trait.name,
                              baseCost: trait.baseCost,
                              costPerLevel: trait.costPerLevel - 5,
                              levels: trait.levels,
                              hasLevels: trait.hasLevels));
                      _costLevelController.text = trait.costPerLevel.toString();
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
                      modifier = modifier.copyWith(
                          trait: Trait(
                              name: trait.name,
                              baseCost: trait.baseCost,
                              costPerLevel: trait.costPerLevel - 5,
                              levels: trait.levels,
                              hasLevels: trait.hasLevels));
                      _costLevelController.text = trait.costPerLevel.toString();
                    });
                  },
                ),
                Expanded(
                  child: SizedBox(
                    width: 80.0,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: _costLevelController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Base Cost',
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
                      modifier = modifier.copyWith(
                          trait: Trait(
                              name: trait.name,
                              baseCost: trait.baseCost,
                              costPerLevel: trait.costPerLevel + 1,
                              levels: trait.levels,
                              hasLevels: trait.hasLevels));
                      _costLevelController.text = trait.baseCost.toString();
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
                      modifier = modifier.copyWith(
                          trait: Trait(
                              name: trait.name,
                              baseCost: trait.baseCost,
                              costPerLevel: trait.costPerLevel + 5,
                              levels: trait.levels,
                              hasLevels: trait.hasLevels));
                      _costLevelController.text = trait.baseCost.toString();
                    });
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
