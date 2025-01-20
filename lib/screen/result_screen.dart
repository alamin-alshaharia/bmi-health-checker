import 'dart:async';

import 'package:bmi_health_checker/screen/gender_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bmi_health_checker/widget/interstitial_ad_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity package
import '../ads/rewarded_ad_manager.dart';
import '../constant/color/color.dart'; // Import color constants
import '../models/bmi_history_state.dart';
import '../providers/bmi_history_provider.dart';
import '../providers/ad_provider.dart'; // Add this import
import '../utils/preferences_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late final RewardedAdManager _rewardedAdManager;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _rewardedAdManager = ref.read(rewardedAdProvider);
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      setState(() {
        _connectivityResult = result.first;
      });
      _handleConnectivityChange(result.first);

      _connectivitySubscription = _connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        setState(() {
          _connectivityResult = results.first;
        });
        _handleConnectivityChange(results.first);
      });
    } catch (e) {
      // print('Connectivity initialization error: $e');
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result != ConnectivityResult.none) {
      // Only load initial ad when internet connects
      _rewardedAdManager.loadAd();
      // print('Internet connected - Loading initial rewarded ad');
    } else {
      // print('No internet connection');
    }
  }

  Future<void> _showFeatureLockedDialog(VoidCallback onProceed) async {
    final canUseFeature = await PreferencesManager.canUseSaveShareFeature();

    if (canUseFeature) {
      onProceed();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kBacgroundColor,
        title: const Text(
          'Feature Locked',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'To use this feature, you need to watch a short video ad. After watching, you\'ll have access to this feature for 24 hours.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_connectivityResult == ConnectivityResult.none) {
                _showNoInternetDialog();
                return;
              }

              _rewardedAdManager.showAd(
                () {
                  PreferencesManager.updateSaveShareRewardTime();
                  onProceed();
                  _rewardedAdManager.loadAd();
                },
                onAdFailedToLoad: () {
                  _showRewardAdFailedDialog();
                },
              );
            },
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  void _handleSaveButton(double bmi, String bmiText, String interpretation,
      String gender, double height, double weight) {
    _showFeatureLockedDialog(() {
      final entry = BmiHistoryEntry(
        bmi: bmi,
        status: bmiText,
        gender: gender,
        height: height,
        weight: weight,
        date: DateTime.now(),
      );
      ref.read(bmiHistoryProvider.notifier).addEntry(entry);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BMI result saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _handleShareButton(double bmi, String bmiText, String interpretation) {
    _showFeatureLockedDialog(() {
      Share.share(
        'My BMI Result:\nBMI: ${bmi.toStringAsFixed(1)}\nCategory: $bmiText\n$interpretation',
        subject: 'My BMI Result',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    var bmi = arguments["bmi"] ?? 0.0;
    var bmiText = arguments["bmiText"] ?? "Unknown";
    var bmiInterpretation =
        arguments["bmiInterpretation"] ?? "No interpretation available";
    var gender = arguments["gender"] ?? "Not specified";
    var height = arguments["height"] ?? 0.0;
    var weight = arguments["weight"] ?? 0.0;

    return InterstitialAdWidget(
      child: Scaffold(
        backgroundColor: kBacgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 24.r,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'YOUR RESULT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w),
                  ],
                ),
                SizedBox(height: 40.h),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[900]!,
                          Colors.grey[850]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
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
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          bmi.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'BMI',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Stack(
                          children: [
                            Container(
                              height: 8.h,
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF22C55E),
                                    Color(0xFFF97316),
                                    Color(0xFFEF4444),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20.w +
                                  (MediaQuery.of(context).size.width - 40) *
                                      getIndicatorPosition(bmi),
                              child: Transform.translate(
                                offset: const Offset(-1.5, -3),
                                child: Container(
                                  width: 3.w,
                                  height: 14.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1.5.r),
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
                        SizedBox(height: 30.h),
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            bmiInterpretation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () => _handleShareButton(
                        bmi,
                        bmiText,
                        bmiInterpretation,
                      ),
                    ),
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Recalculate',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GenderScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.save_alt,
                      label: 'Save',
                      onTap: () => _handleSaveButton(
                        bmi,
                        bmiText,
                        bmiInterpretation,
                        gender,
                        height,
                        weight,
                      ),
                    ),
                    _buildActionButton(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () =>
                          Navigator.pushNamed(context, 'history_screen'),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
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
            borderRadius: BorderRadius.circular(16.r),
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
            icon: Icon(icon, color: Colors.white, size: 28.r),
            onPressed: onTap,
            padding: EdgeInsets.all(12.r),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.blue : Colors.grey,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  void _showRewardAdFailedDialog() {
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
                    color: Colors.orange[400],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ad Failed to Load',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Unable to load the reward ad. This might be due to network issues or you are using ads blocker or private dns.You will need to watch ads to access this feature Please try again later.',
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
