import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_constants.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _usingFallback = false;
  bool _isLoading = false;
  int _loadAttempts = 0;

  InterstitialAdManager() {
    _loadInterstitialAd();
  }

  void _loadInterstitialAd({bool useFallback = false}) {
    if (_isLoading) return;
    _isLoading = true;

    final adUnitId = useFallback
        ? AdConstants.fallbackInterstitialAdUnitId
        : AdConstants.interstitialAdUnitId;

    print(
        'Attempting to load ${useFallback ? 'fallback' : 'primary'} interstitial ad.');
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isLoading = false;
          _usingFallback = useFallback;
          _loadAttempts = 0;
          if (useFallback) {
            print('Fallback interstitial ad loaded successfully');
          } else {
            print('Primary interstitial ad loaded successfully');
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoading = false;
          _loadAttempts++;
          print(
              'InterstitialAd failed to load (attempt $_loadAttempts): $error');

          if (!useFallback && _loadAttempts < 3) {
            // Try fallback ad when primary fails
            print('Trying fallback interstitial ad');
            Future.delayed(const Duration(seconds: 2),
                () => _loadInterstitialAd(useFallback: true));
          } else if (useFallback && _loadAttempts < 5) {
            // Retry primary after fallback fails
            print('Fallback also failed, retrying primary interstitial ad');
            Future.delayed(const Duration(seconds: 5),
                () => _loadInterstitialAd(useFallback: false));
          } else {
            // Reset attempts and try again later
            _loadAttempts = 0;
            Future.delayed(const Duration(seconds: 30),
                () => _loadInterstitialAd(useFallback: false));
          }
        },
      ),
    );
  }

  void showAd() {
    print('showAd called.');
    if (_interstitialAd != null) {
      if (_usingFallback) {
        print('Showing fallback interstitial ad');
      } else {
        print('Showing primary interstitial ad');
      }
      _interstitialAd!.show();
      _interstitialAd = null; // Set to null after showing
      _loadInterstitialAd(); // Load a new ad for next time
    } else {
      print('InterstitialAd is not ready yet.');
      // Try to load an ad immediately if none is available
      _loadInterstitialAd();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
