import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class GPUResourceManager {
  static final GPUResourceManager _instance = GPUResourceManager._internal();
  factory GPUResourceManager() => _instance;

  GPUResourceManager._internal();

  bool _isOptimized = false;

  void optimizeGPUUsage() {
    if (_isOptimized) return;

    // Optimize rendering pipeline
    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;

    // Reduce GPU pressure
    SchedulerBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIChangeCallback((bool systemOverlaysAreVisible) {
        return Future.value(systemOverlaysAreVisible);
      });
    });

    _isOptimized = true;
  }

  void resetGPUOptimizations() {
    if (!_isOptimized) return;

    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = true;

    SystemChrome.setSystemUIChangeCallback(null);

    _isOptimized = false;
  }
}
