import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:bmi_health_checker/ads/interstitial_ad_manager.dart';
import 'package:bmi_health_checker/ads/ad_constants.dart'; // Import AdConstants

class InterstitialAdWidget extends StatefulWidget {
  final Widget child;

  const InterstitialAdWidget({Key? key, required this.child}) : super(key: key);

  @override
  _InterstitialAdWidgetState createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  InterstitialAd? _interstitialAd;
  bool _isAdShown = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
          });
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null && !_isAdShown) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          _isAdShown = true;
          print('InterstitialAd shown.');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad for next time
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('InterstitialAd failed to show: $error');
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad for next time
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
