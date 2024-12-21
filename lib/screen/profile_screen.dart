import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Male';
  double _height = 0;
  int _weight = 0;
  int _age = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString('user_profile');
    if (profileData != null) {
      final profile = UserProfile.fromJson(jsonDecode(profileData));
      setState(() {
        _gender = profile.gender;
        _height = profile.height;
        _weight = profile.weight;
        _age = profile.age;
      });
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profile = UserProfile(
      gender: _gender,
      height: _height,
      weight: _weight,
      age: _age,
    );
    await prefs.setString('user_profile', jsonEncode(profile.toJson()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.purple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration:
                              const InputDecoration(labelText: 'Gender'),
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Select a gender' : null,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Height (cm)'),
                          keyboardType: TextInputType.number,
                          initialValue: _height.toString(),
                          onChanged: (value) {
                            _height = double.tryParse(value) ?? 0;
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Enter height' : null,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Weight (kg)'),
                          keyboardType: TextInputType.number,
                          initialValue: _weight.toString(),
                          onChanged: (value) {
                            _weight = int.tryParse(value) ?? 0;
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Enter weight' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                          initialValue: _age.toString(),
                          onChanged: (value) {
                            _age = int.tryParse(value) ?? 0;
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Enter age' : null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveProfile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // primary: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Save Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
