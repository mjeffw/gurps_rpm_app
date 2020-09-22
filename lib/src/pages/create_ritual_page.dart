import 'package:flutter/material.dart';

class CreateRitualPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                    labelText: 'Ritual name',
                    border: const OutlineInputBorder()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Spell Effects:',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                        ),
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Inherent Modifiers:',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                        ),
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text(
                      'Greater Effects: ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '0 (×1).',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 0.0),
                  title: Text(
                    'Description',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  initiallyExpanded: false,
                  children: [
                    TextField(
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Typical Casting:',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Additional Effects:',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                        ),
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Additional Modifiers:',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                        ),
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //Center(child: Text('Create Ritual page'));
  }
}
