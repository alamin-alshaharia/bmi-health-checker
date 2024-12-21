import 'package:bmi_health_checker/constant/enum_gender_file.dart';
import 'package:bmi_health_checker/widget/custom_box.dart';
import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';

import 'package:bmi_health_checker/ads/banner_ad_manager.dart';

import '../Calculator.dart';
import '../constant/color/color.dart';
import '../constant/text_style.dart';
import '../widget/button.dart';

import '../widget/input_alert.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({
    super.key,
  });

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  String selectedMenu = "KG";

  final int _totalCount = 20000;
  final int _initValue = 50;
  final double _interval = 0.1;
  double weight = 50;

  late BannerAdManager _bannerAdManager;

  @override
  void initState() {
    super.initState();
    _bannerAdManager = BannerAdManager();
  }

  @override
  void dispose() {
    _bannerAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    gender selectedGender = arguments["gender"] ?? gender.male;

    double heightInCm = (5 * 30.48) + (4 * 2.54); // 5 ft 4 in to cm
    double weightInKg = selectedMenu == "Pound"
        ? weight * 0.453592
        : weight; // Convert if in pounds

    Calculator calc = Calculator(height: heightInCm, weight: weightInKg);

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
          SizedBox(height: 90),
          Text(
            'Select Weight ',
            style: buildTextStyle(weight: FontWeight.w500, fontSize: 28),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              InputAlertDialog.showHeightInputDialog(context, weight,
                  (newWeight) {
                setState(() {
                  weight = newWeight; // Update weight
                });
              });
            },
            child: Text(
              weight.toStringAsFixed(2),
              style: buildTextStyle(weight: FontWeight.bold, fontSize: 60),
            ),
          ),
          SizedBox(height: 10),
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
                      "KG",
                      style:
                          buildTextStyle(weight: FontWeight.w500, fontSize: 15),
                    ),
                    value: 'KG',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      'Pound',
                      style:
                          buildTextStyle(weight: FontWeight.w500, fontSize: 15),
                    ),
                    value: "Pound",
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMenu = value!;
                    print('Selected weight: $selectedMenu');
                  });
                }),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 120,
            width: 370,
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
                  horizontalListWidth: 340,
                  horizontalListHeight: 500,
                  totalCount: _totalCount,
                  interval: _interval,
                  initValue: _initValue,
                  onValueChanged: (val) {
                    setState(() {
                      weight = val;
                      print('Weight updated: $weight kg');
                    });
                  },
                  pointerColor: Colors.blueAccent,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button(
                label: "Prev",
                color: kInactiveColor,
                textColor: kActiveColor,
                onPressed: () {
                  _bannerAdManager.refreshAd();
                  Navigator.pop(context);
                },
              ),
              Button(
                label: "Next",
                color: kActiveColor,
                textColor: Colors.black,
                onPressed: () {
                  _bannerAdManager.refreshAd();
                  print('Weight before passing to ResultScreen: $weightInKg');
                  Navigator.pushNamed(context, "result_screen", arguments: {
                    "bmi": calc.bmiValue().toDouble(),
                    "bmiText": calc.bmiText(),
                    "bmiInterpretation": calc.bmiInterpretation(),
                    "gender": selectedGender.toString(),
                    "height": arguments["height"],
                    "weight": weightInKg,
                  });
                  print(weight);
                },
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          _bannerAdManager.getAdWidget(),
        ]),
      ),
    ));
  }
}
