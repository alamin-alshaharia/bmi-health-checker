import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;

  const Button({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(color: textColor),
          backgroundColor: color,
          fixedSize: const Size(150, 60)),
      child: Text(
        label,
        style: TextStyle(
            color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
