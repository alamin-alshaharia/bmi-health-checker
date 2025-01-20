import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'ad_constants.dart';

class BannerAdManager {
  final Map<String, BannerAd> _bannerAds = {};
  final Set<String> _loadingAds = {};
  bool _isDisposed = false;

  void _loadBannerAd(String screenId) {
    if (_loadingAds.contains(screenId) || _isDisposed) return;
    _loadingAds.add(screenId);

    _bannerAds[screenId]?.dispose();

    final bannerAd = BannerAd(
      adUnitId: AdConstants.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _loadingAds.remove(screenId);
        },
        onAdFailedToLoad: (ad, error) {
          _loadingAds.remove(screenId);
          ad.dispose();
          _bannerAds.remove(screenId);

          if (!_isDisposed) {
            Future.delayed(
                const Duration(seconds: 30), () => _loadBannerAd(screenId));
          }
        },
      ),
    );

    _bannerAds[screenId] = bannerAd;
    bannerAd.load();
  }

  Widget getAdWidget(String screenId) {
    if (!_bannerAds.containsKey(screenId)) {
      _loadBannerAd(screenId);
    }

    final bannerAd = _bannerAds[screenId];
    if (_isDisposed || bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }

  void dispose() {
    _isDisposed = true;
    for (final ad in _bannerAds.values) {
      ad.dispose();
    }
    _bannerAds.clear();
    _loadingAds.clear();
  }
}
