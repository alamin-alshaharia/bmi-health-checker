import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bmi_health_checker/widget/interstitial_ad_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity package
import '../ads/rewarded_ad_manager.dart';
import '../constant/color/color.dart'; // Import color constants
import '../constant/text_style.dart'; // Import text styles

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final RewardedAdManager _rewardedAdManager = RewardedAdManager();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      setState(() {
        _connectivityResult = result.first;
      });

      _connectivitySubscription = _connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        setState(() {
          _connectivityResult = results.first;
        });
      });
    } catch (e) {
      print('Connectivity initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    // Extract arguments with null checks
    var bmi = arguments["bmi"] ?? 0.0; // Default to 0.0 if null
    var bmiText = arguments["bmiText"] ?? "Unknown"; // Default to "Unknown"
    var bmiInterpretation = arguments["bmiInterpretation"] ??
        "No interpretation available"; // Default message
    var gender =
        arguments["gender"] ?? "Not specified"; // Default to "Not specified"
    var height = arguments["height"] ?? 0.0; // Default to 0.0 if null
    var weight = arguments["weight"] ?? 0.0; // Default to 0.0 if null

    // Debugging print statements
    print(
        'BMI: $bmi, BMI Text: $bmiText, Interpretation: $bmiInterpretation, Gender: $gender, Height: $height, Weight: $weight');

    return InterstitialAdWidget(
      child: Scaffold(
        backgroundColor: kBacgroundColor, // Use consistent background color
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

                        // BMI Indicator Bar
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                      onTap: () async {
                        // Check for internet connectivity
                        if (_connectivityResult == ConnectivityResult.none) {
                          _showNoInternetDialog();
                        } else {
                          _rewardedAdManager.showAd(() {
                            // Save the result after the ad is watched
                            _shareResult(bmi, bmiText, bmiInterpretation,
                                height, weight);
                          });
                        }
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Recalculate',
                      onTap: () =>
                          Navigator.pushNamed(context, "gender_screen"),
                    ),
                    _buildActionButton(
                      icon: Icons.save_alt,
                      label: 'Save',
                      onTap: () async {
                        // Check for internet connectivity
                        if (_connectivityResult == ConnectivityResult.none) {
                          _showNoInternetDialog();
                        } else {
                          _rewardedAdManager.showAd(() {
                            _saveResult(bmi, bmiText, bmiInterpretation, gender,
                                height, weight);
                          });
                        }
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () =>
                          Navigator.pushNamed(context, 'history_screen'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNoInternetDialog() {
    if (_connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'To use this feature, you need to be connected to the internet. You will need to watch ads to access this feature.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Color getStatusColor(double bmi) {
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

  Future<void> _saveResult(double bmi, String bmiText, String interpretation,
      String gender, double height, double weight) async {
    final prefs = await SharedPreferences.getInstance();
    final result = {
      'date': DateTime.now().toIso8601String(),
      'bmi': bmi,
      'status': bmiText,
      'interpretation': interpretation,
      'gender': gender,
      'height': height,
      'weight': weight,
    };

    // Get existing results or initialize empty list
    List<String> savedResults = prefs.getStringList('bmi_results') ?? [];
    savedResults.add(jsonEncode(result));

    // Save updated list
    try {
      await prefs.setStringList('bmi_results', savedResults);
    } catch (e) {
      print('Error saving BMI result: $e');
    }

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BMI result saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    print('Saving result: $result');
  }

  Future<void> _shareResult(double bmi, String bmiText, String interpretation,
      double height, double weight) async {
    final String shareText = '''
🏋️‍♂️ My BMI Results 🏋️‍♀️

Height: ${height.toStringAsFixed(2)} cm
Weight: ${weight.toStringAsFixed(2)} kg
BMI: ${bmi.toStringAsFixed(2)}
Status: $bmiText
$interpretation

Calculated using BMI Health Checker App
''';

    await Share.share(shareText, subject: 'My BMI Results');
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
