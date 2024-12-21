import 'package:bmi_health_checker/screen/gender_screen.dart';
import 'package:bmi_health_checker/screen/profile_screen.dart';
import 'package:bmi_health_checker/screen/history_screen.dart';
import 'package:bmi_health_checker/screen/result_screen.dart';
import 'package:bmi_health_checker/screen/height_screen.dart';
import 'package:bmi_health_checker/screen/weight_screen.dart';
import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GenderScreen(),
      routes: {
        'result_screen': (context) => ResultScreen(),
        'gender_screen': (context) => GenderScreen(),
        'history_screen': (context) => HistoryScreen(),
        'height_screen': (context) => HeightScreen(),
        'weight_screen': (context) => WeightScreen(),
      },
    );
  }
}
