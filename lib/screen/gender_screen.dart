import 'package:bmi_health_checker/constant/color/color.dart';
import 'package:bmi_health_checker/constant/enum_gender_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/text_style.dart';
import '../widget/button.dart';

import '../widget/custom_drawer.dart';
import '../widget/gender_container.dart';
import '../ads/banner_ad_manager.dart';
import '../widget/arrow_painter.dart';

import '../utils/tooltip_manager.dart';
import '../utils/preferences_manager.dart';
import '../providers/bmi_provider.dart';

class GenderScreen extends ConsumerStatefulWidget {
  const GenderScreen({super.key});

  @override
  ConsumerState<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends ConsumerState<GenderScreen>
    with WidgetsBindingObserver {
  Gender _selectedGender = Gender.male;
  late final BannerAdManager _bannerAdManager;
  final _GenderColors _colors = _GenderColors()..updateColors(Gender.male);
  final GlobalKey _maleGenderKey = GlobalKey();

  bool _showTooltip = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bannerAdManager = BannerAdManager();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _checkFirstTime();
    _loadSavedValues();
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    TooltipManager.hideTooltip();
    _overlayEntry?.remove();
    _bannerAdManager.dispose();
    super.dispose();
  }

  void _updateSelectedGender(Gender gender) {
    if (_selectedGender != gender) {
      setState(() {
        _selectedGender = gender;
        _colors.updateColors(gender);
      });
      ref
          .read(bmiProvider.notifier)
          .updateGender(gender.toString().split('.').last);
    }
  }

  Future<void> _checkFirstTime() async {
    if (await PreferencesManager.isFirstTime(
        PreferencesManager.keyGenderTooltip)) {
      setState(() {
        _showTooltip = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlayTooltip();
      });

      await PreferencesManager.markTooltipShown(
          PreferencesManager.keyGenderTooltip);
    }
  }

  void _navigateToHeightScreen() {
    TooltipManager.hideTooltip();
    Navigator.pushNamed(context, 'height_screen',
        arguments: {"gender": _selectedGender.toString().split('.').last});
  }

  void _showOverlayTooltip() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final RenderBox renderBox =
            _maleGenderKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        return Positioned(
          top: position.dy - 80,
          left: position.dx - 20,
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
                        'Select your gender',
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
    Overlay.of(context).insert(_overlayEntry!);
  }

  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBacgroundColor,
        body: SafeArea(
          child: SliderDrawer(
            appBar: SliderAppBar(
              drawerIconColor: kActiveColor,
              drawerIconSize: 35,
              appBarPadding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
              appBarColor: kBacgroundColor,
              title: Container(),
            ),
            key: _sliderDrawerKey,
            slideDirection: SlideDirection.LEFT_TO_RIGHT,
            isDraggable: true,
            sliderOpenSize: MediaQuery.of(context).size.width * 0.75,
            slider: Container(
              decoration: const BoxDecoration(
                color: kInactiveColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const CustomDrawer(),
            ),
            child: _buildMainContent(),
          ),
        ));
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Select gender",
            style: buildTextStyle(fontSize: 30.sp, weight: FontWeight.w500),
          ),
          SizedBox(height: 15.h),
          _buildGenderOption(
            Gender.male,
            'Male',
            Icons.male,
            _colors.maleCardColor,
            _colors.maleTextColor,
          ),
          _buildGenderOption(
            Gender.female,
            'Female',
            Icons.female,
            _colors.femaleCardColor,
            _colors.femaleTextColor,
          ),
          _buildGenderOption(
            Gender.transgender,
            'Others',
            Icons.transgender,
            _colors.transgenderCardColor,
            _colors.transgenderTextColor,
          ),
          SizedBox(height: 20.h),
          Button(
            label: "Next",
            color: kActiveColor,
            textColor: Colors.black,
            onPressed: () {
              TooltipManager.hideTooltip();
              _navigateToHeightScreen();
            },
          ),
          SizedBox(height: 20.h),
          _bannerAdManager.getAdWidget(context.toString()),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    Gender genderType,
    String label,
    IconData icon,
    Color cardColor,
    Color textColor,
  ) {
    return GestureDetector(
      key: genderType == Gender.male ? _maleGenderKey : null,
      onTap: () {
        _overlayEntry?.remove();
        _updateSelectedGender(genderType);
      },
      child: GenderContainer(
        label: label,
        genderIcon: icon,
        cardColor: cardColor,
        textColor: textColor,
        iconColor: textColor,
      ),
    );
  }
}

class _GenderColors {
  Color maleCardColor = kActiveColor;
  Color femaleCardColor = kInactiveColor;
  Color transgenderCardColor = kInactiveColor;
  Color maleTextColor = kInactiveColor;
  Color femaleTextColor = kActiveColor;
  Color transgenderTextColor = kActiveColor;

  void updateColors(Gender selectedGender) {
    maleCardColor = kInactiveColor;
    femaleCardColor = kInactiveColor;
    transgenderCardColor = kInactiveColor;
    maleTextColor = kActiveColor;
    femaleTextColor = kActiveColor;
    transgenderTextColor = kActiveColor;

    switch (selectedGender) {
      case Gender.male:
        maleCardColor = kActiveColor;
        maleTextColor = kInactiveColor;
        break;
      case Gender.female:
        femaleCardColor = kActiveColor;
        femaleTextColor = kInactiveColor;
        break;
      case Gender.transgender:
        transgenderCardColor = kActiveColor;
        transgenderTextColor = kInactiveColor;
        break;
    }
  }
}
