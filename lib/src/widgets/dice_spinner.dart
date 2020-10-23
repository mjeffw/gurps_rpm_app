import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gurps_dice/gurps_dice.dart';

import 'arrow_button.dart';

/// Defines a callback executed with the current valid DieRoll value each time
/// it is updated by this widget.
typedef DieRollUpdateCallback = void Function(DieRoll);

/// A regular expression that matches GURPS dice syntax.
RegExp regex = RegExp(r'^(?<dice>\d+)d(?<adds>[+|-]\d+)?$');

class DiceSpinner extends StatefulWidget {
  const DiceSpinner({
    Key key,
    @required this.onChanged,
    this.initialValue = const DieRoll(dice: 1),
    this.bigStep = 4,
    this.smallStep = 1,
    this.decoration = const InputDecoration(),
    this.textFieldWidth,
  }) : super(key: key);

  final DieRoll initialValue;

  final InputDecoration decoration;
  final DieRollUpdateCallback onChanged;
  final int bigStep;
  final int smallStep;
  final double textFieldWidth;

  @override
  _DiceSpinnerState createState() => _DiceSpinnerState();
}

class _DiceSpinnerState extends State<DiceSpinner> {
  TextEditingController _controller;
  DieRoll _currentValue;
  bool _validInput = true;

  /// convert the text into a die roll.
  DieRoll get _textAsDice => DieRoll.fromString(_controller.text);

  /// convert the DieRoll into text, enforcing the minimum value of 1d.
  set _textAsDice(DieRoll value) {
    int denormalizedAdds = DieRoll.denormalize(value);
    DieRoll newValue = (denormalizedAdds <= 0) ? DieRoll(dice: 1) : value;
    _controller.text = newValue.toString();
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _controller.addListener(_onChanged);
    _controller.text = widget.initialValue.toString();
  }

  void _onChanged() {
    String text = _controller.text.trim();
    setState(() {
      var hasMatch = regex.hasMatch(text);
      _validInput = hasMatch;

      if (hasMatch) {
        _currentValue = DieRoll.fromString(text);
        widget.onChanged(_currentValue);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoubleLeftArrowButton(
          key: ValueKey('$_keyValue-LEFT2'),
          onPressed: () => setState(() {
            _textAsDice = _textAsDice - widget.bigStep;
          }),
        ),
        LeftArrowButton(
          key: ValueKey('$_keyValue-LEFT'),
          onPressed: () => setState(() {
            _textAsDice = _textAsDice - widget.smallStep;
          }),
        ),
        Expanded(
          child: SizedBox(
            width: widget.textFieldWidth,
            child: _buildTextField(),
          ),
        ),
        RightArrowButton(
          key: ValueKey('$_keyValue-RIGHT'),
          onPressed: () => setState(() {
            _textAsDice = _textAsDice + widget.smallStep;
          }),
        ),
        DoubleRightArrowButton(
          key: ValueKey('$_keyValue-RIGHT2'),
          onPressed: () => setState(() {
            _textAsDice = _textAsDice + widget.bigStep;
          }),
        ),
      ],
    );
  }

  String get _keyValue => (widget.key is ValueKey)
      ? (widget.key as ValueKey).value
      : widget.key.toString();

  TextField _buildTextField() {
    return TextField(
      key: ValueKey('$_keyValue-TEXT'),
      textAlign: TextAlign.right,
      controller: _controller,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9d+-]'))],
      decoration: widget.decoration.copyWith(
          labelText: 'Dice',
          border: const OutlineInputBorder(),
          errorText: _validInput ? null : 'No dice!'),
    );
  }
}
