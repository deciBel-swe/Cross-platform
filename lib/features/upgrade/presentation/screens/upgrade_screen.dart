/// Desktop Upgrade screen — SoundCloud Go+ style premium page.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../library_profile/presentation/providers/public_profile_provider.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../../domain/entities/subscription_status.dart';
import '../notifiers/upgrade_notifier.dart';
import '../providers/upgrade_providers.dart';

/// Upgrade page showcasing premium features with a CTA banner.
class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen>
    with WidgetsBindingObserver {
  static const UpgradeViewState _fallbackState = UpgradeViewState(
    subscription: SubscriptionStatus(
      status: 'INACTIVE',
      plan: 'FREE',
      currentPeriodEnd: null,
      cancelAtPeriodEnd: false,
    ),
  );

  bool _awaitingCheckoutReturn = false;
  bool _isPrimaryActionRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingCheckoutReturn) {
      _awaitingCheckoutReturn = false;
      ref.read(upgradeNotifierProvider.notifier).refreshStatus();
      _invalidateProfileBadges();
    }
  }

  void _invalidateProfileBadges() {
    ref.invalidate(userProfileProvider);
    ref.invalidate(publicProfileProvider);
    ref.invalidate(publicProfileSnapshotProvider);
  }

  Future<void> _onPrimaryActionTap(UpgradeViewState viewState) async {
    if (_isPrimaryActionRunning) {
      return;
    }

    _isPrimaryActionRunning = true;

    final subscription = viewState.subscription;
    final notifier = ref.read(upgradeNotifierProvider.notifier);

    try {
      if (!subscription.isActive) {
        final checkoutResult = await notifier.startCheckout();
        if (checkoutResult.isLeft()) {
          checkoutResult.fold(_showFailureMessage, (_) {});
        } else {
          final checkoutUrl = checkoutResult.getOrElse(() => '');
          await _launchCheckout(checkoutUrl);
        }
        return;
      }

      if (!subscription.cancelAtPeriodEnd) {
        final cancelResult = await notifier.cancelAtPeriodEnd();
        cancelResult.fold(_showFailureMessage, (updatedSubscription) {
          _invalidateProfileBadges();
          _showMessage(AppConstants.upgradeSubscriptionCancelSuccess);
        });
        return;
      }

      final renewResult = await notifier.renewSubscription();
      renewResult.fold(_showFailureMessage, (updatedSubscription) {
        _invalidateProfileBadges();
        _showMessage(AppConstants.upgradeSubscriptionRenewSuccess);
      });
    } finally {
      _isPrimaryActionRunning = false;
    }
  }

  Future<void> _launchCheckout(String checkoutUrl) async {
    final uri = Uri.tryParse(checkoutUrl);
    if (uri == null) {
      _showMessage(AppConstants.upgradeCheckoutLaunchFailed);
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showMessage(AppConstants.upgradeCheckoutLaunchFailed);
      return;
    }

    _awaitingCheckoutReturn = true;
    _invalidateProfileBadges();
    _showMessage(AppConstants.upgradeCheckoutStarted);
  }

  void _showFailureMessage(Failure failure) {
    _showMessage(failure.message.replaceFirst('Exception: ', ''));
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _resolvePrimaryActionLabel(SubscriptionStatus subscription) {
    if (!subscription.isActive) {
      return AppConstants.upgradeActionSubscribeNow;
    }

    return subscription.cancelAtPeriodEnd
        ? AppConstants.upgradeActionRenewSubscription
        : AppConstants.upgradeActionCancelAtPeriodEnd;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);

    ref.listen<AsyncValue<UpgradeViewState>>(upgradeNotifierProvider, (
      previous,
      next,
    ) {
      if (next.hasError && previous?.error != next.error) {
        _showMessage(next.error.toString().replaceFirst('Exception: ', ''));
      }
    });

    final upgradeState = ref.watch(upgradeNotifierProvider);
    final viewState = upgradeState.valueOrNull ?? _fallbackState;
    final subscription = viewState.subscription;

    final isBusy =
        upgradeState.isLoading ||
        viewState.isAnyActionInProgress ||
        _isPrimaryActionRunning;

    final ctaLabel = _resolvePrimaryActionLabel(subscription);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              scrolledUnderElevation: 0,
              title: const Text(
                'Upgrade',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        children: [
          // ---- Hero banner ----
          Semantics(
            header: true,
            label: 'Decibel Pro subscription features overview',
            child: const _UpgradeHero(),
          ),

          const SizedBox(height: AppDimensions.paddingLg),

          Semantics(
            container: true,
            label: 'Your subscription details',
            child: MergeSemantics(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current plan: ${subscription.plan}',
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: AppDimensions.paddingSm),
                    Text(
                      'Status: ${subscription.status}',
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXl),

          // ---- CTA button ----
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Semantics(
                button: true,
                enabled: !isBusy,
                label: isBusy ? 'Action in progress' : ctaLabel,
                child: ElevatedButton(
                  onPressed:
                      isBusy ? null : () => _onPrimaryActionTap(viewState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(ctaLabel),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXl),
        ],
      ),
    );
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
}

/// Hero banner with gradient and tagline.
class _UpgradeHero extends StatelessWidget {
  const _UpgradeHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark, Color(0xFF1A0500)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimensions.paddingLg),
          Semantics(
            label: 'Decibel App Icon',
            child: Image.asset(
              'assets/icon/white_app_icon_trans.png',
              width: 64,
              height: 64,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          const Text(
            'Decibel PRO',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSm),
          Text(
            'Your music. No limits.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLg),
        ],
      ),
    );
  }
}
