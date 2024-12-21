import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constant/color/color.dart'; // Import the color constants

class BmiHistoryGraphWidget extends StatelessWidget {
  final List<double> bmiData; // List of BMI values
  final List<String> dates; // Corresponding dates for the BMI values

  const BmiHistoryGraphWidget({
    Key? key,
    required this.bmiData,
    required this.dates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    dates[value.toInt()],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey, width: 1),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
              );
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _getChartData(),
              isCurved: true,
              // color: [kActiveColor], // Use the active color from color.dart
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
              aboveBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((spot) {
                  return LineTooltipItem(
                    'BMI: ${spot.y.toStringAsFixed(1)}\nDate: ${dates[spot.x.toInt()]}',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getChartData() {
    return List.generate(bmiData.length, (index) {
      return FlSpot(index.toDouble(), bmiData[index]);
    });
  }
}
