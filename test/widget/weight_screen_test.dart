import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bmi_health_checker/screen/weight_screen.dart';
import 'package:bmi_health_checker/providers/bmi_provider.dart';

void main() {
  group('WeightScreen Widget Tests', () {
    Widget createWeightScreen() {
      return ProviderScope(
        child: MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const WeightScreen(),
                settings: RouteSettings(
                  arguments: {
                    "height": 170.0,
                    "gender": "male",
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    testWidgets('Weight screen shows correct initial state',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Verify initial weight display
      expect(find.textContaining('kg'), findsOneWidget);

      // Verify unit selector exists
      expect(find.text('KG'), findsOneWidget);

      // Verify navigation buttons
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('Weight unit conversion works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Find and tap the unit dropdown
      await tester.tap(find.text('KG'));
      await tester.pumpAndSettle();

      // Select Pound
      await tester.tap(find.text('Pound').last);
      await tester.pumpAndSettle();

      // Verify weight is shown in pounds
      expect(find.textContaining('lbs'), findsOneWidget);
    });

    testWidgets('Weight input validation works', (WidgetTester tester) async {
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Tap the weight display to show input dialog
      await tester.tap(find.textContaining('kg'));
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
