import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;

  const Button({
    Key? key,
    required this.label,
    required this.color,
    required this.textColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(color: textColor),
          backgroundColor: color,
          fixedSize: Size(150, 60)),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
