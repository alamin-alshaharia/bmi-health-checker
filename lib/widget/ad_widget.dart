import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdWidget extends StatefulWidget {
  final BannerAd ad;

  CustomAdWidget({Key? key, required this.ad}) : super(key: key);

  @override
  _CustomAdWidgetState createState() => _CustomAdWidgetState();
}

class _CustomAdWidgetState extends State<CustomAdWidget> {
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _isBannerAdReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Container(
            height: 50,
            child: AdWidget(ad: widget.ad),
          )
        : SizedBox(height: 50); // Placeholder while loading
  }
}
