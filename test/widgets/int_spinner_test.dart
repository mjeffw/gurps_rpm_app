import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/widgets/int_spinner.dart';
import 'package:gurps_rpm_app/src/utils/text_converter.dart';

void main() {
  group('IntSpinner', () {
    testWidgets('should use Key', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ));

      expect(find.byKey(ValueKey('IntSpinner')), findsOneWidget);
    });

    testWidgets('should have initial value of zero',
        (WidgetTester tester) async {
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));
    });

    testWidgets('should have initial value of zero',
        (WidgetTester tester) async {
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));
    });

    testWidgets('should allow initial value to be set',
        (WidgetTester tester) async {
      int x = 10;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(10));
    });

    testWidgets('should allow value to be (small) incremented',
        (WidgetTester tester) async {
      int x = 10;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));

      expect(x, equals(11));
    });

    testWidgets('should allow value to be (big) incremented',
        (WidgetTester tester) async {
      int x = 10;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));

      expect(x, equals(20));
    });

    testWidgets('should allow value to be (small) decremented',
        (WidgetTester tester) async {
      int x = 10;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));

      expect(x, equals(9));
    });

    testWidgets('should allow value to be (big) decremented',
        (WidgetTester tester) async {
      int x = 10;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));

      expect(x, equals(0));
    });

    testWidgets('should reflect value in text field',
        (WidgetTester tester) async {
      int x = 10;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      var finder = find.byKey(ValueKey('IntSpinner-TEXT'));
      TextField txt = tester.widget(finder);
      expect(txt.controller.text, equals('10'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(txt.controller.text, equals('0'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(txt.controller.text, equals('1'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(txt.controller.text, equals('11'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(txt.controller.text, equals('10'));
    });

    testWidgets('should honor min value', (WidgetTester tester) async {
      int x = -1000000;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(-1000000));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(-1000000));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(-999990));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(-999989));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(-999991));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(-1000000));
    });

    testWidgets('should allow min value to be set',
        (WidgetTester tester) async {
      int x = -1000000;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
                minValue: 0,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(10));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(11));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(9));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(0));
    });

    // ====

    testWidgets('should honor max value', (WidgetTester tester) async {
      int x = 1000000;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
              ),
            ],
          ),
        ),
      ));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(999990));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(999989));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(999999));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(1000000));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(1000000));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(1000000));
    });

    testWidgets('should allow max value to be set',
        (WidgetTester tester) async {
      int x = 1000000;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                initialValue: x,
                maxValue: 100,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(100));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(90));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(89));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(99));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(100));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(100));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(100));
    });

    testWidgets('should allow small step to be set',
        (WidgetTester tester) async {
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                maxValue: 100,
                smallStep: 2,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(-10));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(-12));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(-2));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(2));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(12));
    });

    testWidgets('should allow big step to be set', (WidgetTester tester) async {
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                maxValue: 100,
                smallStep: 2,
                bigStep: 20,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(-20));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(-22));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(-2));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(2));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(22));
    });

    testWidgets('should allow step function to be set',
        (WidgetTester tester) async {
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                stepFunction: (value, increment) {
                  int exp = _calculateExponent(value);
                  int sign = (exp + increment).sign;
                  return sign * pow(2, (exp + increment).abs()).toInt();
                },
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(x, equals(-1024));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(x, equals(-2048));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(-2));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(0));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(x, equals(2));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(x, equals(2048));
    });

    testWidgets('should allow custom text conversions',
        (WidgetTester tester) async {
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                textConverter: DigitsToText(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                ],
              ),
            ],
          ),
        ),
      ));

      var finder = find.byKey(ValueKey('IntSpinner-TEXT'));
      TextField txt = tester.widget(finder);
      expect(txt.controller.text, equals('Zero'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT2')));
      expect(txt.controller.text, equals('Negative One Zero'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-LEFT')));
      expect(txt.controller.text, equals('Negative One One'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(txt.controller.text, equals('Negative One'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(txt.controller.text, equals('Zero'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT')));
      expect(txt.controller.text, equals('One'));

      await tester.tap(find.byKey(ValueKey('IntSpinner-RIGHT2')));
      expect(txt.controller.text, equals('One One'));

      await tester.enterText(
          find.byKey(ValueKey('IntSpinner-TEXT')), 'Negative One Two Three');
      expect(x, equals(-123));
    });

    testWidgets('should allow value changes from external code',
        (WidgetTester tester) async {
      ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);
      int x;

      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
                valueNotifier: changeNotifier,
              ),
            ],
          ),
        ),
      ));

      expect(x, equals(0));

      changeNotifier.value = 77;
      expect(x, equals(77));
    });

    testWidgets('should flag invalid values', (WidgetTester tester) async {
      int x;
      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              IntSpinner(
                key: ValueKey('IntSpinner'),
                onChanged: (value) => x = value,
              ),
              TextField(
                key: Key('FOO'),
              )
            ],
          ),
        ),
      ));

      expect(x, equals(0));

      // print('Enter valid text');
      await tester.enterText(find.byKey(ValueKey('IntSpinner-TEXT')), '-2200');
      expect(x, equals(-2200));

      // move the focus somewhere else ... anywhere else
      await tester.showKeyboard(find.byKey(Key('FOO')));

      TextField txt = tester.widget(find.byKey(ValueKey('IntSpinner-TEXT')));
      expect(txt.decoration.errorText, isNull);

      // print('Enter invalid text');
      await tester.enterText(find.byKey(ValueKey('IntSpinner-TEXT')), '2-200');
      expect(x, equals(-2200)); // unchanged!!

      // move the focus somewhere else ... anywhere else
      await tester.showKeyboard(find.byKey(Key('FOO')));

      txt = tester.widget(find.byKey(ValueKey('IntSpinner-TEXT')));
      expect(txt.decoration.errorText, equals('Invalid input'));
    });
  });
}

class DigitsToText extends StringToIntConverter {
  @override
  String toA(int input) =>
      _getDigits(input).map((it) => _toWord(it)).reduce((a, b) => '$a $b');

  @override
  int toB(String input) {
    int value = 0;
    int sign = 1;
    for (var word in input.split(' ')) {
      if (word == 'Negative')
        sign = -1;
      else {
        if (value > 0) value = value * 10;
        value = value + _words.indexOf(word);
      }
    }

    return sign * value;
  }

  List<int> _getDigits(int input) => input
      .toString()
      .characters
      .map((it) => (it == '-') ? -1 : int.parse(it))
      .toList();

  static final List<String> _words = [
    'Zero',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine'
  ];

  String _toWord(int it) => (it == -1) ? 'Negative' : _words[it];
}

int _calculateExponent(int value) {
  int index = 0;
  int sign = value.sign;
  int x = value.abs();

  while (x >= 2) {
    x = x ~/ 2;
    index++;
  }
  return index * sign;
}
