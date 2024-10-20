import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceUtils {
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return !isLandscape(context);
  }

  static bool isSmallScreen(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return size.shortestSide < 600 ;
  }

  static bool isMediumScreen(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return size.shortestSide >= 600 && size.shortestSide < 1024;
  }

  static bool isLargeScreen(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return size.shortestSide >= 1024 && size.shortestSide < 1440;
  }

  static bool isExtraLargeScreen(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return size.shortestSide >= 1440;
  }

  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  }

  static Future<void> hideKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static double getPreviewScale(BuildContext context, cameraController) {
    final Size size = MediaQuery.sizeOf(context);

    if (isLandscape(context)) {
      return size.aspectRatio * 1 / cameraController!.value.aspectRatio;
    }
    return size.aspectRatio * cameraController!.value.aspectRatio;
  }

  // Web does not have access to dart:io, where Platform is implemented
  // I just check if it is web or not to eventually avoid exceptions
  static bool isMacOS() {
    return !kIsWeb && Platform.isMacOS;
  }

  static bool isLinux() {
    return !kIsWeb && Platform.isLinux;
  }

  static bool isWindows() {
    return !kIsWeb && Platform.isWindows;
  }

  static bool isDesktop() {
    if (kIsWeb) {
      return false;
    }
    return !kIsWeb && Platform.isWindows || Platform.isMacOS;
  }

  static bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }

  static bool isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }

  static bool isMobile() {
    return !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  }
}
