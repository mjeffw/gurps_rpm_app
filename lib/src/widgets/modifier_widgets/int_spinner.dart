import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gurps_rpm_app/src/widgets/text_converter.dart';

typedef IntUpdateCallback = void Function(int);
typedef StepFunction = int Function(int, int);

int step(int x, int y) => x + y;

List<TextInputFormatter> _formatters = [FilteringTextInputFormatter.digitsOnly];

class IntSpinner extends StatefulWidget {
  const IntSpinner({
    Key key,
    @required this.onChanged,
    this.initialValue = 0,
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

  bool _invalidText = false;

  int get _textAsInt {
    try {
      var result = widget.textConverter.asInt(_controller.text);
      _invalidText = false;
      return result;
    } on FormatException {
      _invalidText = true;
      return 
    }
  }

  set _textAsInt(int value) {
    int newValue = (value < widget.minValue)
        ? widget.minValue
        : (value > widget.maxValue)
            ? widget.maxValue
            : value;
    _controller.text = widget.textConverter.asString(newValue);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.textConverter.asString(widget.initialValue));
    _controller.addListener(() => widget.onChanged(_textAsInt));
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
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.fast_rewind,
            color: Colors.blue,
          ),
          onPressed: () => setState(() {
            _textAsInt = widget.stepFunction(_textAsInt, -widget.bigStep);
          }),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.play_arrow,
              color: Colors.blue,
            ),
          ),
          onPressed: () => setState(() {
            _textAsInt = widget.stepFunction(_textAsInt, -widget.smallStep);
          }),
        ),
        Expanded(
          child: SizedBox(
            width: widget.textFieldWidth,
            child: TextField(
              textAlign: TextAlign.right,
              controller: _controller,
              keyboardType: TextInputType.number,
              //inputFormatters: widget.inputFormatters ?? _formatters,
              decoration: widget.decoration.copyWith(
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.play_arrow,
            color: Colors.blue,
          ),
          onPressed: () => setState(() {
            _textAsInt = widget.stepFunction(_textAsInt, widget.smallStep);
          }),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.fast_forward,
            color: Colors.blue,
          ),
          onPressed: () => setState(() {
            _textAsInt = widget.stepFunction(_textAsInt, widget.bigStep);
          }),
        ),
      ],
    );
  }
}
