import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/widgets/int_spinner.dart';
import 'package:gurps_rpm_app/src/widgets/text_converter.dart';

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
      TextFormField txt = tester.widget(finder);
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

    testWidgets('should allow text converter to be set',
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
                  FilteringTextInputFormatter.allow(r'[a-zA-Z ]')
                ],
              ),
            ],
          ),
        ),
      ));

      var finder = find.byKey(ValueKey('IntSpinner-TEXT'));
      TextFormField txt = tester.widget(finder);
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
    });
  });
}

class DigitsToText extends StringToIntConverter {
  @override
  String toA(int input) {
    List<int> digits = _getDigits(input);
    var reduce = digits
        .map((it) => _toWord(it))
        .reduce((value, element) => '$value $element');
    return reduce;
  }

  @override
  int toB(String input) {
    List<String> words = input.split(' ');

    int numberDigits = 0;
    int value = 0;
    int sign = 1;
    for (var word in words) {
      if (word == 'Negative')
        sign = -1;
      else
        value = (value * pow(10, numberDigits++)) + _words.indexOf(word);
    }

    return sign * value;
  }

  List<int> _getDigits(int input) {
    List<int> list = [];
    String value = input.toString();
    for (var character in value.characters) {
      list.add((character == '-') ? -1 : int.parse(character));
    }
    return list;
  }

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
    'Nine',
  ];

  _toWord(int it) {
    if (it == -1) return 'Negative';
    return _words[it];
  }
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
