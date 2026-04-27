import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Future<T?> showRightSidePanel<T>({
  required BuildContext context,
  required Widget child,
  double width = 420,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.42),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) {
      final size = MediaQuery.sizeOf(context);
      return Align(
        alignment: Alignment.centerRight,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: width,
              height: size.height,
              child: child,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

bool isDesktopPanelLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  return mediaQuery != null && mediaQuery.size.width >= 801;
}

BoxDecoration rightSidePanelDecoration() {
  return const BoxDecoration(
    color: AppColors.background,
    border: Border(left: BorderSide(color: AppColors.divider, width: 0.5)),
    borderRadius: BorderRadius.horizontal(left: Radius.circular(18)),
  );
}
