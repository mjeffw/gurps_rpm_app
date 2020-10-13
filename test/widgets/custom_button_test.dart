import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/widgets/arrow_button.dart';
import 'package:gurps_rpm_app/src/widgets/delete_button.dart';
import 'package:gurps_rpm_app/src/widgets/edit_button.dart';

void main() {
  testWidgets('arrow_button', (WidgetTester tester) async {
    bool left = false;
    bool right = false;
    bool doubleRight = false;
    bool doubleLeft = false;

    await tester.pumpWidget(MaterialApp(
      home: Card(
        child: Column(
          children: [
            RightArrowButton(onPressed: () => right = true),
            DoubleRightArrowButton(onPressed: () => doubleRight = true),
            LeftArrowButton(onPressed: () => left = true),
            DoubleLeftArrowButton(onPressed: () => doubleLeft = true),
          ],
        ),
      ),
    ));

    await tester.tap(find.byType(RightArrowButton));
    expect(right, true);

    await tester.tap(find.byType(DoubleRightArrowButton));
    expect(doubleRight, true);

    await tester.tap(find.byType(LeftArrowButton));
    expect(left, true);

    await tester.tap(find.byType(DoubleLeftArrowButton));
    expect(doubleLeft, true);
  });

  testWidgets('delete button', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(MaterialApp(
      home: Card(
        child: Column(
          children: [
            DeleteButton(
              onPressed: () => pressed = true,
            )
          ],
        ),
      ),
    ));

    await tester.tap(find.byType(DeleteButton));
    expect(pressed, true);
  });

  testWidgets('edit button', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(MaterialApp(
      home: Card(
        child: Column(
          children: [
            EditButton(
              onPressed: () => pressed = true,
            )
          ],
        ),
      ),
    ));

    await tester.tap(find.byType(EditButton));
    expect(pressed, true);
  });
}
