import 'package:bmi_calclutor/constant/color/color.dart';
import 'package:bmi_calclutor/constant/enum_gender_file.dart';
import 'package:flutter/material.dart';

import '../constant/text_style.dart';
import '../widget/button.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  @override
  Color maleCardColor = kInactiveColor;
  Color femaleCardColor = kInactiveColor;
  Color transgenderCardColor = kInactiveColor;
  Color maleTextColor = kActiveColor;
  Color femaleTextColor = kActiveColor;
  Color transgenderTextColor = kActiveColor;

  void updateCardColor() {
    if (selectedGender == gender.male) {
      transgenderCardColor = kInactiveColor;
      femaleCardColor = kInactiveColor;
      maleCardColor = kActiveColor;
      maleTextColor = kInactiveColor;
      femaleTextColor = kActiveColor;
      transgenderTextColor = kActiveColor;
    }
    if (selectedGender == gender.female) {
      transgenderCardColor = kInactiveColor;
      femaleCardColor = kActiveColor;
      maleCardColor = kInactiveColor;
      maleTextColor = kActiveColor;
      femaleTextColor = kInactiveColor;
      transgenderTextColor = kActiveColor;
    }
    if (selectedGender == gender.transgender) {
      transgenderCardColor = kActiveColor;
      femaleCardColor = kInactiveColor;
      maleCardColor = kInactiveColor;
      maleTextColor = kActiveColor;
      femaleTextColor = kActiveColor;
      transgenderTextColor = kInactiveColor;
    }
  }

  late gender selectedGender;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBacgroundColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.notes_outlined,
                  color: kActiveColor,
                  size: 40,
                ),
                Icon(
                  Icons.apps,
                  color: kActiveColor,
                  size: 40,
                )
              ],
            ),
          ),
          Text(
            "Select gender",
            style: buildTextStyle(fontSize: 30, weight: FontWeight.w500),
          ),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
              onTap: () => setState(() {
                    selectedGender = gender.male;
                    updateCardColor();
                  }),
              child: GenderContainer(
                label: 'Male',
                gendericon: Icons.male,
                cardColor: maleCardColor,
                textColor: maleTextColor,
                iconColor: maleTextColor,
              )),
          GestureDetector(
              onTap: () => setState(() {
                    selectedGender = gender.female;
                    updateCardColor();
                  }),
              child: GenderContainer(
                label: 'Female',
                gendericon: Icons.female,
                cardColor: femaleCardColor,
                textColor: femaleTextColor,
                iconColor: femaleTextColor,
              )),
          GestureDetector(
              onTap: () => setState(() {
                    selectedGender = gender.transgender;
                    updateCardColor();
                  }),
              child: GenderContainer(
                iconColor: transgenderTextColor,
                label: 'Others',
                gendericon: Icons.transgender,
                cardColor: transgenderCardColor,
                textColor: transgenderTextColor,
              )),
          SizedBox(
            height: 20,
          ),
          Button(
              context: context,
              label: "Next",
              routeName: "height_screen",
              color: kActiveColor,
              textColor: Colors.black)
        ]),
      ),
    );
  }
}

class GenderContainer extends StatelessWidget {
  String label;
  IconData gendericon;
  Color cardColor;
  Color textColor;
  Color iconColor;
  GenderContainer(
      {required this.label,
      required this.gendericon,
      required this.cardColor,
      required this.textColor,
      required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        height: 173,
        width: 173,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(70)),
          color: cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              gendericon,
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
