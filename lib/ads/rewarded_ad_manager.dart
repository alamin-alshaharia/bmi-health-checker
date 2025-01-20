import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_constants.dart';
import 'package:flutter/foundation.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  RewardedAdManager() {
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          // print('RewardedAd loaded successfully');
          _setRewardedAdCallbacks(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          // print('RewardedAd failed to load: $error');
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
      onAdFailedToLoad?.call();
      return;
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
    if (_isLoading) return;
    _isLoading = true;

    RewardedAd.load(
      adUnitId: AdConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          // print('Rewarded ad failed to load: $error');
          _rewardedAd = null;
          _isLoading = false;
        },
      ),
    );
  }
}
