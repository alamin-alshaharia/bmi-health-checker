import 'package:flutter_riverpod/flutter_riverpod.dart';

final heightInputProvider =
    StateNotifierProvider<HeightInputNotifier, double>((ref) {
  return HeightInputNotifier();
});

final weightInputProvider =
    StateNotifierProvider<WeightInputNotifier, double>((ref) {
  return WeightInputNotifier();
});

class HeightInputNotifier extends StateNotifier<double> {
  HeightInputNotifier() : super(170.0);

  void updateHeight(double height, String unit) {
    switch (unit) {
      case "Feet":
        state = height * 30.48;
        break;
      case "Inch":
        state = height * 2.54;
        break;
      case "Meter":
        state = height * 100;
        break;
      case "Cm":
        state = height;
        break;
    }
  }

  double getDisplayValue(String unit) {
    switch (unit) {
      case "Feet":
        return state / 30.48;
      case "Inch":
        return state / 2.54;
      case "Meter":
        return state / 100;
      case "Cm":
        return state;
      default:
        return state;
    }
  }
}

class WeightInputNotifier extends StateNotifier<double> {
  WeightInputNotifier() : super(70.0);

  void updateWeight(double weight, String unit) {
    state = unit == "Pound" ? weight / 2.20462 : weight;
  }

  double getDisplayValue(String unit) {
    return unit == "Pound" ? state * 2.20462 : state;
  }
}
