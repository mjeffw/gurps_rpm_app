import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef StringConsumer = void Function(String);

class ProviderSelectorTextField<P extends ChangeNotifier>
    extends StatefulWidget {
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

  final String Function(BuildContext, ChangeNotifier) valueProvider;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;
  final bool autofocus;
  final TextStyle style;
  final InputDecoration decoration;
  final int maxLines;

  @override
  _ProviderSelectorTextFieldState<P> createState() =>
      _ProviderSelectorTextFieldState<P>();
}

class _ProviderSelectorTextFieldState<P extends ChangeNotifier>
    extends State<ProviderSelectorTextField> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onSubmitted(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Selector<P, String>(
      selector: (_, model) => widget.valueProvider(context, model),
      builder: (_, value, __) {
        if (_controller.text != value) {
          _controller.text = value ?? '';
        }
        return TextField(
          key: Key('$_keyText-TEXT'),
          controller: _controller,
          onSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          autofocus: widget.autofocus,
          style: widget.style,
          decoration: widget.decoration,
          focusNode: _focusNode,
          maxLines: widget.maxLines,
        );
      },
    );
  }

  String get _keyText => (widget.key is ValueKey)
      ? (widget.key as ValueKey).value
      : widget.key.toString();
}
