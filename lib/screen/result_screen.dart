import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late double height;
  late double weight;

  Color getStatusColor(dynamic bmi) {
    if (bmi > 18.5 && bmi < 24.9) return Colors.green;
    if (bmi < 18.5) return Colors.blue;
    if (bmi > 25 && bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  double getIndicatorPosition(double bmi) {
    const double minBMI = 15.0;
    const double maxBMI = 40.0;
    const double range = maxBMI - minBMI;

    double clampedBMI = bmi.clamp(minBMI, maxBMI);

    return (clampedBMI - minBMI) / range;
  }

  Future<void> _saveResult(
      double bmi, String bmiText, String interpretation) async {
    final prefs = await SharedPreferences.getInstance();
    final result = {
      'date': DateTime.now().toIso8601String(),
      'bmi': bmi,
      'status': bmiText,
      'interpretation': interpretation,
    };

    // Get existing results or initialize empty list
    List<String> savedResults = prefs.getStringList('bmi_results') ?? [];
    savedResults.add(jsonEncode(result));

    // Save updated list
    await prefs.setStringList('bmi_results', savedResults);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BMI result saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _shareResult(
      double bmi, String bmiText, String interpretation) async {
    final String shareText = '''
🏋️‍♂️ My BMI Results 🏋️‍♀️

BMI: ${bmi.toStringAsFixed(1)}
Status: $bmiText
$interpretation

Calculated using BMI Calculator App
''';

    await Share.share(shareText, subject: 'My BMI Results');
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    var bmi = arguments["bmi"];
    var bmiText = arguments["bmiText"];
    var bmiInterpretation = arguments["bmiInterpretation"];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'YOUR RESULT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // For balance
                ],
              ),

              const SizedBox(height: 40),

              // Main Result Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[900]!,
                        Colors.grey[850]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bmiText.toUpperCase(),
                        style: TextStyle(
                          color: getStatusColor(bmi),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        bmi.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'BMI',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // BMI Scale
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF3B82F6), // Blue
                                  Color(0xFF22C55E), // Green
                                  Color(0xFFF97316), // Orange
                                  Color(0xFFEF4444), // Red
                                ],
                              ),
                            ),
                          ),
                          // Indicator
                          Positioned(
                            left: 20 +
                                (MediaQuery.of(context).size.width - 40) *
                                    getIndicatorPosition(bmi),
                            child: Transform.translate(
                              offset: const Offset(-1.5, -3),
                              child: Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Interpretation
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          bmiInterpretation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () => _shareResult(bmi, bmiText, bmiInterpretation),
                  ),
                  _buildActionButton(
                    icon: Icons.refresh,
                    label: 'Recalculate',
                    onTap: () => Navigator.pop(context),
                    isPrimary: true,
                  ),
                  _buildActionButton(
                    icon: Icons.save_alt,
                    label: 'Save',
                    onTap: () => _saveResult(bmi, bmiText, bmiInterpretation),
                  ),
                  _buildActionButton(
                    icon: Icons.history,
                    label: 'History',
                    onTap: () => Navigator.pushNamed(context, 'history_screen'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isPrimary ? Colors.blue : Colors.grey[850],
            borderRadius: BorderRadius.circular(16),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
            iconSize: 28,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
