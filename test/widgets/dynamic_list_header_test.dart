import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/widgets/dynamic_list_header.dart';

void main() {
  group('DynamicListHeader', () {
    testWidgets('title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DynamicListHeader(
                title: 'Foo',
              )
            ],
          ),
        ),
      ));

      expect(find.text('Foo'), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep_rounded), findsNothing);
    });

    testWidgets('title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: SizedBox(
            height: 800.0,
            width: 600.0,
            child: Column(
              children: [
                DynamicListHeader(
                  deleteActive: true,
                )
              ],
            ),
          ),
        ),
      ));

      expect(find.byIcon(Icons.delete_sweep_rounded), findsOneWidget);
    });
  });
}
