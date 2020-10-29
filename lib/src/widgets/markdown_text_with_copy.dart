import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownTextWithCopy extends StatefulWidget {
  const MarkdownTextWithCopy({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  _MarkdownTextWithCopyState createState() => _MarkdownTextWithCopyState();
}

class _MarkdownTextWithCopyState extends State<MarkdownTextWithCopy> {
  bool _showCopyText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 1.0,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.text));
              Timer(Duration(seconds: 1), () {
                setState(() => _showCopyText = false);
              });

              setState(() {
                _showCopyText = true;
              });
            },
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Markdown(
                  shrinkWrap: true,
                  data: widget.text,
                  selectable: true,
                ),
                AnimatedDefaultTextStyle(
                  duration: _showCopyText
                      ? Duration(seconds: 0)
                      : Duration(seconds: 3),
                  style: _showCopyText
                      ? TextStyle(color: Colors.orange[800])
                      : TextStyle(color: Colors.transparent),
                  curve: Curves.easeIn,
                  child: Text('Copied to Clipboard'),
                ),
              ],
            ),
          ),
        ),
        Text('Tap to copy Markdown to clipboard'),
      ],
    );
  }
}
