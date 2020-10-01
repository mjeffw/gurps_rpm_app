import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef IntUpdateCallback = void Function(int);
typedef StepFunction = int Function(int, int);

int step(int x, int y) => x + y;

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
  })  : assert(stepFunction != null),
        super(key: key);

  final int initialValue;
  final InputDecoration decoration;
  final IntUpdateCallback onChanged;
  final StepFunction stepFunction;
  final int bigStep;
  final int smallStep;
  final int maxValue;
  final int minValue;
  final double textFieldWidth;

  @override
  _IntSpinnerState createState() => _IntSpinnerState();
}

class _IntSpinnerState extends State<IntSpinner> {
  TextEditingController _controller;

  int get _textAsInt => int.parse(_controller.text);

  set _textAsInt(int value) {
    int newValue = (value < widget.minValue)
        ? widget.minValue
        : (value > widget.maxValue)
            ? widget.maxValue
            : value;
    _controller.text = newValue.toString();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
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
            child: TextFormField(
              textAlign: TextAlign.right,
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
