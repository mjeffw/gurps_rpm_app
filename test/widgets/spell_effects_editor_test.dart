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
                      onEffectDeleted: (index, model) {},
                      onEffectUpdated: (index, effect, model) {},
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
      ritual =
          ritual.addSpellEffect(SpellEffect(Path.body, level: Level.lesser));
      CastingModel model = CastingModel(casting: Casting(ritual));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DeleteButtonVisible()),
            ChangeNotifierProvider(create: (_) => model)
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectEditor(
                      key: Key('Editor'),
                      effect: model.inherentSpellEffects[0],
                      index: 0,
                      onEffectDeleted: (index, model) {},
                      onEffectUpdated: (index, effect, model) =>
                          model.updateInherentSpellEffect(index, effect),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      var dropdown = find.byKey(Key('Editor-LEVEL'));

      expect((tester.widget(dropdown) as DropdownButton).value,
          equals(Level.lesser));

      await tester.tap(dropdown);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byKey(Key('Editor-LEVEL[Greater]')).last);

      expect(model.inherentSpellEffects[0].level, equals(Level.greater));
    });

    testWidgets('should update Effect', (WidgetTester tester) async {
      Ritual ritual = Ritual();
      ritual =
          ritual.addSpellEffect(SpellEffect(Path.body, effect: Effect.control));
      CastingModel model = CastingModel(casting: Casting(ritual));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DeleteButtonVisible()),
            ChangeNotifierProvider(create: (_) => model)
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectEditor(
                      key: Key('Editor'),
                      effect: model.inherentSpellEffects[0],
                      index: 0,
                      onEffectDeleted: (index, model) {},
                      onEffectUpdated: (index, effect, model) =>
                          model.updateInherentSpellEffect(index, effect),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      var dropdown = find.byKey(Key('Editor-EFFECT'));

      expect((tester.widget(dropdown) as DropdownButton).value,
          equals(Effect.control));

      await tester.tap(dropdown);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byKey(Key('Editor-EFFECT[Transform]')).last);

      expect(model.inherentSpellEffects[0].effect, equals(Effect.transform));
    });

    testWidgets('should hide delete button', (WidgetTester tester) async {
      Ritual ritual = Ritual().addSpellEffect(SpellEffect(Path.body));
      CastingModel model = CastingModel(casting: Casting(ritual));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DeleteButtonVisible()),
            ChangeNotifierProvider(create: (_) => model)
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectEditor(
                      key: Key('Editor'),
                      effect: model.inherentSpellEffects[0],
                      index: 0,
                      onEffectDeleted: (index, model) {},
                      onEffectUpdated: (index, effect, model) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('Editor-DEL')), findsNothing);
    });

    testWidgets('should show delete button', (WidgetTester tester) async {
      Ritual ritual = Ritual().addSpellEffect(SpellEffect(Path.body));
      CastingModel model = CastingModel(casting: Casting(ritual));
      DeleteButtonVisible visible = DeleteButtonVisible();
      visible.value = true;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => visible),
            ChangeNotifierProvider(create: (_) => model)
          ],
          builder: (context, _) => MaterialApp(
            home: Scaffold(
              body: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: SpellEffectEditor(
                        key: Key('Editor'),
                        effect: model.inherentSpellEffects[0],
                        index: 0,
                        onEffectDeleted: (int, model) {},
                        onEffectUpdated: (int, effect, model) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('Editor-DEL')), findsOneWidget);
    });

    testWidgets('should delete spelleffect', (WidgetTester tester) async {
      Ritual ritual = Ritual().addSpellEffect(SpellEffect(Path.body));
      CastingModel model = CastingModel(casting: Casting(ritual));
      DeleteButtonVisible visible = DeleteButtonVisible();
      visible.value = true;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => visible),
            ChangeNotifierProvider(create: (_) => model)
          ],
          builder: (context, _) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: SpellEffectEditor(
                          key: Key('Editor'),
                          effect: model.inherentSpellEffects[0],
                          index: 0,
                          onEffectDeleted: (index, model) {
                            SpellEffect effect =
                                model.inherentSpellEffects[index];
                            model.removeInherentSpellEffect(index);
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Effect $effect deleted')));
                          },
                          onEffectUpdated: (int, effect, model) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(model.inherentSpellEffects.length, equals(1));

      await tester.tap(find.byKey(Key('Editor-DEL')));

      expect(model.inherentSpellEffects, isEmpty);
    });

    testWidgets('should swipe to delete', (WidgetTester tester) async {
      Ritual ritual = Ritual().addSpellEffect(SpellEffect(Path.body));
      CastingModel model = CastingModel(casting: Casting(ritual));
      DeleteButtonVisible visible = DeleteButtonVisible();
      visible.value = true;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => visible),
            ChangeNotifierProvider(create: (_) => model)
          ],
          builder: (context, _) => MaterialApp(
            home: Scaffold(
              body: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: SpellEffectEditor(
                        key: Key('Editor'),
                        effect: model.inherentSpellEffects[0],
                        index: 0,
                        onEffectDeleted: (int, model) {},
                        onEffectUpdated: (int, effect, model) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(model.inherentSpellEffects.length, equals(1));

      await tester.drag(find.byKey(Key('Editor-DEL')), Offset(500.0, 0.0));
      await tester.pumpAndSettle();

      expect(model.inherentSpellEffects, isEmpty);
    });
  });
}
