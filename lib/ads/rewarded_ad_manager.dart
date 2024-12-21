import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_constants.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;

  RewardedAdManager() {
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdConstants.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          print('RewardedAd loaded successfully');
          _setRewardedAdCallbacks(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void _setRewardedAdCallbacks(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('RewardedAd shown.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _loadRewardedAd(); // Load a new ad for next time
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('RewardedAd failed to show: $error');
        ad.dispose();
        _loadRewardedAd(); // Load a new ad for next time
      },
    );
  }

  void showAd(Function onRewarded) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('User earned a reward: ${reward.amount} ${reward.type}');
        onRewarded(); // Call the reward function
      });
    } else {
      print('RewardedAd is not ready yet.');
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
