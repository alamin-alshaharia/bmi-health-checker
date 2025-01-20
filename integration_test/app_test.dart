import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bmi_health_checker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End BMI Calculation Test', () {
    testWidgets('Complete BMI calculation flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Start with gender selection
      expect(find.text('SELECT GENDER'), findsOneWidget);
      await tester.tap(find.text('MALE'));
      await tester.pumpAndSettle();

      // 2. Height screen
      expect(find.text('HEIGHT'), findsOneWidget);
      // Set height to 170 cm
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // 3. Weight screen
      expect(find.text('WEIGHT'), findsOneWidget);
      // Set weight to 70 kg
      await tester.tap(find.text('70.0 kg'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // 4. Result screen
      expect(find.text('YOUR RESULT'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);

      // Verify BMI value (for 170cm and 70kg)
      expect(find.text('24.22'), findsOneWidget);
    });

    testWidgets('Unit conversion test flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to weight screen
      await tester.tap(find.text('MALE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Test weight unit conversion
      await tester.tap(find.text('KG'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pound').last);
      await tester.pumpAndSettle();

      // Verify converted weight is shown
      expect(find.textContaining('lbs'), findsOneWidget);
    });

    testWidgets('History saving test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Complete a BMI calculation
      await tester.tap(find.text('MALE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Navigate to history
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      // Verify history entry exists
      expect(find.textContaining('BMI:'), findsOneWidget);
    });
  });
}
