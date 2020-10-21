import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.remove_circle_rounded,
          color: Colors.deepOrange,
        ),
        onPressed: onPressed);
  }
}
