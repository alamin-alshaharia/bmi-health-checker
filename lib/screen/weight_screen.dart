import 'package:bmi_health_checker/widget/custom_box.dart';
import 'package:bmi_health_checker/widget/weight_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bmi_health_checker/ads/banner_ad_manager.dart';

import '../calculator.dart';
import '../constant/color/color.dart';
import '../constant/text_style.dart';
import '../widget/button.dart';

import '../widget/custom_drawer.dart';
import '../widget/arrow_painter.dart';

import '../utils/tooltip_manager.dart';

import '../widget/custom_dropdown.dart';

import '../utils/preferences_manager.dart';

import '../providers/bmi_provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({
    super.key,
  });

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen>
    with WidgetsBindingObserver {
  static const String screenId = 'weight_screen';
  String selectedMenu = "KG";
  final int _totalCount = 5000;
  final double _interval = 0.1;
  double weight = 50;
  // Always stored in KG
  double displayValue = 50; // Value shown in current unit

  // Add back necessary fields
  late Calculator calc;
  late BannerAdManager _bannerAdManager;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  bool _showTooltip = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _weightValueKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bannerAdManager = BannerAdManager();
    _initializeScreen();
    displayValue = selectedMenu == "KG" ? weight : weight * 2.20462;
  }

  Future<void> _initializeScreen() async {
    if (mounted) {
      await _checkFirstTime();
      _loadSavedValues();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveValues();
    }
  }

  Future<void> _saveValues() async {
    // Save current values to preferences
  }

  void _loadSavedValues() {
    // Load saved values from preferences
  }

  Future<void> _checkFirstTime() async {
    if (await PreferencesManager.isFirstTime(
        PreferencesManager.keyWeightTooltip)) {
      setState(() {
        _showTooltip = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlayTooltip();
      });

      await PreferencesManager.markTooltipShown(
          PreferencesManager.keyWeightTooltip);
    }
  }

  void _showOverlayTooltip() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final RenderBox? renderBox =
            _weightValueKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null) return const SizedBox.shrink();

        final position = renderBox.localToGlobal(Offset.zero);

        return Positioned(
          top: position.dy - 80,
          left: position.dx - 40,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: kActiveColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Click here to input value manually',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close,
                            size: 16, color: Colors.black),
                        onPressed: () {
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        },
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  size: const Size(20, 10),
                  painter: ArrowPainter(color: kActiveColor),
                ),
              ],
            ),
          ),
        );
      },
    );

    TooltipManager.showTooltip(_overlayEntry!);
    if (mounted && context.mounted) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }
  //
  // double _kgToPounds(double kg) => kg * 2.20462;
  // double _poundsToKg(double pounds) => pounds / 2.20462;

  String get displayWeight {
    if (selectedMenu == "KG") {
      return "${weight.toStringAsFixed(1)} kg";
    } else {
      return "${(weight * 2.20462).toStringAsFixed(1)} lbs";
    }
  }

  void _updateSelectedMenu(String? newValue) {
    if (newValue == null) return;
    setState(() {
      if (newValue == "Pound" && selectedMenu == "KG") {
        // Convert current display value to pounds
        displayValue = weight * 2.20462;
      } else if (newValue == "KG" && selectedMenu == "Pound") {
        // Convert current display value to kg
        displayValue = weight;
      }
      selectedMenu = newValue;
    });
  }

  void _updateWeight(dynamic value) {
    setState(() {
      displayValue = value.toDouble();
      weight = selectedMenu == "KG" ? displayValue : displayValue / 2.20462;
    });
    ref.read(bmiProvider.notifier).updateWeight(weight, "KG");
  }

  void _showWeightInputDialog() {
    WeightInputDialog.showWeightInputDialog(
      context,
      displayValue,
      (newValue) {
        setState(() {
          weight = newValue;
          displayValue = selectedMenu == "KG" ? weight : weight * 2.20462;
        });
      },
      selectedMenu,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    TooltipManager.hideTooltip();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _bannerAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    String selectedGender = arguments["gender"];
    double heightInCm = arguments["height"];
    double weightInKg = weight;
    calc = Calculator(height: heightInCm, weight: weightInKg);

    const Color background = kInactiveColor;
    const Color fill = kScaleColor;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 1;
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Scaffold(
      backgroundColor: kBacgroundColor,
      body: SafeArea(
        child: SliderDrawer(
          appBar: SliderAppBar(
            drawerIconColor: kActiveColor,
            drawerIconSize: 35.r,
            appBarPadding: EdgeInsets.fromLTRB(10.r, 20.r, 20.r, 10.r),
            appBarColor: kBacgroundColor,
            title: Container(),
          ),
          key: _sliderDrawerKey,
          slideDirection: SlideDirection.LEFT_TO_RIGHT,
          isDraggable: true,
          sliderOpenSize: MediaQuery.of(context).size.width * 0.75,
          slider: Container(
            decoration: BoxDecoration(
              color: kInactiveColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: const CustomDrawer(),
          ),
          child: Scaffold(
            backgroundColor: kBacgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Text(
                    'Select Weight',
                    style: buildTextStyle(
                      weight: FontWeight.w500,
                      fontSize: 32.sp,
                    ),
                  ),
                  SizedBox(height: 70.h),
                  GestureDetector(
                    key: _weightValueKey,
                    onTap: () {
                      TooltipManager.hideTooltip();
                      _showWeightInputDialog();
                    },
                    child: Text(
                      displayWeight,
                      style: buildTextStyle(
                        weight: FontWeight.bold,
                        fontSize: 60.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomDropdown(
                    value: selectedMenu,
                    items: const ['KG', 'Pound'],
                    onChanged: _updateSelectedMenu,
                    width: MediaQuery.of(context).size.width * 0.35,
                  ),
                  SizedBox(height: 45.h),
                  Container(
                    height: 120.h,
                    width: 392.w,
                    decoration: BoxDecoration(
                      color: kInactiveColor,
                      gradient: LinearGradient(
                        colors: gradient,
                        stops: stops,
                        end: Alignment.center,
                        begin: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Center(
                      child: CustomBox(
                        wheelSlider: WheelSlider(
                          lineColor: kActiveColor,
                          horizontalListWidth: 340.w,
                          horizontalListHeight: 500.h,
                          totalCount: _totalCount,
                          interval: _interval,
                          initValue: displayValue.toInt(),
                          onValueChanged: _updateWeight,
                          pointerColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 135.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        label: "Prev",
                        color: kInactiveColor,
                        textColor: kActiveColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Button(
                        label: "Next",
                        color: kActiveColor,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.pushNamed(context, "result_screen",
                              arguments: {
                                "bmi": calc.bmiValue().toDouble(),
                                "bmiText": calc.bmiText(),
                                "bmiInterpretation": calc.bmiInterpretation(),
                                "gender": selectedGender,
                                "height": arguments["height"],
                                "weight": weightInKg,
                              });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _bannerAdManager.getAdWidget(screenId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
