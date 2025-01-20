import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constant/color/color.dart';
import '../providers/input_dialog_provider.dart';
import '../providers/bmi_provider.dart';

class WeightInputDialog extends ConsumerWidget {
  final String selectedUnit;
  final Function(double) onValueChanged;
  final double currentValue;

  const WeightInputDialog({
    super.key,
    required this.selectedUnit,
    required this.onValueChanged,
    required this.currentValue,
  });

  static void showWeightInputDialog(
    BuildContext context,
    double currentValue,
    Function(double) onValueChanged,
    String selectedUnit,
  ) {
    showDialog(
      context: context,
      builder: (context) => WeightInputDialog(
        selectedUnit: selectedUnit,
        onValueChanged: onValueChanged,
        currentValue: currentValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightNotifier = ref.read(weightInputProvider.notifier);
    final displayValue = weightNotifier.getDisplayValue(selectedUnit);

    final controller = TextEditingController(
      text: currentValue.toStringAsFixed(1),
    );

    return AlertDialog(
      backgroundColor: kBacgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Enter Weight',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              suffixText: selectedUnit == "KG" ? "kg" : "lbs",
              suffixStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kActiveColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: kActiveColor),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: kActiveColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  final newValue = double.tryParse(controller.text);
                  if (newValue != null) {
                    final valueInKg =
                        selectedUnit == "Pound" ? newValue / 2.20462 : newValue;
                    onValueChanged(valueInKg);
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
          ),
        ],
      ),
    );
  }
}
