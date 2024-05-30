import 'package:flutter/material.dart';

ElevatedButton Button({required BuildContext context,required String label,required String routeName,required Color color,required Color textColor}) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context,  routeName);
    },
    child: Text(label),
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(color:textColor ),
        backgroundColor: color, fixedSize: Size(150, 60)),
  );
}
