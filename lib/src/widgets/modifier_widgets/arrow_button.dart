import 'package:flutter/material.dart';

class RightArrowButton extends StatelessWidget {
  const RightArrowButton({VoidCallback onPressed})
      : this._onPressed = onPressed;

  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: _onPressed,
      icon: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    return const _Icon();
  }
}

class LeftArrowButton extends RightArrowButton {
  const LeftArrowButton({VoidCallback onPressed}) : super(onPressed: onPressed);

  @override
  Widget _buildIcon() {
    return const RotatedBox(
      quarterTurns: 2,
      child: _Icon(),
    );
  }
}

class _Icon extends Icon {
  const _Icon() : super(Icons.play_arrow, color: Colors.blue);
}
