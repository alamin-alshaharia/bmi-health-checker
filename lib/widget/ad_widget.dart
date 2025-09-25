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
  final bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    widget.ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.ad.size.width.toDouble(),
      height: widget.ad.size.height.toDouble(),
      child: AdWidget(ad: widget.ad),
    );
  }
}
