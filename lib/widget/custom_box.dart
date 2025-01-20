import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';

class CustomBox extends StatelessWidget {
  final WheelSlider wheelSlider;

  const CustomBox({
    super.key,
    required this.wheelSlider,
  });

  @override
  Widget build(BuildContext context) => wheelSlider;
}
