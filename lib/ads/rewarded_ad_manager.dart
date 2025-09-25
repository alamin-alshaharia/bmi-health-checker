import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_constants.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _usingFallback = false;
  int _loadAttempts = 0;

  RewardedAdManager() {
    _loadRewardedAd();
  }

  void _loadRewardedAd({bool useFallback = false}) {
    if (_isLoading) return;
    _isLoading = true;

    final adUnitId = useFallback
        ? AdConstants.fallbackRewardedAdUnitId
        : AdConstants.rewardedAdUnitId;

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isLoading = false;
          _usingFallback = useFallback;
          _loadAttempts = 0;
          if (useFallback) {
            print('Fallback rewarded ad loaded successfully');
          }
          _setRewardedAdCallbacks(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoading = false;
          _loadAttempts++;
          print('RewardedAd failed to load (attempt $_loadAttempts): $error');

          if (!useFallback && _loadAttempts < 3) {
            // Try fallback ad when primary fails
            print('Trying fallback rewarded ad');
            Future.delayed(const Duration(seconds: 2),
                () => _loadRewardedAd(useFallback: true));
          } else if (useFallback && _loadAttempts < 5) {
            // Retry primary after fallback fails
            print('Fallback also failed, retrying primary rewarded ad');
            Future.delayed(const Duration(seconds: 5),
                () => _loadRewardedAd(useFallback: false));
          } else {
            // Reset attempts and try again later
            _loadAttempts = 0;
            Future.delayed(const Duration(seconds: 30),
                () => _loadRewardedAd(useFallback: false));
          }
        },
      ),
    );
  }

  void _setRewardedAdCallbacks(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        // print('RewardedAd shown.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _loadRewardedAd(); // Load a new ad for next time
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        // print('RewardedAd failed to show: $error');
        ad.dispose();
        _loadRewardedAd(); // Load a new ad for next time
      },
    );
  }

  void showAd(VoidCallback onRewarded, {VoidCallback? onAdFailedToLoad}) {
    if (_rewardedAd == null) {
      // Try to load an ad immediately if none is available
      _loadRewardedAd();
      onAdFailedToLoad?.call();
      return;
    }

    if (_usingFallback) {
      print('Showing fallback rewarded ad');
    }

    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        onRewarded();
      },
    );
  }

  void dispose() {
    _rewardedAd?.dispose();
  }

  void loadAd() {
    _loadRewardedAd();
  }
}
