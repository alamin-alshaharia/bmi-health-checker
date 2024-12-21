import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import '../widget/ad_widget.dart';
import 'ad_constants.dart';

class BannerAdManager {
  late BannerAd _bannerAd;

  BannerAdManager() {
    _loadBannerAd(AdConstants.bannerAdUnitId);
  }

  void _loadBannerAd(String adUnitId) {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('BannerAd loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
        },
      ),
      size: AdSize.banner,
    )..load();
  }

  Widget getAdWidget() {
    return CustomAdWidget(ad: _bannerAd);
  }

  void refreshAd() {
    _bannerAd.dispose();
    _loadBannerAd(AdConstants.bannerAdUnitId);
  }

  void dispose() {
    _bannerAd.dispose();
  }
}
