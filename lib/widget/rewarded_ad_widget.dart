import 'package:flutter/material.dart';
import 'package:bmi_health_checker/ads/rewarded_ad_manager.dart';

class RewardedAdWidget extends StatefulWidget {
  final Widget child;
  @override
  final GlobalKey<RewardedAdWidgetState> key;

  const RewardedAdWidget({required this.child, required this.key})
      : super(key: key);

  @override
  RewardedAdWidgetState createState() => RewardedAdWidgetState();
}

class RewardedAdWidgetState extends State<RewardedAdWidget> {
  late RewardedAdManager _rewardedAdManager;

  @override
  void initState() {
    super.initState();
    _rewardedAdManager = RewardedAdManager();
  }

  @override
  void dispose() {
    _rewardedAdManager.dispose();
    super.dispose();
  }

  void loadAndShowAd(Function onRewarded) {
    _rewardedAdManager.showAd(() {
      // Call the reward function after the ad is watched
      onRewarded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        loadAndShowAd(() {
          // Define what happens when the user earns a reward
          // print('User earned a reward!');
          // You can add your logic here, e.g., saving the result
        });
      },
      child: widget.child, // Display the child widget
    );
  }
}
