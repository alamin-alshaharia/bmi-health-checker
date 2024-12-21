import 'package:bmi_health_checker/constant/color/color.dart';
import 'package:bmi_health_checker/constant/enum_gender_file.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constant/text_style.dart';
import '../widget/button.dart';
import '../widget/ad_widget.dart';
import '../ads/ad_constants.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  late gender selectedGender = gender.male;
  late BannerAd _bannerAd;

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

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdConstants.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            // Ad loaded successfully
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
        },
      ),
      size: AdSize.banner,
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBacgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 7),
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
            const SizedBox(
              height: 15,
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
            const SizedBox(
              height: 20,
            ),
            Button(
              label: "Next",
              color: kActiveColor,
              textColor: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, "height_screen", arguments: {
                  "gender": selectedGender.toString(),
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomAdWidget(ad: _bannerAd),
          ]),
        ),
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
          borderRadius: const BorderRadius.all(Radius.circular(70)),
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
