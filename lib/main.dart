import 'dart:io';

import 'package:bmi_health_checker/screen/bmi_history_graph.dart';
import 'package:bmi_health_checker/screen/gender_screen.dart';

import 'package:bmi_health_checker/screen/history_screen.dart';
import 'package:bmi_health_checker/screen/result_screen.dart';
import 'package:bmi_health_checker/screen/height_screen.dart';
import 'package:bmi_health_checker/screen/weight_screen.dart';

import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';

import 'package:bmi_health_checker/utils/tooltip_manager.dart';
import 'package:bmi_health_checker/utils/preferences_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bmi_health_checker/widget/consent_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager.initialize();

  if (Platform.isAndroid) {
    // Set UI mode and orientation
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [], // This hides both status and navigation bars
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // Initialize Mobile Ads with test device ID
  await MobileAds.instance.initialize();

  // Configure test ads
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['D148266C72197CD782BAE1EF14A91836'],
    ),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926), // Design size based on your layout
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          platform: TargetPlatform.android,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) => RepaintBoundary(
          child: OptimizedChild(child: child!),
        ),
        home: const ConsentWrapper(child: GenderScreen()),
        routes: {
          'result_screen': (context) => const ResultScreen(),
          'gender_screen': (context) => const GenderScreen(),
          'history_screen': (context) => const HistoryScreen(),
          'height_screen': (context) => const HeightScreen(),
          'weight_screen': (context) => const WeightScreen(),
          'graph_screen': (context) => const BmiHistoryGraphScreen(),
        },
        navigatorObservers: [TooltipManager()],
      ),
    );
  }
}

class ConsentWrapper extends StatefulWidget {
  final Widget child;

  const ConsentWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ConsentWrapper> createState() => _ConsentWrapperState();
}

class _ConsentWrapperState extends State<ConsentWrapper> {
  static const String _consentKey = 'user_consent_given';
  bool _showingDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConsent();
    });
  }

  Future<void> _checkConsent() async {
    final hasConsented = await PreferencesManager.isFirstTime(_consentKey);
    if (!hasConsented && !_showingDialog) {
      setState(() => _showingDialog = true);
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ConsentDialog(
          onAccept: () async {
            await PreferencesManager.markTooltipShown(_consentKey);
          },
        ),
      );

      setState(() => _showingDialog = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class OptimizedChild extends StatelessWidget {
  final Widget child;

  const OptimizedChild({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: child,
    );
  }
}
