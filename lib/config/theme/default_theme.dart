// ignore_for_file: prefer-correct-callback-field-name, unused-code

import "package:face_detector/config/app_colors.dart";
import "package:face_detector/config/app_text.dart";
import "package:face_detector/config/styles.dart";
import "package:flutter/material.dart";

class DefaultTheme {
  final TextTheme textTheme;

  const DefaultTheme(this.textTheme);

  static MaterialScheme cyberpunkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff00ff00),
      // Bright green
      surfaceTint: Color(0xff00ff00),
      onPrimary: Color(0xff003300),
      // Dark green
      primaryContainer: Color(0xff004d00),
      // Very dark green
      onPrimaryContainer: Color(0xffb3ffb3),
      // Light green
      secondary: Color(0xff66cc66),
      // Medium green
      onSecondary: Color(0xff003300),
      // Dark green
      secondaryContainer: Color(0xff004d00),
      // Very dark green
      onSecondaryContainer: Color(0xffb3ffb3),
      // Light green
      tertiary: Color(0xff339933),
      // Medium green
      onTertiary: Color(0xff003300),
      // Dark green
      tertiaryContainer: Color(0xff004d00),
      // Very dark green
      onTertiaryContainer: Color(0xffb3ffb3),
      // Light green
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff191c20),
      onBackground: Color(0xffe2e2e9),
      surface: Color(0xff191c20),
      onSurface: Color(0xffe2e2e9),
      surfaceVariant: Color(0xff44474e),
      onSurfaceVariant: Color(0xffc4c6d0),
      outline: Color(0xff8e9099),
      outlineVariant: Color(0xff44474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inverseOnSurface: Color(0xff191c20),
      inversePrimary: Color(0xff00ff00),
      primaryFixed: Color(0xff66ff66),
      onPrimaryFixed: Color(0xff004d00),
      primaryFixedDim: Color(0xff33cc33),
      onPrimaryFixedVariant: Color(0xff003300),
      secondaryFixed: Color(0xff66cc66),
      onSecondaryFixed: Color(0xff004d00),
      secondaryFixedDim: Color(0xff339933),
      onSecondaryFixedVariant: Color(0xff003300),
      tertiaryFixed: Color(0xff66cc66),
      onTertiaryFixed: Color(0xff004d00),
      tertiaryFixedDim: Color(0xff339933),
      onTertiaryFixedVariant: Color(0xff003300),
      surfaceDim: Color(0xff191c20),
      surfaceBright: Color(0xff2e3036),
      surfaceContainerLowest: Color(0xff141517),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1e2125),
      surfaceContainerHigh: Color(0xff242629),
      surfaceContainerHighest: Color(0xff292b2f),
    );
  }

  ThemeData cyberpunk() {
    return theme(cyberpunkScheme().toColorScheme()).copyWith(
      textButtonTheme: TextButtonThemeData(
        style: Styles.cyberpunkButtonStyle(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: Styles.cyberpunkButtonStyle(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: Styles.cyberpunkButtonStyle(),
      ),
      inputDecorationTheme: Styles.cyberpunkTextFieldDecorationTheme(),
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.cyan,
        inactiveTrackColor: Colors.cyan.withOpacity(0.5),
        thumbColor: Colors.cyanAccent,
        overlayColor: Colors.cyanAccent.withOpacity(0.2),
        valueIndicatorColor: Colors.cyan,
        thumbShape: const SquareThumbShape(),
        trackHeight: 4.0,
        showValueIndicator: ShowValueIndicator.always,
        valueIndicatorTextStyle: AppText.font12Regular,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xff66cc66), width: 2),
          borderRadius: BorderRadius.all(Radius.zero),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xff66cc66), width: 2),
          borderRadius: BorderRadius.vertical(top: Radius.zero),
        ),
        backgroundColor: Color(0xff191c20), // Same as surface color
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xff191c20),
        contentTextStyle: TextStyle(color: AppColors.defaultThemeGreenText),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xff66cc66), width: 2),
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        // behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
