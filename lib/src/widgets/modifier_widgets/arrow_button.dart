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
      icon: _buildIcon(_iconData()),
    );
  }

  /// Overrride to set a different icon.
  IconData _iconData() => Icons.play_arrow;

  Widget _buildIcon(IconData icon) => Icon(icon, color: Colors.blue);
}

class DoubleRightArrowButton extends RightArrowButton {
  const DoubleRightArrowButton({VoidCallback onPressed})
      : super(onPressed: onPressed);

  @override
  IconData _iconData() => Icons.fast_forward;
}

class LeftArrowButton extends RightArrowButton {
  const LeftArrowButton({VoidCallback onPressed}) : super(onPressed: onPressed);

  @override
  Widget _buildIcon(IconData icon) {
    return RotatedBox(
      quarterTurns: 2,
      child: Icon(icon, color: Colors.blue),
    );
  }
}

class DoubleLeftArrowButton extends LeftArrowButton {
  const DoubleLeftArrowButton({VoidCallback onPressed})
      : super(onPressed: onPressed);

  @override
  IconData _iconData() => Icons.fast_forward;
}
