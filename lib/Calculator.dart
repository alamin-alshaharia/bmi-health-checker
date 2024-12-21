import 'dart:math';

class Calculator {
  double height; // height in centimeters
  double weight; // weight in kilograms
  late double _bmi;

  Calculator({required this.height, required this.weight});

  double bmiValue() {
    print('Calculating BMI with Height: $height cm, Weight: $weight kg');
    return _bmi = (weight / (pow(height / 100, 2)));
  }

  String bmiText() {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi >= 18.5 && _bmi < 25) return 'Normal';
    if (_bmi >= 25 && _bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String bmiInterpretation() {
    if (_bmi < 18.5) {
      return "You're capable of amazing things! Your BMI is lower than ideal, but you can make changes to improve your health. Keep pushing forward!";
    } else if (_bmi >= 18.5 && _bmi < 25) {
      return "You're doing amazing! Your BMI is within the normal range, indicating a healthy weight for your height. Keep pushing yourself to new heights!";
    } else if (_bmi >= 25 && _bmi < 30) {
      return "You're getting there! Your BMI is slightly above normal, but you're on the right track. Keep pushing yourself to reach your goals!";
    } else {
      return "You're not alone! Many people struggle with weight, but you're taking the first step towards a healthier you. Keep pushing forward!";
    }
  }

  Map<String, double> getHealthyWeightRange() {
    double heightInMeters = height / 100;
    double minWeight = 18.5 * pow(heightInMeters, 2);
    double maxWeight = 24.9 * pow(heightInMeters, 2);

    return {
      'min': double.parse(minWeight.toStringAsFixed(1)),
      'max': double.parse(maxWeight.toStringAsFixed(1))
    };
  }
}
