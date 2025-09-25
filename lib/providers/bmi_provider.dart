import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bmi_state.dart';
import '../calculator.dart';

final bmiProvider = StateNotifierProvider<BmiNotifier, BmiState>((ref) {
  return BmiNotifier();
});

class BmiNotifier extends StateNotifier<BmiState> {
  BmiNotifier() : super(BmiState.initial());

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateHeight(double height) {
    state = state.copyWith(height: height);
    _calculateBmi();
  }

  void updateWeight(double weight, String unit) {
    final weightInKg = unit == 'Pound' ? weight / 2.20462 : weight;
    state = state.copyWith(
      weight: weightInKg,
      unit: unit,
    );
    _calculateBmi();
  }

  void _calculateBmi() {
    final calculator = Calculator(
      height: state.height,
      weight: state.weight,
    );

    state = state.copyWith(
      bmi: calculator.bmiValue(),
      bmiText: calculator.bmiText(),
      bmiInterpretation: calculator.bmiInterpretation(),
    );
  }
}
