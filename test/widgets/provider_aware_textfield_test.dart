import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_rpm_app/src/widgets/provider_aware_textfield.dart';
import 'package:provider/provider.dart';

void main() {
  group('ProviderSelectorTextField', () {
    testWidgets('should use Key', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => _Model(),
        builder: (_, __) => MaterialApp(
          home: Card(
            child: Column(
              children: [
                Expanded(
                  child: ProviderSelectorTextField<_Model>(
                    key: Key('Field'),
                    valueProvider: (context, model) => '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ));

      expect(find.byKey(Key('Field')), findsOneWidget);
    });

    testWidgets('should update model', (WidgetTester tester) async {
      _Model model = _Model();

      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => model,
        builder: (_, __) => MaterialApp(
          home: Card(
            child: Column(
              children: [
                Expanded(
                  child: ProviderSelectorTextField<_Model>(
                    key: Key('Field'),
                    valueProvider: (context, model) => (model as _Model).name,
                    onSubmitted: (value) {
                      return model.name = value;
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    key: Key('DUMMY'),
                  ),
                )
              ],
            ),
          ),
        ),
      ));

      expect(model.name, equals('fee'));
      expect(find.byKey(Key('Field-TEXT')), findsOneWidget);

      await tester.enterText(find.byKey(Key('Field-TEXT')), 'FOO');

      // move the focus somewhere else... anywhere else
      await tester.showKeyboard(find.byKey(Key('DUMMY')));
      expect(model.name, equals('FOO'));
    });

    testWidgets('should update when model changes',
        (WidgetTester tester) async {
      _Model model = _Model();

      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => model,
        builder: (_, __) => MaterialApp(
          home: Card(
            child: Column(
              children: [
                Expanded(
                  child: ProviderSelectorTextField<_Model>(
                    key: Key('Field'),
                    valueProvider: (context, model) => (model as _Model).name,
                    onSubmitted: (value) {
                      return model.name = value;
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    key: Key('DUMMY'),
                  ),
                )
              ],
            ),
          ),
        ),
      ));

      expect(model.name, equals('fee'));
      model.name = 'BAR';

      // move the focus somewhere else... anywhere else
      await tester.showKeyboard(find.byKey(Key('DUMMY')));
      expect(model.name, equals('BAR'));
    });
  });
}

class _Model with ChangeNotifier {
  String _name = 'fee';

  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }
}
