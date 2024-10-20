import 'package:face_detector/config/constants.dart';
import 'package:face_detector/config/theme/default_theme.dart';
import 'package:face_detector/config/theme/material_like_theme.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  final _storage = locator.get<StorageService>();

  String _themeName = kThemes.first;

  String get themeName => _themeName;

  bool _showFacesOnRecognize = true;

  bool get showFacesOnRecognize => _showFacesOnRecognize;

  int _cameraOrientation = 0;

  int get cameraOrientation => _cameraOrientation;

  bool _autodetectFace = false;

  bool get autodetectFace => _autodetectFace;

  SettingsProvider() {
    _themeName = _storage.getTheme();
    _showFacesOnRecognize = _storage.getShowFacesInRecognize();
    _cameraOrientation = _storage.getCameraOrientation();
    _autodetectFace = _storage.getAutodetectFace();
  }

  void setThemeName(String newTheme) {
    _themeName = newTheme;
    notifyListeners();
  }

  String getThemeName() {
    return _storage.getTheme();
  }

  bool getShowFacesOnRecognize() {
    return _storage.getShowFacesInRecognize();
  }

  void setAutodetectFace(bool value) {
    _autodetectFace = value;
    notifyListeners();
  }

  bool getAutodetectFace() {
    return _storage.getAutodetectFace();
  }

  void setCameraOrientation(int orientation) {
    _cameraOrientation = orientation;
    notifyListeners();
  }

  int getCameraOrientation() {
    return _cameraOrientation;
  }

  ThemeData getTheme(BuildContext context) {
    switch (_themeName) {
      case kThemeDefault:
        TextTheme textTheme = ThemeUtils.createTextTheme(context, 'Orbitron', 'Orbitron');
        DefaultTheme defaultTheme = DefaultTheme(textTheme);
        return defaultTheme.cyberpunk();
      case kThemeMaterial:
      default:
        return MaterialLikeTheme.theme();
    }
  }
}
