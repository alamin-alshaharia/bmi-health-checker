class BmiHistoryEntry {
  final double bmi;
  final String status;
  final String gender;
  final double height;
  final double weight;
  final DateTime date;

  BmiHistoryEntry({
    required this.bmi,
    required this.status,
    required this.gender,
    required this.height,
    required this.weight,
    required this.date,
  });

  factory BmiHistoryEntry.fromJson(Map<String, dynamic> json) {
    return BmiHistoryEntry(
      bmi: json['bmi'] as double,
      status: json['status'] as String,
      gender: json['gender'] as String,
      height: json['height'] as double,
      weight: json['weight'] as double,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'status': status,
      'gender': gender,
      'height': height,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }
}
