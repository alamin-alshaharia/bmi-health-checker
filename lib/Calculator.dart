import 'dart:math';

class Calculator {
  final double height;
  final double weight;
  late final double _bmi;

  Calculator({required this.height, required this.weight}) {
    _bmi = weight / pow(height / 100, 2);
  }

  double bmiValue() => _bmi;

  String bmiText() {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String bmiInterpretation() {
    if (_bmi < 18.5)
      return "You're capable of amazing things! Your BMI is lower than ideal, but you can make changes to improve your health. Keep pushing forward!";
    if (_bmi < 25)
      return "You're doing amazing! Your BMI is within the normal range, indicating a healthy weight for your height. Keep pushing yourself to new heights!";
    if (_bmi < 30)
      return "You're getting there! Your BMI is slightly above normal, but you're on the right track. Keep pushing yourself to reach your goals!";
    return "You're not alone! Many people struggle with weight, but you're taking the first step towards a healthier you. Keep pushing forward!";
  }

  Map<String, double> getHealthyWeightRange() {
    final heightInMeters = height / 100;
    return {
      'min': double.parse((18.5 * pow(heightInMeters, 2)).toStringAsFixed(1)),
      'max': double.parse((24.9 * pow(heightInMeters, 2)).toStringAsFixed(1))
    };
  }
}
