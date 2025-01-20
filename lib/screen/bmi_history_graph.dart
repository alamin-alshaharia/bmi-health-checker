import 'package:flutter/material.dart';
import '../widget/bmi_history_graph_widget.dart';
import '../constant/color/color.dart';
import '../widget/interstitial_ad_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bmi_history_provider.dart';
import '../providers/ad_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BmiHistoryGraphScreen extends ConsumerStatefulWidget {
  const BmiHistoryGraphScreen({super.key});

  @override
  ConsumerState<BmiHistoryGraphScreen> createState() =>
      _BmiHistoryGraphScreenState();
}

class _BmiHistoryGraphScreenState extends ConsumerState<BmiHistoryGraphScreen> {
  static const String screenId = 'bmi_history_graph';
  late final bannerAdManager;
  late final interstitialAdManager;

  @override
  void initState() {
    super.initState();
    bannerAdManager = ref.read(bannerAdProvider);
    interstitialAdManager = ref.read(interstitialAdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(bmiHistoryProvider);

    return SafeArea(
      child: InterstitialAdWidget(
        child: Scaffold(
          backgroundColor: kBacgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'BMI History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.r),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: history.isEmpty
                      ? Center(
                          child: Text(
                            'No BMI history available',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : BmiHistoryGraphWidget(
                          bmiData: history.map((e) => e.bmi).toList(),
                          dates: history
                              .map((e) => '${e.date.day}/${e.date.month}')
                              .toList(),
                        ),
                ),
              ),
              Container(
                height: 60.h,
                alignment: Alignment.center,
                child: bannerAdManager.getAdWidget(screenId),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
