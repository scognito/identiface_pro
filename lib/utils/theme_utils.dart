import 'package:face_detector/config/app_colors.dart';
import 'package:face_detector/config/assets.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThemeUtils {
  static TextTheme createTextTheme(
    BuildContext context,
    String bodyFontString,
    String displayFontString,
  ) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    TextTheme textTheme = displayTextTheme.copyWith(
      displayLarge: bodyTextTheme.displayLarge?.copyWith(inherit: true),
      displayMedium: bodyTextTheme.displayMedium?.copyWith(inherit: true),
      displaySmall: bodyTextTheme.displaySmall?.copyWith(inherit: true),
      headlineLarge: bodyTextTheme.headlineLarge?.copyWith(inherit: true),
      headlineMedium: bodyTextTheme.headlineMedium?.copyWith(inherit: true),
      headlineSmall: bodyTextTheme.headlineSmall?.copyWith(inherit: true),
      titleLarge: bodyTextTheme.titleLarge?.copyWith(inherit: true),
      titleMedium: bodyTextTheme.titleMedium?.copyWith(inherit: true),
      titleSmall: bodyTextTheme.titleSmall?.copyWith(inherit: true),
      bodyLarge: bodyTextTheme.bodyLarge?.copyWith(inherit: true),
      bodyMedium: bodyTextTheme.bodyMedium?.copyWith(inherit: true),
      bodySmall: bodyTextTheme.bodySmall?.copyWith(inherit: true),
      labelLarge: bodyTextTheme.labelLarge?.copyWith(inherit: true),
      labelMedium: bodyTextTheme.labelMedium?.copyWith(inherit: true),
      labelSmall: bodyTextTheme.labelSmall?.copyWith(inherit: true),
    );
    return textTheme;
  }

  static Color getSettingsLabelColor(BuildContext context) {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return AppColors.defaultThemeGreenText;
      case kThemeMaterial:
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  static Color getDropdownItemColor(BuildContext context) {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return AppColors.defaultThemeHudCyan;
      case kThemeMaterial:
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  static BoxDecoration getBorderTheme(BuildContext context) {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return BoxDecoration(
          border: Border.all(color: AppColors.defaultThemeHudCyan),
          borderRadius: BorderRadius.zero,
        );
      case kThemeMaterial:
      default:
        return BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        );
    }
  }

  static Color getIconColor(BuildContext context) {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return AppColors.defaultThemeHudCyan;
      case kThemeMaterial:
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  static Widget getImageAddPerson(BuildContext context) {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return Image.asset(
          Assets.imageCard,
          width: 80,
          height: 100,
          fit: BoxFit.fill,
          semanticLabel: 'card',
        );
      case kThemeMaterial:
      default:
        return Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
        );
    }
  }

  static double getRecognizeDialogHeight(BuildContext context) {
    final double height = DeviceUtils.isLandscape(context)
        ? MediaQuery.sizeOf(context).height / 1.5
        : MediaQuery.sizeOf(context).height / 2;

    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return height;
      case kThemeMaterial:
      default:
        return DeviceUtils.isLandscape(context) ? height : height / 1.5;
    }
  }

  static Size getAvatarSize(BuildContext context, double inputHeight) {
    final double avatarWidth = DeviceUtils.isLandscape(context) ? inputHeight / 2 : inputHeight / 3;
    final double avatarHeight =
        DeviceUtils.isLandscape(context) ? inputHeight / 1.5 : inputHeight / 2;

    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return Size(avatarWidth, avatarHeight);
      case kThemeMaterial:
      default:
        double factor = DeviceUtils.isSmallScreen(context) ? 1.3 : 1;
        return Size(avatarWidth * factor, avatarHeight * factor);
    }
  }

  static double getDefaultThemePadding(BuildContext context) {
    if (DeviceUtils.isSmallScreen(context)) {
      return 40;
    } else if (DeviceUtils.isMediumScreen(context)) {
      return 60;
    }

    return 80;
  }
}
