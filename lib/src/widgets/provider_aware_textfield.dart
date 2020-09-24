import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef StringGetter = String Function();
typedef StringConsumer = void Function(String);

class ProviderSelectorTextField<P> extends StatefulWidget {
  const ProviderSelectorTextField({
    Key key,
    @required this.valueProvider,
    this.onSubmitted,
    this.onEditingComplete,
    this.autofocus = false,
    this.style,
    this.decoration = const InputDecoration(),
    this.maxLines = 1,
  }) : super(key: key);

  final StringGetter valueProvider;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;
  final bool autofocus;
  final TextStyle style;
  final InputDecoration decoration;
  final int maxLines;

  @override
  _ProviderSelectorTextFieldState createState() =>
      _ProviderSelectorTextFieldState<P>(
        valueProvider: valueProvider,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        autofocus: autofocus,
        style: style,
        decoration: decoration,
        maxLines: maxLines,
      );
}

class _ProviderSelectorTextFieldState<P>
    extends State<ProviderSelectorTextField> {
  _ProviderSelectorTextFieldState({
    this.valueProvider,
    this.onSubmitted,
    this.onEditingComplete,
    this.autofocus = false,
    this.style,
    this.decoration = const InputDecoration(),
    this.maxLines = 1,
  });

  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final StringGetter valueProvider;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;
  final bool autofocus;
  final TextStyle style;
  final InputDecoration decoration;
  final int maxLines;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print('has focus? ${_focusNode.hasFocus}');
      if (!_focusNode.hasFocus) {
        onSubmitted(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Selector<P, String>(
      selector: (_, model) => valueProvider(),
      builder: (_, value, __) {
        if (_controller.text != value) {
          _controller.text = value ?? '';
        }
        return TextField(
          controller: _controller,
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          autofocus: autofocus,
          style: style,
          decoration: decoration,
          focusNode: _focusNode,
          maxLines: maxLines,
        );
      },
    );
  }
}
