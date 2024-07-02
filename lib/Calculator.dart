import 'dart:math';

class Calculator {
  double height;
  int weight;
  late double _bmi;

  Calculator({required this.height, required this.weight});

  double bmiValue() {
    return _bmi = (weight / (pow(height, 2)) * 10000);
  }

  bmiText() {
    return (_bmi > 18.5 && _bmi < 24.9)
        ? 'normal'
        : (_bmi < 18.5)
            ? 'underWeight'
            : (_bmi > 25 && _bmi < 29.9)
                ? 'overWeight'
                : 'obese';
  }

  String bmiInterpretaion() {
    return ((_bmi > 18.5 && _bmi < 24.9)
        ? "You're doing amazing! Your BMI is within the normal range, indicating a healthy weight for your height. Keep pushing yourself to new heights!"
        : (_bmi < 18.5)
            ? "You're capable of amazing things! Your BMI is lower than ideal, but you can make changes to improve your health. Keep pushing forward!"
            : (_bmi > 25 && _bmi < 29.9)
                ? "You're getting there! Your BMI is slightly above normal, but you're on the right track. Keep pushing yourself to reach your goals!"
                : "You're not alone! Many people struggle with weight, but you're taking the first step towards a healthier you. Keep pushing forward!");
  }
}
