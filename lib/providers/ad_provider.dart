import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ads/banner_ad_manager.dart';
import '../ads/interstitial_ad_manager.dart';
import '../ads/rewarded_ad_manager.dart';

final bannerAdProvider = Provider.autoDispose<BannerAdManager>((ref) {
  final manager = BannerAdManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

final interstitialAdProvider = Provider<InterstitialAdManager>((ref) {
  final manager = InterstitialAdManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

final rewardedAdProvider = Provider<RewardedAdManager>((ref) {
  final manager = RewardedAdManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});
