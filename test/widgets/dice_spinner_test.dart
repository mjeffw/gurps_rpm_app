import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_app/src/widgets/dice_spinner.dart';

void main() {
  group('DiceSpinner', () {
    testWidgets('should use Key', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ));

      expect(find.byKey(ValueKey('DiceSpinner')), findsOneWidget);
    });

    testWidgets('should have default (initial) value',
        (WidgetTester tester) async {
      DieRoll d;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                onChanged: (value) => d = value,
              ),
            ],
          ),
        ),
      ));

      expect(d, equals(DieRoll(dice: 1, adds: 0)));
    });

    testWidgets('should allow nondefault initial value',
        (WidgetTester tester) async {
      DieRoll d = DieRoll(dice: 3, adds: -1);

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                initialValue: d,
                onChanged: (value) => d = value,
              ),
            ],
          ),
        ),
      ));

      expect(d, equals(DieRoll(dice: 3, adds: -1)));
    });

    testWidgets('should handle small steps', (WidgetTester tester) async {
      DieRoll d = DieRoll(dice: 3, adds: -1);

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                initialValue: d,
                onChanged: (value) => d = value,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-RIGHT')));
      expect(d, equals(DieRoll(dice: 3)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT')));
      expect(d, equals(DieRoll(dice: 3, adds: -1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT')));
      expect(d, equals(DieRoll(dice: 2, adds: 2)));
    });

    testWidgets('should handle big steps', (WidgetTester tester) async {
      DieRoll d = DieRoll(dice: 3, adds: -1);

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                initialValue: d,
                onChanged: (value) => d = value,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-RIGHT2')));
      expect(d, equals(DieRoll(dice: 4, adds: -1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT2')));
      expect(d, equals(DieRoll(dice: 3, adds: -1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT2')));
      expect(d, equals(DieRoll(dice: 2, adds: -1)));
    });

    testWidgets('should allow custom big step values',
        (WidgetTester tester) async {
      DieRoll d = DieRoll(dice: 3, adds: -1);

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                initialValue: d,
                onChanged: (value) => d = value,
                bigStep: 8,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-RIGHT2')));
      expect(d, equals(DieRoll(dice: 5, adds: -1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT2')));
      expect(d, equals(DieRoll(dice: 3, adds: -1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT2')));
      // a min value of 0 equates to 1d -- the -1 add is dropped
      expect(d, equals(DieRoll(dice: 1)));
    });

    testWidgets('should allow custom small step values',
        (WidgetTester tester) async {
      DieRoll d = DieRoll(dice: 3, adds: -1);

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              DiceSpinner(
                key: ValueKey('DiceSpinner'),
                initialValue: d,
                onChanged: (value) => d = value,
                smallStep: 2,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-RIGHT')));
      expect(d, equals(DieRoll(dice: 3, adds: 1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT')));
      expect(d, equals(DieRoll(dice: 3, adds: -1)));

      await tester.tap(find.byKey(ValueKey('DiceSpinner-LEFT')));
      expect(d, equals(DieRoll(dice: 2, adds: 1)));
    });
  });
}
