import 'package:flutter/material.dart';

class GenderContainer extends StatelessWidget {
  final String label;
  final IconData genderIcon;
  final Color cardColor;
  final Color textColor;
  final Color iconColor;

  const GenderContainer({
    super.key,
    required this.label,
    required this.genderIcon,
    required this.cardColor,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightRatio = size.height / 926;
    double widthRatio = size.width / 428;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        height: 173 * heightRatio,
        width: 173 * widthRatio,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(70)),
          color: cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              genderIcon,
              size: 60,
              color: iconColor,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
                color: textColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
