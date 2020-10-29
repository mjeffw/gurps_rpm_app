import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/spell_effect_list.dart';
import 'package:gurps_rpm_app/src/widgets/spell_effects_editor.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:provider/provider.dart';

void main() {
  group('SpellEffectList', () {
    testWidgets('should use Key', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CastingModel(),
            ),
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectList(
                      key: Key('SpellEffects'),
                      title: 'Test',
                      selector: (_, model) => model.inherentSpellEffects,
                      onEffectDeleted: (index, model) {},
                      onEffectUpdated: (index, effect, model) {},
                      onEffectAdded: (name, model) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('SpellEffects-HEADER')), findsOneWidget);
      expect(find.byKey(Key('SpellEffects-LIST')), findsOneWidget);
      expect(find.byType(SpellEffectEditor), findsNothing);
    });

    testWidgets('should show Effects', (WidgetTester tester) async {
      CastingModel model = CastingModel();
      model.addInherentSpellEffect('Magic');
      model.addInherentSpellEffect('Mind');
      model.updateInherentSpellEffect(
          1, model.inherentSpellEffects[1].withLevel(Level.greater));
      model.updateInherentSpellEffect(
          1, model.inherentSpellEffects[1].withEffect(Effect.transform));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => model,
            ),
          ],
          builder: (context, _) => MaterialApp(
            home: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SpellEffectList(
                      key: Key('SpellEffects'),
                      title: 'Test',
                      selector: (_, model) => model.inherentSpellEffects,
                      onEffectDeleted: (index, model) {},
                      onEffectUpdated: (index, effect, model) {},
                      onEffectAdded: (name, model) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('SpellEffects-HEADER')), findsOneWidget);
      expect(find.byKey(Key('SpellEffects-LIST')), findsOneWidget);
      expect(find.byType(SpellEffectEditor), findsNWidgets(2));

      SpellEffectEditor editor =
          tester.widget(find.byType(SpellEffectEditor).first);
      expect(
          editor.effect,
          equals(SpellEffect(Path.magic,
              level: Level.lesser, effect: Effect.sense)));

      editor = tester.widget(find.byType(SpellEffectEditor).last);
      expect(
          editor.effect,
          equals(SpellEffect(Path.mind,
              level: Level.greater, effect: Effect.transform)));
    });
  });
}
