import 'package:flutter/material.dart';

class DynamicListHeader extends StatelessWidget {
  const DynamicListHeader({Key key, this.title, this.onPressed}) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
          ),
          Expanded(
            child: Divider(
              indent: 8.0,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: Colors.green,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
