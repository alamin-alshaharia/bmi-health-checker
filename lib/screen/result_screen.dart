import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late double height;
  late double weight;
  @override
  Color normal = Colors.greenAccent;
  Color underWeight = Colors.amber;
  Color overWeight = Colors.redAccent;
  Color obese = Colors.red;

  Color buttonColor() {
    return Colors.white;
  }

  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    var bmi = arguments["bmi"];
    var bmiText = arguments["bmiText"];
    var bmiInterpretation = arguments["bmiInterpretation"];
    print(arguments["bmi"]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ((bmi > 18.5 && bmi < 24.9)
            ? normal
            : (bmi < 18.5)
                ? underWeight
                : (bmi > 25 && bmi < 29.9)
                    ? overWeight
                    : obese),
        body: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: null,
                  // style:
                  //     ButtonStyle(backgroundColor: MaterialStatePropertyAll()),
                  child: Text(
                    "Result ${bmi}",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  )),
            ),
            Text(bmiText.toString()),
            Text(bmiInterpretation.toString())
            // Text(bmiText),
          ],
        ),
      ),
    );
  }
}
