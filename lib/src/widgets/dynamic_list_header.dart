import 'package:flutter/material.dart';

class DynamicListHeader extends StatelessWidget {
  const DynamicListHeader(
      {Key key,
      this.title,
      this.onAddPressed,
      this.onDelPressed,
      this.deleteActive})
      : super(key: key);

  final String title;
  final VoidCallback onAddPressed;
  final VoidCallback onDelPressed;
  final bool deleteActive;

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
          if (deleteActive != null)
            IconButton(
              icon: Icon(
                Icons.delete_sweep_rounded,
                color: deleteActive ? Colors.grey : Colors.red,
              ),
              onPressed: onDelPressed,
            ),
          IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: Colors.blue,
            ),
            onPressed: onAddPressed,
          ),
        ],
      ),
    );
  }
}
