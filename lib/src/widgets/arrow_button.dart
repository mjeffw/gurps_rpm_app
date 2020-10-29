import 'package:flutter/material.dart';

class RightArrowButton extends StatelessWidget {
  const RightArrowButton({Key key, VoidCallback onPressed})
      : this._onPressed = onPressed,
        super(key: key);

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

  Widget _buildIcon(IconData icon) => Icon(icon, color: Colors.cyan);
}

class DoubleRightArrowButton extends RightArrowButton {
  const DoubleRightArrowButton({Key key, VoidCallback onPressed})
      : super(key: key, onPressed: onPressed);

  @override
  IconData _iconData() => Icons.fast_forward;
}

class LeftArrowButton extends RightArrowButton {
  const LeftArrowButton({Key key, VoidCallback onPressed})
      : super(key: key, onPressed: onPressed);

  @override
  Widget _buildIcon(IconData icon) {
    return RotatedBox(
      quarterTurns: 2,
      child: Icon(icon, color: Colors.cyan),
    );
  }
}

class DoubleLeftArrowButton extends LeftArrowButton {
  const DoubleLeftArrowButton({Key key, VoidCallback onPressed})
      : super(key: key, onPressed: onPressed);

  @override
  IconData _iconData() => Icons.fast_forward;
}
