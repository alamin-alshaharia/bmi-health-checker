import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdWidget extends StatefulWidget {
  final BannerAd ad;

  const CustomAdWidget({
    super.key,
    required this.ad,
  });

  @override
  State<CustomAdWidget> createState() => _CustomAdWidgetState();
}

class _CustomAdWidgetState extends State<CustomAdWidget> {
  @override
  Widget build(BuildContext context) {
    return AdWidget(ad: widget.ad);
  }
}
