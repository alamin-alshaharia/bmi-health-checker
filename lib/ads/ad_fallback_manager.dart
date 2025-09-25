import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class AdFallbackManager {
  static final AdFallbackManager _instance = AdFallbackManager._internal();
  factory AdFallbackManager() => _instance;
  AdFallbackManager._internal();

  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Initialize the fallback manager with connectivity monitoring
  void initialize() {
    _checkConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _isConnected = results.first != ConnectivityResult.none;
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isConnected = result.first != ConnectivityResult.none;
    } catch (e) {
      _isConnected = false;
    }
  }

  /// Check if we should use fallback ads
  bool shouldUseFallback() {
    return !_isConnected;
  }

  /// Get appropriate ad unit ID with fallback logic
  String getAdUnitId(String primaryId, String fallbackId) {
    return shouldUseFallback() ? fallbackId : primaryId;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
