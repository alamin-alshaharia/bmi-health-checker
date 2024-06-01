import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:wheel_slider/wheel_slider.dart';

import '../constant/color/color.dart';
import '../constant/text_style.dart';
import '../widget/button.dart';
import '../widget/custom_box.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  String selectedMenu = "KG";

  final int _totalCount = 200;
  final int _initValue = 50;
  int _currentValue = 50;

  List<String> dropdown = ["Feet", "Inch"];
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
          body: Column(children: [
            Padding(
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
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      SizedBox(height: 90),
                      Text(
                        'Select Height ',
                        style:
                            buildTextStyle(weight: FontWeight.w500, fontSize: 28),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _currentValue.toString(),
                        style:
                            buildTextStyle(weight: FontWeight.bold, fontSize: 60),
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
                                  style: buildTextStyle(
                                      weight: FontWeight.w500, fontSize: 15),
                                ),
                                value: 'KG',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Metric',
                                  style: buildTextStyle(
                                      weight: FontWeight.w500, fontSize: 15),
                                ),
                                value: 'Metric',
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
                RotatedBox(quarterTurns: 1,
                  child: Container(

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
                          initValue: _initValue,
                          onValueChanged: (val) {
                            setState(() {
                              _currentValue = val;
                            });
                          },
                          hapticFeedbackType: HapticFeedbackType.vibrate,
                          pointerColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 180,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                    textColor: kActiveColor,
                    context: context,
                    label: "Prev",
                    routeName: "weight_screen",
                    color: kInactiveColor),
                Button(
                    textColor: Colors.black,
                    context: context,
                    label: "Next",
                    routeName: "result_screen",
                    color: kActiveColor)
              ],
            ),
            // Text(_nCurrentValue.toString(),style: TextStyle(color: kActiveColor),),
          ])),
    );
  }
}
