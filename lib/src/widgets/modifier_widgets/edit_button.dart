import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.blue,
        ),
        onPressed: this.onPressed);
  }
}
