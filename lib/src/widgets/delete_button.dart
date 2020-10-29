import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Tap to delete this item',
        icon: Icon(
          Icons.remove_circle_rounded,
          color: Colors.deepOrange,
        ),
        onPressed: onPressed);
  }
}
