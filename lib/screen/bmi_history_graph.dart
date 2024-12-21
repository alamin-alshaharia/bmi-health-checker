import 'package:flutter/material.dart';
import '../widget/bmi_history_graph_widget.dart'; // Import the graph widget

class BmiHistoryGraphScreen extends StatelessWidget {
  const BmiHistoryGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    List<double> bmiData = [
      22.5,
      23.0,
      24.5,
      25.0,
      23.5
    ]; // Replace with actual data
    List<String> dates = [
      '2023-01-01',
      '2023-01-15',
      '2023-02-01',
      '2023-02-15',
      '2023-03-01',
    ]; // Replace with actual dates

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History Graph'),
      ),
      body: Center(
        child: BmiHistoryGraphWidget(
          bmiData: bmiData,
          dates: dates,
        ),
      ),
    );
  }
}
