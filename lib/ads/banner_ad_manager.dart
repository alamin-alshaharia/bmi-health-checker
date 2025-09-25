import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_constants.dart';

class BannerAdManager {
  final Map<String, BannerAd> _bannerAds = {};
  final Set<String> _loadingAds = {};
  final Map<String, bool> _usingFallback = {};
  bool _isDisposed = false;

  void _loadBannerAd(String screenId, {bool useFallback = false}) {
    if (_loadingAds.contains(screenId) || _isDisposed) return;
    _loadingAds.add(screenId);

    _bannerAds[screenId]?.dispose();

    final adUnitId = useFallback
        ? AdConstants.fallbackBannerAdUnitId
        : AdConstants.bannerAdUnitId;

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _loadingAds.remove(screenId);
          _usingFallback[screenId] = useFallback;
          if (useFallback) {
            print('Fallback banner ad loaded for screen: $screenId');
          }
        },
        onAdFailedToLoad: (ad, error) {
          _loadingAds.remove(screenId);
          ad.dispose();
          _bannerAds.remove(screenId);

          if (!_isDisposed) {
            if (!useFallback) {
              // Try fallback ad immediately when primary fails
              print(
                  'Primary banner ad failed, trying fallback for screen: $screenId');
              Future.delayed(const Duration(seconds: 2),
                  () => _loadBannerAd(screenId, useFallback: true));
            } else {
              // Both primary and fallback failed, retry primary after delay
              print(
                  'Fallback banner ad also failed for screen: $screenId, retrying primary');
              Future.delayed(
                  const Duration(seconds: 30), () => _loadBannerAd(screenId));
            }
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
      // Show a placeholder/default ad space when ad is not available
      return _buildDefaultAdPlaceholder();
    }

    return SizedBox(
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }

  Widget _buildDefaultAdPlaceholder() {
    return Container(
      width: 320,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ads_click, color: Colors.grey[600], size: 20),
            Text(
              'Ad Space',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
