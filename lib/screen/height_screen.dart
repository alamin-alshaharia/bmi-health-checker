import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:bmi_health_checker/ads/banner_ad_manager.dart'; // Import the BannerAdManager
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../constant/color/color.dart';
import '../constant/text_style.dart';
import '../widget/button.dart';
import '../widget/custom_box.dart';
import '../widget/input_alert.dart'; // Import the InputAlertDialog

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  String selectedMenu = "Feet";

  final _totalCount = 3000;
  final double _initValue = 4.5;
  double height = 4.5;
  double interval = 0.001;
  late BannerAdManager _bannerAdManager; // Use BannerAdManager

  @override
  void initState() {
    super.initState();
    _bannerAdManager = BannerAdManager(); // Initialize the BannerAdManager
  }

  @override
  void dispose() {
    _bannerAdManager.dispose(); // Dispose of the BannerAdManager
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = kInactiveColor;
    final Color fill = kScaleColor;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 1; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return SafeArea(
      child: Scaffold(
          backgroundColor: kBacgroundColor,
          body: SingleChildScrollView(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.notes_outlined,
                      color: kActiveColor,
                      size: 40,
                    ),
                    Icon(
                      Icons.apps,
                      color: kActiveColor,
                      size: 40,
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Column(
                      children: [
                        const SizedBox(height: 90),
                        Text(
                          'Select Height ',
                          style: buildTextStyle(
                              weight: FontWeight.w300, fontSize: 27),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            InputAlertDialog.showHeightInputDialog(
                                context, height, (newHeight) {
                              setState(() {
                                height = newHeight; // Update height
                              });
                            });
                          },
                          child: Text(
                            height.toStringAsFixed(2),
                            style: buildTextStyle(
                              weight: FontWeight.bold,
                              fontSize: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 140,
                          decoration: BoxDecoration(
                            color: kInactiveColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: DropdownButton<String>(
                              dropdownColor: kInactiveColor,
                              alignment: Alignment.center,
                              value: selectedMenu,
                              items: [
                                DropdownMenuItem(
                                  child: Text(
                                    "Feet",
                                    style: buildTextStyle(
                                        weight: FontWeight.w500, fontSize: 15),
                                  ),
                                  value: 'Feet',
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'Inch',
                                    style: buildTextStyle(
                                        weight: FontWeight.w500, fontSize: 15),
                                  ),
                                  value: 'Inch',
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'M',
                                    style: buildTextStyle(
                                        weight: FontWeight.w500, fontSize: 15),
                                  ),
                                  value: 'Cm',
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedMenu = value!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 31, top: 35),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        height: 102,
                        width: 550,
                        decoration: BoxDecoration(
                            color: kInactiveColor,
                            gradient: LinearGradient(
                              colors: gradient,
                              stops: stops,
                              end: Alignment.center,
                              begin: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: CustomBox(
                            wheelSlider: WheelSlider(
                              lineColor: kActiveColor,
                              horizontalListWidth: 490,
                              horizontalListHeight: 500,
                              interval: interval,
                              totalCount: _totalCount,
                              initValue: _initValue,
                              onValueChanged: (val) {
                                setState(() {
                                  height = val;
                                  print(height);
                                });
                              },
                              hapticFeedbackType: HapticFeedbackType.vibrate,
                              pointerColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 37,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    label: "Prev",
                    color: kActiveColor,
                    textColor: Colors.black,
                    onPressed: () {
                      _bannerAdManager.refreshAd(); // Refresh the ad
                      Navigator.pushNamed(context, "gender_screen");
                    },
                  ),
                  Button(
                    label: "Next",
                    color: kActiveColor,
                    textColor: Colors.black,
                    onPressed: () {
                      _bannerAdManager.refreshAd(); // Refresh the ad
                      Navigator.pushNamed(context, "weight_screen", arguments: {
                        "height": (selectedMenu == "Inch"
                                ? height * 2.54
                                : selectedMenu == "Feet"
                                    ? height * 30.48
                                    : height * 100)
                            .toDouble(),
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _bannerAdManager.getAdWidget(), // Display the ad widget
            ]),
          )),
    );
  }
}
