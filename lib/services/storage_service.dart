import 'package:face_detector/config/constants.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kSettingsPin = 'pin';
const kSettingsMasterPassword = 'masterPassword';
const kSettingsBaseUrl = 'baseUrl';
const kSettingsApiKey = 'apiKey';
const kSettingsSimilarity = 'similarity';
const kSettingsShowFacesInRecognize = 'showFacesInRecognize';
const kSettingsExtApiURL = 'ext_api_url';
const kSettingsExtApiMethod = 'ext_api_method';
const kSettingsExtApiHeaders = 'ext_api_headers';
const kSettingsExtApiBody = 'ext_api_body';
const kSettingsTheme = 'theme';
const kSettingsCameraIndex = 'camera_index';
const kSettingsCameraOrientation = 'camera_orientation';
const kSettingsLockOrientation = 'lock_orientation';
const kSettingsAutodetectFace = 'autodetect_faces';
const kSettingsFullScreen = 'full_screen';

const kDefaultPin = '0000';
const kDefaultSimilarity = 0.9;
const kDefaultShowFacesInRecognize = true;
const kDefaultCameraIndex = -1;
const kDefaultCameraOrientation = 0;
const kDefaultLockOrientation = false;
const kDefaultAutodetectFace = false;
const kDefaultFullScreen = false;

List<String> kExtApiMethods = ['get', 'post', 'put', 'delete'];
List<String> kThemes = [kThemeDefault, kThemeMaterial];

class StorageService {
  late final SharedPreferences sharedPref;

  Future<StorageService> init() async {
    sharedPref = await SharedPreferences.getInstance();

    //await clearAllData();
    //await demo();
    return this;
  }

  Future<void> demo() async {
    await setApiKey('6919ef57-e286-4070-ba9e-4b06a1e4e842');
    await setBaseUrl('http://192.168.0.46:8000');
    await setSimilarity(kDefaultSimilarity);
    await setShowFacesInRecognize(kDefaultShowFacesInRecognize);
    await setExtApiURL('https://api.example.com');
    await setExtApiMethod(kExtApiMethods.first);
    await setExtApiHeaders('{"Content-Type": "application/json"}');
    await setExtApiBody('{"image": "image"}');
    await setTheme(kThemes.first);
    await setCameraIndex(0);
    await setCameraOrientation(0);
    await setLockOrientation(false);
    await setAutodetectFace(true);
  }

  Future<void> clearAllData() async {
    await sharedPref.clear();
  }

  // Getters & Setters

  String getPin() {
    return sharedPref.getString(kSettingsPin) ?? kDefaultPin;
  }

  Future<bool> setPin(String pin) async {
    return await sharedPref.setString(kSettingsPin, pin.trim());
  }

  String getApiKey() {
    return sharedPref.getString(kSettingsApiKey) ?? '';
  }

  Future<bool> setApiKey(String apiKey) async {
    return await sharedPref.setString(kSettingsApiKey, apiKey.trim());
  }

  String getMasterPassword() {
    return sharedPref.getString(kSettingsMasterPassword) ?? '';
  }

  Future<bool> setMasterPassword(String password) async {
    return await sharedPref.setString(kSettingsMasterPassword, password.trim());
  }

  String getBaseUrl() {
    return sharedPref.getString(kSettingsBaseUrl) ?? '';
  }

  Future<bool> setBaseUrl(String baseUrl) async {
    return await sharedPref.setString(kSettingsBaseUrl, baseUrl.trim());
  }

  double getSimilarity() {
    return sharedPref.getDouble(kSettingsSimilarity) ?? kDefaultSimilarity;
  }

  Future<bool> setSimilarity(double similarity) async {
    return await sharedPref.setDouble(kSettingsSimilarity, similarity);
  }

  bool getShowFacesInRecognize() {
    return sharedPref.getBool(kSettingsShowFacesInRecognize) ?? kDefaultShowFacesInRecognize;
  }

  Future<bool> setShowFacesInRecognize(bool fastRecognize) async {
    return await sharedPref.setBool(kSettingsShowFacesInRecognize, fastRecognize);
  }

  String getExtApiURL() {
    return sharedPref.getString(kSettingsExtApiURL) ?? '';
  }

  Future<bool> setExtApiURL(String extApiURL) async {
    return await sharedPref.setString(kSettingsExtApiURL, extApiURL.trim());
  }

  String getExtApiMethod() {
    return sharedPref.getString(kSettingsExtApiMethod) ?? kExtApiMethods.first;
  }

  Future<bool> setExtApiMethod(String extApiMethod) async {
    return await sharedPref.setString(kSettingsExtApiMethod, extApiMethod.trim().toLowerCase());
  }

  String getTheme() {
    return sharedPref.getString(kSettingsTheme) ?? kThemes.first;
  }

  Future<bool> setTheme(String theme) async {
    return await sharedPref.setString(kSettingsTheme, theme);
  }

  String getExtApiHeaders() {
    return sharedPref.getString(kSettingsExtApiHeaders) ?? '';
  }

  Future<bool> setExtApiHeaders(String extApiHeaders) async {
    return await sharedPref.setString(kSettingsExtApiHeaders, extApiHeaders.trim());
  }

  String getExtApiBody() {
    return sharedPref.getString(kSettingsExtApiBody) ?? '';
  }

  Future<bool> setExtApiBody(String extApiBody) async {
    return await sharedPref.setString(kSettingsExtApiBody, extApiBody.trim());
  }

  int getCameraIndex() {
    return sharedPref.getInt(kSettingsCameraIndex) ?? kDefaultCameraIndex;
  }

  Future<bool> setCameraIndex(int cameraIdx) async {
    return await sharedPref.setInt(kSettingsCameraIndex, cameraIdx);
  }

  int getCameraOrientation() {
    return sharedPref.getInt(kSettingsCameraOrientation) ?? kDefaultCameraOrientation;
  }

  Future<bool> setCameraOrientation(int orientation) async {
    return await sharedPref.setInt(kSettingsCameraOrientation, orientation);
  }

  bool getLockOrientation() {
    return sharedPref.getBool(kSettingsLockOrientation) ?? kDefaultLockOrientation;
  }

  Future<bool> setLockOrientation(bool lock) async {
    return await sharedPref.setBool(kSettingsLockOrientation, lock);
  }

  bool getAutodetectFace() {
    bool? autodetectFace = sharedPref.getBool(kSettingsAutodetectFace);
    if (autodetectFace == null && (DeviceUtils.isMobile() || DeviceUtils.isMacOS())) {
      return true;
    }
    return autodetectFace ?? kDefaultLockOrientation;
  }

  Future<bool> setAutodetectFace(bool autodetect) async {
    return await sharedPref.setBool(kSettingsAutodetectFace, autodetect);
  }

  bool getFullScreen() {
    return sharedPref.getBool(kSettingsFullScreen) ?? kDefaultFullScreen;
  }

  Future<bool> setFullScreen(bool fullScreen) async {
    return await sharedPref.setBool(kSettingsFullScreen, fullScreen);
  }
}
