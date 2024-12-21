class UserProfile {
  String gender;
  double height; // in cm
  int weight; // in kg
  int age;

  UserProfile({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'age': age,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
    );
  }
}
