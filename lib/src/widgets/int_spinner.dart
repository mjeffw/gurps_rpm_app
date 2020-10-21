import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'arrow_button.dart';
import 'text_converter.dart';

typedef IntUpdateCallback = void Function(int);
typedef StepFunction = int Function(int, int);

int step(int x, int y) => x + y;

class IntSpinner extends StatefulWidget {
  const IntSpinner({
    Key key,
    @required this.onChanged,
    this.initialValue = 0,
    this.valueNotifier,
    this.maxValue = 1000000,
    this.minValue = -1000000,
    this.bigStep = 10,
    this.smallStep = 1,
    this.decoration = const InputDecoration(),
    this.textFieldWidth,
    this.stepFunction = step,
    this.textConverter = const IdentityStringToIntConverter(),
    this.inputFormatters,
  })  : assert(stepFunction != null),
        super(key: key);

  final int initialValue;
  final ValueNotifier<int> valueNotifier;

  final StringToIntConverter textConverter;
  final InputDecoration decoration;
  final IntUpdateCallback onChanged;
  final StepFunction stepFunction;
  final int bigStep;
  final int smallStep;
  final int maxValue;
  final int minValue;
  final double textFieldWidth;
  final List<TextInputFormatter> inputFormatters;

  @override
  _IntSpinnerState createState() => _IntSpinnerState();
}

class _IntSpinnerState extends State<IntSpinner> {
  TextEditingController _controller;
  bool _validInput = true;

  int get _textAsInt => widget.textConverter.asInt(_controller.text);

  set _textAsInt(int value) {
    int newValue = (value < widget.minValue)
        ? widget.minValue
        : (value > widget.maxValue)
            ? widget.maxValue
            : value;

    if (_controller.text != widget.textConverter.asString(newValue))
      _controller.text = widget.textConverter.asString(newValue);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onChanged);
    widget.valueNotifier?.addListener(_updateValue);

    _controller.text = widget.textConverter.asString(widget.initialValue);
  }

  void _onChanged() {
    String text = _controller.text.trim();
    setState(() {
      var value = widget.textConverter.asInt(text);

      _validInput = (value.toString() == text);

      if (_validInput) {
        _textAsInt = value;
        widget.onChanged(_textAsInt);
      }
    });
  }

  void _updateValue() {
    if (_textAsInt != widget.valueNotifier.value)
      _textAsInt = widget.valueNotifier.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.valueNotifier?.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoubleLeftArrowButton(
          key: ValueKey('$keyString-LEFT2'),
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, -widget.bigStep)),
        ),
        LeftArrowButton(
          key: ValueKey('$keyString-LEFT'),
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, -widget.smallStep)),
        ),
        Expanded(
          child: SizedBox(
            width: widget.textFieldWidth,
            child: _buildTextFormField(),
          ),
        ),
        RightArrowButton(
          key: ValueKey('$keyString-RIGHT'),
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, widget.smallStep)),
        ),
        DoubleRightArrowButton(
          key: ValueKey('$keyString-RIGHT2'),
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, widget.bigStep)),
        ),
      ],
    );
  }

  String get keyString => (widget.key is ValueKey)
      ? (widget.key as ValueKey).value
      : widget.key.toString();

  TextFormField _buildTextFormField() {
    TextInputFormatter formatter = (widget.minValue < 0)
        ? FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))
        : FilteringTextInputFormatter.digitsOnly;

    return TextFormField(
      key: ValueKey('$keyString-TEXT'),
      textAlign: TextAlign.right,
      controller: _controller,
      keyboardType: _keyboardType(),
      inputFormatters: widget.inputFormatters ?? [formatter],
      decoration: widget.decoration.copyWith(
        border: const OutlineInputBorder(),
        errorText: _validInput ? null : 'Invalid input',
      ),
    );
  }

  TextInputType _keyboardType() => widget.minValue < 0
      ? TextInputType.numberWithOptions(signed: true)
      : TextInputType.number;
}
