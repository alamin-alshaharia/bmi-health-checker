import "package:flutter/material.dart";

import "color/color.dart";

TextStyle buildTextStyle({
  required double fontSize,
  required FontWeight weight,
  Color? color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: weight,
    fontFamily: "Poppins",
    color: color ?? kActiveColor,
  );
}
