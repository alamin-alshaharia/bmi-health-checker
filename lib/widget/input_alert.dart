import 'package:flutter/material.dart';
import '../constant/color/color.dart';

class InputAlertDialog {
  static void showHeightInputDialog(BuildContext context, double currentHeight,
      Function(double) onHeightChanged) {
    TextEditingController heightController = TextEditingController();
    heightController.text = currentHeight.toString(); // Set current height

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: Container(
            color: kInactiveColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Height',
                  style: TextStyle(
                    fontSize: 24,
                    color: kActiveColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(color: kActiveColor, fontSize: 25),
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Height in cm",
                    hintStyle: TextStyle(color: kActiveColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: kActiveColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: kActiveColor),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kActiveColor,
                      ),
                      onPressed: () {
                        double? newHeight =
                            double.tryParse(heightController.text);
                        if (newHeight != null) {
                          onHeightChanged(
                              newHeight); // Call the height change function
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
