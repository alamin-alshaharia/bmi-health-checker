
import"package:flutter/material.dart";

import "color/color.dart";
TextStyle buildTextStyle({required FontWeight weight,required double fontSize}) {
  return TextStyle(
      fontWeight: weight, color: kActiveColor, fontSize: fontSize);
}
