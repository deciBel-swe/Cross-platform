/// App-wide string literals, numeric values, and configuration keys.
/// 
/// 💡 TIP TO AVOID MERGE CONFLICTS:
/// 1. Find the correct feature section.
/// 2. Keep variables in ALPHABETICAL order within their section.
/// 3. Leave a BLANK LINE between every variable.
class AppConstants {
  AppConstants._();

  // ==========================================
  // CORE / SHARED
  // ==========================================

  static const int appBarAnimationDurationMs = 200;

  static const double appBarFadeScrollOffset = 80.0;

  static const double appBarLeadingWidth = 38.0;

  static const String appName = 'Decibel';

  static const double buttonRadius = 8.0;

  static const String edit = 'Edit';

  static const String errorExceptionPrefix = 'Exception: ';

  static const String errorGeneric = 'Oops! Something went wrong.';

  static const double errorIconSize = 64.0;

  static const double placeholderIconSize = 40.0;

  static const String tryAgain = 'Try Again';

  // ==========================================
  // CORE TYPOGRAPHY & SPACING
  // ==========================================

  static const double fontSizeExtraLarge = 24.0;

  static const double fontSizeLarge = 20.0;

  static const double fontSizeMedium = 16.0;

  static const double fontSizeSmall = 12.0;

  static const double spacingExtraLarge = 24.0;

  static const double spacingLarge = 20.0;

  static const double spacingMassive = 40.0;

  static const double spacingMedium = 14.0;

  static const double spacingRegular = 16.0;

  static const double spacingSmall = 8.0;

  static const double spacingTiny = 4.0;

  // ==========================================
  // FEATURE: PRO BADGE
  // ==========================================

  static const double badgeBorderRadius = 100.0;

  static const double badgeFontSize = 12.0;

  static const double badgeGapIconToText = 9.0;

  static const double badgeIconNudgeY = -0.6; // Positive moves down, negative moves up

  static const double badgeIconSize = 13.5;

  static const double badgeInnerRadiusRatio = 0.82;

  static const double badgeLetterSpacing = 1.35;

  static const double badgePaddingHorizontal = 13.5;

  static const double badgePaddingVertical = 7.5;

  static const int badgeSealPoints = 12;

  static const double badgeSealSize = 19.5;

  static const double badgeTrailingBuffer = 3.0;

  // ==========================================
  // FEATURE: USER PROFILE
  // ==========================================

  static const double appBarAvatarSize = 32.0;

  static const int bioCollapsedMaxLines = 3;

  static const double coverPhotoHeight = 200.0;

  static const String followers = 'followers';

  static const String following = 'following';

  static const String noLocation = 'No location';

  static const double profileHeaderTopOffset = 120.0;

  static const String showLess = 'Show less';

  static const String showMore = 'Show more';

  static const String spotlightSubtitle = 'Pin items to your spotlight';

  static const String spotlightTitle = 'Pinned to Spotlight';

  static const String statSeparator = '-';
}