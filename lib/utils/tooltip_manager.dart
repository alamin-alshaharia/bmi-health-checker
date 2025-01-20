import 'package:flutter/material.dart';

class TooltipManager extends NavigatorObserver {
  static OverlayEntry? _activeTooltip;
  static bool _isNavigating = false;

  static void showTooltip(OverlayEntry tooltip) {
    hideTooltip();
    _activeTooltip = tooltip;
  }

  static void hideTooltip() {
    if (_activeTooltip != null && !_isNavigating) {
      _activeTooltip?.remove();
      _activeTooltip = null;
    }
  }

  void _handleNavigation(Function action) {
    _isNavigating = true;
    if (_activeTooltip != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        action();
        _activeTooltip?.remove();
        _activeTooltip = null;
        _isNavigating = false;
      });
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleNavigation(() {});
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleNavigation(() {});
  }
}
