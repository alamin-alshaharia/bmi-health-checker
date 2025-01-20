import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:bmi_health_checker/ads/banner_ad_manager.dart'; // Import the BannerAdManager

import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../constant/color/color.dart';
import '../constant/text_style.dart';
import '../widget/button.dart';
import '../widget/custom_box.dart';

import '../widget/custom_drawer.dart';

import '../widget/arrow_painter.dart';
import '../utils/tooltip_manager.dart';
import '../widget/custom_dropdown.dart';
import '../widget/height_input_dialog.dart';
import '../utils/preferences_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bmi_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeightScreen extends ConsumerStatefulWidget {
  const HeightScreen({super.key});

  @override
  ConsumerState<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends ConsumerState<HeightScreen>
    with WidgetsBindingObserver {
  String selectedMenu = "Feet";
  final _totalCount = 5000;
  // final double _initValue = 152.4;
  double height = 152.4;

  double get interval {
    switch (selectedMenu) {
      case "Feet":
        return 0.1;
      case "Inch":
        return 0.5;
      case "Meter":
        return 0.01;
      case "Cm":
        return 1.0;
      default:
        return 0.1;
    }
  }

  double get _sliderValue {
    switch (selectedMenu) {
      case "Feet":
        return height / 30.48;
      case "Inch":
        return height / 2.54;
      case "Meter":
        return height / 100;
      case "Cm":
        return height;
      default:
        return height;
    }
  }

  void _onWheelSliderValueChanged(dynamic val) {
    if (val == null) return;

    setState(() {
      final doubleValue = val is int ? val.toDouble() : val as double;
      switch (selectedMenu) {
        case "Feet":
          height = doubleValue * 30.48;
          break;
        case "Inch":
          height = doubleValue * 2.54;
          break;
        case "Meter":
          height = doubleValue * 100;
          break;
        case "Cm":
          height = doubleValue;
          break;
      }
    });
    // Update provider
    ref.read(bmiProvider.notifier).updateHeight(height);
  }

  late BannerAdManager _bannerAdManager;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  bool _showTooltip = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _heightValueKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bannerAdManager = BannerAdManager();
    _initializeScreen();
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
        PreferencesManager.keyHeightTooltip)) {
      setState(() {
        _showTooltip = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlayTooltip();
      });

      await PreferencesManager.markTooltipShown(
          PreferencesManager.keyHeightTooltip);
    }
  }

  void _showOverlayTooltip() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final RenderBox? renderBox =
            _heightValueKey.currentContext?.findRenderObject() as RenderBox?;
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

  void _updateSelectedMenu(String? newValue) {
    if (newValue == null || newValue == selectedMenu) return;
    setState(() {
      selectedMenu = newValue;
    });
  }

  String get displayHeight {
    switch (selectedMenu) {
      case "Feet":
        double totalFeet = height / 30.48;
        return totalFeet.toStringAsFixed(2);
      case "Inch":
        return (height / 2.54).toStringAsFixed(2);
      case "Meter":
        return (height / 100).toStringAsFixed(2);
      case "Cm":
        return height.toStringAsFixed(2);
      default:
        return height.toStringAsFixed(2);
    }
  }

  void _showHeightInputDialog() {
    HeightInputDialog.showHeightInputDialog(
      context,
      height, // Pass the height in cm
      (newValue) {
        setState(() {
          height = newValue; // newValue is already in cm
        });
        ref.read(bmiProvider.notifier).updateHeight(height); // Update provider
      },
      selectedMenu,
    );
  }

  void _updateHeight(dynamic value) {
    setState(() {
      switch (selectedMenu) {
        case "Feet":
          height = value * 30.48;
          break;
        case "Inch":
          height = value * 2.54;
          break;
        case "Meter":
          height = value * 100;
          break;
        case "Cm":
          height = value;
          break;
      }
    });
    ref.read(bmiProvider.notifier).updateHeight(height);
  }

  void _navigateToNext(String gender) {
    Navigator.pushNamed(context, "weight_screen", arguments: {
      "height": height,
      "gender": gender,
    });
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
    String gender = arguments["gender"] ?? "Not specified";

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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 35.w),
                        child: Column(
                          children: [
                            SizedBox(height: 90.h),
                            Text(
                              'Select Height ',
                              style: buildTextStyle(
                                weight: FontWeight.w500,
                                fontSize: 27.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              key: _heightValueKey,
                              onTap: () {
                                TooltipManager.hideTooltip();
                                _showHeightInputDialog();
                              },
                              child: Text(
                                displayHeight,
                                style: buildTextStyle(
                                  weight: FontWeight.bold,
                                  fontSize: 60.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomDropdown(
                              value: selectedMenu,
                              items: const ['Feet', 'Inch', 'Meter', 'Cm'],
                              onChanged: _updateSelectedMenu,
                              width: MediaQuery.of(context).size.width * 0.35,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 31.w, top: 35.h),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            height: 102.h,
                            width: 550.w,
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
                                  horizontalListWidth: 490.w,
                                  horizontalListHeight: 500.h,
                                  interval: interval,
                                  totalCount: _totalCount,
                                  initValue: _sliderValue,
                                  onValueChanged: _onWheelSliderValueChanged,
                                  hapticFeedbackType:
                                      HapticFeedbackType.vibrate,
                                  pointerColor: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 37.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        label: "Prev",
                        color: kActiveColor,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Button(
                        label: "Next",
                        color: kActiveColor,
                        textColor: Colors.black,
                        onPressed: () {
                          _navigateToNext(gender);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _bannerAdManager.getAdWidget(context.toString()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
