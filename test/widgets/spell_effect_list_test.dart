import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/models/casting_model.dart';
import 'package:gurps_rpm_app/src/widgets/spell_effect_list.dart';
import 'package:gurps_rpm_app/src/widgets/spell_effects_editor.dart';
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
                      key: Key('SpellEffectList'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('SpellEffectList')), findsOneWidget);
      await tester.pump();
      expect(find.byKey(Key('InherentSpellEffectsHeader')), findsOneWidget);
      expect(find.byElementType(SpellEffectEditor), findsNothing);
    });
  });
}
