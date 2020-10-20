import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/widgets/dynamic_list_header.dart';

void main() {
  group('DynamicListHeader', () {
    testWidgets('title should be set', (WidgetTester tester) async {
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

    group('delete button', () {
      testWidgets('should not be visible', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Card(
            child: SizedBox(
              height: 800.0,
              width: 600.0,
              child: Column(
                children: [
                  DynamicListHeader(
                    title: 'Foo',
                  )
                ],
              ),
            ),
          ),
        ));

        expect(find.byKey(ValueKey<String>('Foo-DEL')), findsNothing);
      });

      testWidgets('should be visible and grey', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Card(
            child: SizedBox(
              height: 800.0,
              width: 600.0,
              child: Column(
                children: [
                  DynamicListHeader(
                    deleteActive: true,
                    title: 'Foo',
                  )
                ],
              ),
            ),
          ),
        ));

        Key delKey = ValueKey<String>('Foo-DEL');
        expect(find.byKey(delKey), findsOneWidget);

        IconButton delButton = tester.widget(find.byKey(delKey));
        expect((delButton.icon as Icon).color, equals(Colors.grey));
        expect(delButton.tooltip, equals('Display or hide Delete buttons'));
      });

      testWidgets('should be visible and blue', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Card(
            child: SizedBox(
              height: 800.0,
              width: 600.0,
              child: Column(
                children: [
                  DynamicListHeader(
                    deleteActive: false,
                    title: 'Foo',
                  )
                ],
              ),
            ),
          ),
        ));

        Key delKey = ValueKey<String>('Foo-DEL');
        expect(find.byKey(delKey), findsOneWidget);

        IconButton delButton = tester.widget(find.byKey(delKey));
        expect((delButton.icon as Icon).color, equals(Colors.blue));
        expect(delButton.tooltip, equals('Display or hide Delete buttons'));
      });

      testWidgets('should be enabled', (WidgetTester tester) async {
        bool pressed = false;

        await tester.pumpWidget(MaterialApp(
          home: Card(
            child: SizedBox(
              height: 800.0,
              width: 600.0,
              child: Column(
                children: [
                  DynamicListHeader(
                    deleteActive: false,
                    title: 'Foo',
                    onDelPressed: () => pressed = true,
                  )
                ],
              ),
            ),
          ),
        ));

        Key delKey = ValueKey<String>('Foo-DEL');
        expect(find.byKey(delKey), findsOneWidget);

        await tester.tap(find.byKey(delKey));

        expect(pressed, isTrue);
      });
    });

    group('add button', () {
      testWidgets('should be visible', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Card(
            child: SizedBox(
              height: 800.0,
              width: 600.0,
              child: Column(
                children: [
                  DynamicListHeader(
                    title: 'Foo',
                  )
                ],
              ),
            ),
          ),
        ));

        var finder = find.byKey(ValueKey('Foo-ADD'));
        expect(finder, findsOneWidget);
      });

      testWidgets('should be enabled', (WidgetTester tester) async {
        bool pressed = false;
        await tester.pumpWidget(MaterialApp(
          home: Card(
            child: SizedBox(
              height: 800.0,
              width: 600.0,
              child: Column(
                children: [
                  DynamicListHeader(
                    title: 'Foo',
                    onAddPressed: () => pressed = true,
                  )
                ],
              ),
            ),
          ),
        ));

        var finder = find.byKey(ValueKey('Foo-ADD'));
        await tester.tap(finder);

        expect(pressed, isTrue);
      });
    });
  });
}
