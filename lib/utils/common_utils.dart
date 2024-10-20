import 'dart:io';

import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonUtils {
  static String getLocalizedString(BuildContext context, String key, [bool? skipCapitalization]) {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();
    switch (themeName) {
      case kThemeDefault:
        return skipCapitalization == true ? key : key.toUpperCase();
      case kThemeMaterial:
      default:
        return key;
    }
  }

  static String getValidBaseUrl(String url) {
    try {
      String tmpUrl = Uri.parse(url).host.isEmpty ? '' : url;
      bool ret = isValidUrl(url);
      return ret ? tmpUrl : '';
    } catch (e) {
      return '';
    }
  }

  static bool _isValidIp(String? ip) {
    if (ip == null) return false;
    final ipParts = ip.split('.');
    if (ipParts.length != 4) return false;

    for (final part in ipParts) {
      final intValue = int.tryParse(part);
      if (intValue == null || intValue < 0 || intValue > 255) {
        return false;
      }
    }
    return true;
  }

  static bool _isValidHost(String? host) {
    if (host == null) return false;
    final hostPattern = r'^([\w-]+\.)+[\w-]{2,}$';
    return RegExp(hostPattern).hasMatch(host);
  }

  static bool isValidUrl(String url) {
    final urlPattern =
        r'^(http|https):\/\/(([\w.-]+\.[a-zA-Z]{2,}|(?:\d{1,3}\.){3}\d{1,3}))(\/[\w\/.-]*)?(:\d+)?$';
    final regExp = RegExp(urlPattern);

    final match = regExp.firstMatch(url);
    if (match != null) {
      final hostOrIp = match[2];
      if (_isValidIp(hostOrIp) || _isValidHost(hostOrIp)) {
        return true;
      }
      return false;
    }
    return false;
  }

  static bool isRunningInTest() {
    return !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
  }
}
