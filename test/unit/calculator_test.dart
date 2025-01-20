import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_health_checker/Calculator.dart';

void main() {
  group('BMI Calculator Tests', () {
    test('Calculate BMI with metric units (kg, cm)', () {
      final calculator = Calculator(height: 170, weight: 70);
      expect(calculator.bmiValue(), closeTo(24.22, 0.01));
      expect(calculator.bmiText(), 'Normal');
    });

    test('Calculate BMI for underweight', () {
      final calculator = Calculator(height: 170, weight: 50);
      expect(calculator.bmiValue(), closeTo(17.30, 0.01));
      expect(calculator.bmiText(), 'Underweight');
    });

    test('Calculate BMI for overweight', () {
      final calculator = Calculator(height: 170, weight: 80);
      expect(calculator.bmiValue(), closeTo(27.68, 0.01));
      expect(calculator.bmiText(), 'Overweight');
    });

    test('Calculate BMI for obese', () {
      final calculator = Calculator(height: 170, weight: 90);
      expect(calculator.bmiValue(), closeTo(31.14, 0.01));
      expect(calculator.bmiText(), 'Obese');
    });

    test('Calculate healthy weight range', () {
      final calculator = Calculator(height: 170, weight: 70);
      final range = calculator.getHealthyWeightRange();
      expect(range['min'], closeTo(53.5, 0.1));
      expect(range['max'], closeTo(71.9, 0.1));
    });

    // Edge cases
    test('Handle very short height', () {
      final calculator = Calculator(height: 100, weight: 30);
      expect(calculator.bmiValue(), closeTo(30.0, 0.01));
    });

    test('Handle very tall height', () {
      final calculator = Calculator(height: 220, weight: 100);
      expect(calculator.bmiValue(), closeTo(20.66, 0.01));
    });
  });
}
