import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constant/color/color.dart';

class HeightInputDialog extends ConsumerWidget {
  final String selectedUnit;
  final Function(double) onValueChanged;
  final double currentValue;

  const HeightInputDialog({
    super.key,
    required this.selectedUnit,
    required this.onValueChanged,
    required this.currentValue,
  });

  static void showHeightInputDialog(
    BuildContext context,
    double currentValue,
    Function(double) onValueChanged,
    String selectedUnit,
  ) {
    showDialog(
      context: context,
      builder: (context) => HeightInputDialog(
        selectedUnit: selectedUnit,
        onValueChanged: onValueChanged,
        currentValue: currentValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feetController = TextEditingController();
    final inchesController = TextEditingController();
    final singleValueController = TextEditingController();

    if (selectedUnit == "Feet") {
      final totalFeet = currentValue / 30.48;
      final feet = totalFeet.floor();
      final inches = ((totalFeet - feet) * 12).toStringAsFixed(1);
      feetController.text = feet.toString();
      inchesController.text = inches;
    } else {
      double displayValue;
      switch (selectedUnit) {
        case "Inch":
          displayValue = currentValue / 2.54;
          break;
        case "Meter":
          displayValue = currentValue / 100;
          break;
        case "Cm":
          displayValue = currentValue;
          break;
        default:
          displayValue = currentValue;
      }
      singleValueController.text = displayValue.toStringAsFixed(1);
    }

    return AlertDialog(
      backgroundColor: kBacgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Enter Height',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedUnit == "Feet") ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: feetController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter feet",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixText: 'ft',
                      suffixStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kActiveColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: inchesController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter inches",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixText: 'in',
                      suffixStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kActiveColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else
            TextField(
              controller: singleValueController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Height in ${selectedUnit.toLowerCase()}',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixText: selectedUnit == "Cm" ? "cm" : "in",
                suffixStyle: const TextStyle(color: Colors.white),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kActiveColor),
                ),
              ),
            ),
          const SizedBox(height: 20),
          _buildActionButtons(
            context,
            feetController,
            inchesController,
            singleValueController,
            ref,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TextEditingController feetController,
    TextEditingController inchesController,
    TextEditingController singleValueController,
    WidgetRef ref,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            backgroundColor: kInactiveColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: kActiveColor),
          ),
        ),
        TextButton(
          onPressed: () {
            double? newValue;
            if (selectedUnit == "Feet") {
              final feet = int.tryParse(feetController.text) ?? 0;
              final inches = double.tryParse(inchesController.text) ?? 0.0;
              newValue = (feet + (inches / 12)) * 30.48;
            } else {
              newValue = double.tryParse(singleValueController.text);
              if (newValue != null) {
                switch (selectedUnit) {
                  case "Inch":
                    newValue *= 2.54;
                    break;
                  case "Meter":
                    newValue *= 100;
                    break;
                  case "Cm":
                    // Already in cm
                    break;
                }
              }
            }
            if (newValue != null) {
              onValueChanged(newValue);
            }
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: kActiveColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
