import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_constants.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;

  InterstitialAdManager() {
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    // print('Attempting to load interstitial ad.');
    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          // print('InterstitialAd loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          // print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showAd() {
    // print('showAd called.');
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Set to null after showing
      _loadInterstitialAd(); // Load a new ad for next time
      // print('InterstitialAd shown.');
    } else {
      // print('InterstitialAd is not ready yet.');
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
