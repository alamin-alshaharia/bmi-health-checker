import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static SharedPreferences? _preferences;

  static const String keyHeightTooltip = 'height_tooltip_shown';
  static const String keyWeightTooltip = 'weight_tooltip_shown';
  static const String keyGenderTooltip = 'gender_tooltip_shown';
  static const String keySaveShareRewardTime = 'save_share_reward_time';

  static Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<bool> isFirstTime(String key) async {
    await initialize();
    return _preferences?.getBool(key) ?? true;
  }

  static Future<void> markTooltipShown(String key) async {
    await initialize();
    if (_preferences != null) {
      await _preferences!.setBool(key, false);
    }
  }

  static Future<void> resetAllTooltips() async {
    await initialize();
    if (_preferences != null) {
      await Future.wait([
        _preferences!.setBool(keyHeightTooltip, true),
        _preferences!.setBool(keyWeightTooltip, true),
        _preferences!.setBool(keyGenderTooltip, true),
      ]);
    }
  }

  static Future<bool> canUseSaveShareFeature() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRewardTime = prefs.getInt(keySaveShareRewardTime);

    if (lastRewardTime == null) return false;

    final lastRewardDateTime =
        DateTime.fromMillisecondsSinceEpoch(lastRewardTime);
    final now = DateTime.now();
    final difference = now.difference(lastRewardDateTime);

    return difference.inHours < 24;
  }

  static Future<void> updateSaveShareRewardTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        keySaveShareRewardTime, DateTime.now().millisecondsSinceEpoch);
  }

  static void dispose() {
    _preferences = null;
  }
}
