import 'package:bmi_calclutor/screen/gender_screen.dart';
import 'package:bmi_calclutor/screen/height_screen.dart';
import 'package:bmi_calclutor/screen/result_screen.dart';
import 'package:bmi_calclutor/screen/weight_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
      initialRoute: "height_screen",
      routes:{
  "gender_screen":(context) => GenderScreen(),
        "height_screen":(context) => HeightScreen(),
        "weight_screen":(context) => WeightScreen(),
        "result_screen":(context) => ResultScreen(),


      } ,
    );
  }
}

