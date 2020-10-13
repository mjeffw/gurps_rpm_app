import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'arrow_button.dart';
import 'text_converter.dart';

typedef IntUpdateCallback = void Function(int);
typedef StepFunction = int Function(int, int);

int step(int x, int y) => x + y;

List<TextInputFormatter> _formatters = [FilteringTextInputFormatter.digitsOnly];

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
    _controller = TextEditingController(
        text: widget.textConverter.asString(widget.initialValue));
    _controller.addListener(_onChanged);
    if (widget.valueNotifier != null)
      widget.valueNotifier.addListener(_updateValue);
  }

  void _onChanged() {
    widget.onChanged(_textAsInt);
  }

  void _updateValue() {
    if (_textAsInt != widget.valueNotifier.value)
      _textAsInt = widget.valueNotifier.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.valueNotifier != null)
      widget.valueNotifier.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoubleLeftArrowButton(
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, -widget.bigStep)),
        ),
        LeftArrowButton(
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
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, widget.smallStep)),
        ),
        DoubleRightArrowButton(
          onPressed: () => setState(() =>
              _textAsInt = widget.stepFunction(_textAsInt, widget.bigStep)),
        ),
      ],
    );
  }

  TextFormField _buildTextFormField() {
    return TextFormField(
      textAlign: TextAlign.right,
      controller: _controller,
      keyboardType: _keyboardType(),
      inputFormatters: widget.inputFormatters ?? _formatters,
      decoration: widget.decoration.copyWith(
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextInputType _keyboardType() {
    return widget.minValue < 0
        ? TextInputType.numberWithOptions(signed: true)
        : TextInputType.number;
  }
}
