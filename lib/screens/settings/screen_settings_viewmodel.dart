import 'dart:convert';

import 'package:face_detector/locator.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:window_manager/window_manager.dart';

class ScreenSettingsViewModel extends FutureViewModel {
  final _api = locator.get<ApiService>();
  final _storage = locator.get<StorageService>();
  final _bus = locator.get<EventBus>();

  String _masterPassword = '';
  String _baseURL = '';
  String _apiKey = '';
  double _similarityThreshold = kDefaultSimilarity;
  bool _fastRecognize = kDefaultShowFacesInRecognize;
  bool _autodetectFace = kDefaultAutodetectFace;
  String _extApiURL = '';
  String _extApiMethod = '';
  String _extHeaders = '';
  String _extBody = '';
  String _theme = '';
  bool _fullScreen = kDefaultFullScreen;

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  ExtApiSetting _extApiSetting = ExtApiSetting.header;

  ExtApiSetting get extApiSetting => _extApiSetting;

  String get extApiMethod => _extApiMethod;

  String get theme => _theme;

  String extApiValue = '';

  final formKey = GlobalKey<FormState>();

  TextEditingController masterPasswordController = TextEditingController();
  TextEditingController baseURLController = TextEditingController();
  TextEditingController apiKeyController = TextEditingController();
  TextEditingController externalApiUrlController = TextEditingController();
  TextEditingController externalApiHeadersController = TextEditingController();
  TextEditingController externalApiBodyController = TextEditingController();

  double get similarityThreshold => _similarityThreshold;

  bool get fastRecognize => _fastRecognize;

  bool get autodetectFace => _autodetectFace;

  bool get fullScreen => _fullScreen;

  final BuildContext context;

  ScreenSettingsViewModel({required this.context});

  @override
  Future<void> futureToRun() async {
    _masterPassword = _storage.getMasterPassword();
    masterPasswordController.text = _masterPassword;

    _baseURL = _storage.getBaseUrl();
    baseURLController.text = _baseURL;

    _apiKey = _storage.getApiKey();
    apiKeyController.text = _apiKey;

    _similarityThreshold = _storage.getSimilarity();
    _fastRecognize = _storage.getShowFacesInRecognize();
    _autodetectFace = _storage.getAutodetectFace();

    _extApiURL = _storage.getExtApiURL();
    externalApiUrlController.text = _extApiURL;

    setExtApiMethod(_storage.getExtApiMethod());

    _extHeaders = _storage.getExtApiHeaders();
    externalApiHeadersController.text = _extHeaders;

    _extBody = _storage.getExtApiBody();
    externalApiBodyController.text = _extBody;

    _fullScreen = _storage.getFullScreen();

    _theme = _storage.getTheme();
    setTheme(_theme);
  }

  void setSimilarity(double value) {
    debugPrint('setSimilarity: $value');
    _similarityThreshold = value;
    notifyListeners();
  }

  void setFullScreen(bool value) {
    debugPrint('setFullScreen: $value');
    _fullScreen = value;
    windowManager.setFullScreen(_fullScreen);
    notifyListeners();
  }

  void setFastRecognize(bool value) {
    debugPrint('setFastRecognize: $value');
    _fastRecognize = value;
    notifyListeners();
  }

  void setAutodetectFace(bool value) {
    debugPrint('setAutodetectFace: $value');
    _autodetectFace = value;

    if (!value) {
      _bus.fire(EventBusEvent.stopCameraStream);
    } else {
      _bus.fire(EventBusEvent.startCameraStream);
    }

    if (context.mounted) {
      Provider.of<SettingsProvider>(context, listen: false).setAutodetectFace(value);
    }
    notifyListeners();
  }

  void setExtApiSetting(ExtApiSetting value) {
    _extApiSetting = value;
    notifyListeners();
  }

  void setExtApiMethod(String value) {
    _extApiMethod = value;
    notifyListeners();
  }

  String getExtApiValue() {
    switch (_extApiSetting) {
      case ExtApiSetting.header:
        return externalApiHeadersController.text;
      case ExtApiSetting.body:
        return externalApiBodyController.text;
    }
  }

  void setExtApiValue(String value) {
    switch (_extApiSetting) {
      case ExtApiSetting.header:
        _extHeaders = value;
        break;
      case ExtApiSetting.body:
        _extBody = value;
        break;
    }
    notifyListeners();
  }

  String? validateJson(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      jsonDecode(value);
      return null;
    } catch (e) {
      return CommonUtils.getLocalizedString(
        context,
        context.l10n.error_invalid_json,
      );
    }
  }

  Future<void> testConnection() async {
    debugPrint('testConnection');

    if (!validateForm()) {
      return;
    }

    String responseMessage = '';
    try {
      await saveSettings(exit: false);
      ApiResponse response = await _api.getSubjects();
      if (response.hasData) {
        responseMessage = 'OK';
      } else {
        responseMessage = 'ERROR\n${response.error!}';
      }
    } catch (e) {
      responseMessage = 'ERROR\n${e.toString()}';
    } finally {
      if (context.mounted) {
        WidgetUtils.showSnackBar(context, responseMessage);
      }
    }
  }

  Future<void> setTheme(String themeName) async {
    await _storage.setTheme(themeName);
    _theme = themeName;

    if (context.mounted) {
      Provider.of<SettingsProvider>(context, listen: false).setThemeName(themeName);
    }
    notifyListeners();
  }

  Future<void> testExternalApi() async {
    debugPrint('testExternalApi');

    if (!validateForm()) {
      return;
    }

    String responseMessage = '';
    try {
      await saveSettings(exit: false);
      ApiResponse response = await _api.callExternalApi();
      if (response.hasData) {
        responseMessage = 'OK';
      } else {
        responseMessage = 'ERROR\n${response.error!}';
      }
    } catch (e) {
      responseMessage = 'ERROR\n${e.toString()}';
    } finally {
      if (context.mounted) {
        WidgetUtils.showSnackBar(context, responseMessage);
      }
    }
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  Future<void> saveSettings({required bool exit}) async {
    if (validateForm()) {
      _api.updateBaseUrl(baseURLController.text);

      _storage.setMasterPassword(masterPasswordController.text);
      _storage.setBaseUrl(baseURLController.text);
      _storage.setApiKey(apiKeyController.text);
      _storage.setSimilarity(_similarityThreshold);
      _storage.setShowFacesInRecognize(_fastRecognize);
      _storage.setAutodetectFace(_autodetectFace);
      _storage.setExtApiURL(externalApiUrlController.text);
      _storage.setExtApiMethod(_extApiMethod);
      _storage.setExtApiHeaders(externalApiHeadersController.text);
      _storage.setExtApiBody(externalApiBodyController.text);
      _storage.setFullScreen(_fullScreen);

      if (exit) {
        context.pop();
      }
    } else {
      if (context.mounted) {
        WidgetUtils.showSnackBar(
          context,
          CommonUtils.getLocalizedString(
            context,
            context.l10n.invalid_settings,
          ),
        );
      }
    }
  }

  void goBack() {
    context.pop();
  }

  Future<void> resetSettings() async {
    await _storage.demo();
    await futureToRun();
  }

  @override
  void dispose() {
    masterPasswordController.dispose();
    baseURLController.dispose();
    apiKeyController.dispose();
    externalApiUrlController.dispose();
    externalApiHeadersController.dispose();
    externalApiBodyController.dispose();
    super.dispose();
  }
}

enum ExtApiSetting { header, body }
