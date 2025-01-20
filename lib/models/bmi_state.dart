class BmiState {
  final String gender;
  final double height;
  final double weight;
  final String unit;
  final double bmi;
  final String bmiText;
  final String bmiInterpretation;

  const BmiState({
    required this.gender,
    required this.height,
    required this.weight,
    required this.unit,
    required this.bmi,
    required this.bmiText,
    required this.bmiInterpretation,
  });

  factory BmiState.initial() => const BmiState(
        gender: 'male',
        height: 170,
        weight: 70,
        unit: 'KG',
        bmi: 0,
        bmiText: '',
        bmiInterpretation: '',
      );

  BmiState copyWith({
    String? gender,
    double? height,
    double? weight,
    String? unit,
    double? bmi,
    String? bmiText,
    String? bmiInterpretation,
  }) {
    return BmiState(
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      bmi: bmi ?? this.bmi,
      bmiText: bmiText ?? this.bmiText,
      bmiInterpretation: bmiInterpretation ?? this.bmiInterpretation,
    );
  }
}
