import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  static const double desktopWidthBreakpoint = 801;
  static const double tabletShortestSideBreakpoint = 600;

  static bool isDesktop(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return false;
    }
    final size = mediaQuery.size;
    return size.width >= desktopWidthBreakpoint &&
        size.shortestSide >= tabletShortestSideBreakpoint;
  }

  static bool isPhoneLandscape(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return false;
    }

    final size = mediaQuery.size;
    return size.width > size.height &&
        size.shortestSide < tabletShortestSideBreakpoint;
  }
}
