import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/models/delete_button_visible.dart';
import 'package:gurps_rpm_app/src/widgets/spell_effects_editor.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

void main() {
  group('SpellEffectEditor', () {
    testWidgets('should use Key', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DeleteButtonVisible>(
              create: (_) => DeleteButtonVisible(),
            ),
            ChangeNotifierProvider(
              create: (_) => CastingModel(),
            ),
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectEditor(
                      key: Key('Editor'),
                      effect: SpellEffect(
                        Path.body,
                        effect: Effect.control,
                        level: Level.greater,
                      ),
                      index: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('Editor')), findsOneWidget);
    });

    testWidgets('should update Level', (WidgetTester tester) async {
      Ritual ritual = Ritual();
      ritual = ritual.addSpellEffect(SpellEffect(Path.body));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DeleteButtonVisible()),
            ChangeNotifierProvider(
                create: (_) => CastingModel(casting: Casting(ritual))),
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectEditor(
                      key: Key('Editor'),
                      effect: ritual.effects[0],
                      index: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      var finder = find.byKey(Key('Editor-LEVEL'));
      expect((tester.widget(finder) as DropdownButton).value,
          equals(Level.lesser));

      await tester.tap(finder);
      await teste*r.tap(find.byKey(Key('Editor-LEVEL[Greater]')));
      await tester.pump();
      expect((tester.widget(finder) as DropdownButton).value,
          equals(Level.greater));
    }, skip: true);
  });

  group('description', () {
    Key lesser = Key('LESSER');
    Key greater = Key('GREATER');
    Key level = Key('LEVEL');

    testWidgets('description', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Card(
          child: Column(
            children: [
              Expanded(
                child: DropdownButton(
                  key: level,
                  items: [
                    DropdownMenuItem<String>(
                      key: greater,
                      value: 'Greater',
                      child: Text('Greater'),
                    ),
                    DropdownMenuItem<String>(
                      key: lesser,
                      value: 'Lesser',
                      child: Text('Lesser'),
                    ),
                  ],
                  onChanged: (value) {
                    print('$value');
                  },
                  value: 'Lesser',
                ),
              )
            ],
          ),
        ),
      ));

      expect((tester.widget(find.byKey(level)) as DropdownButton).value,
          equals('Lesser'));

      await tester.tap(find.byKey(level));

      DropdownMenuItem item = tester.widget(find.byKey(greater));
      expect(item, isNotNull);

      await tester.tap(find.byKey(greater));
      await tester.pumpAndSettle();
      await expectLater(
          (tester.widget(find.byKey(level)) as DropdownButton).value,
          equals('Greater'));
    }, skip: true);
  });
}
