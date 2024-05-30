import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:bmi_calclutor/constant/color/color.dart';
class CustomBox extends StatelessWidget {

  final WheelSlider wheelSlider;


  const CustomBox(
      {
      required this.wheelSlider,
     })
      ;

  @override
  Widget build(BuildContext context) {
    return Container(

      child:

          wheelSlider,


    );
  }
}
