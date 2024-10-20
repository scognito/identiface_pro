import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/models/recognize_response_model.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_settings_viewmodel.dart';
import 'package:face_detector/screens/recognize/widgets/dialog_recognize_viewmodel.dart';
import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/database_service.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/assets_utils.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/image_utils.dart';
import 'package:face_detector/utils/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ScreenRecognizeViewModel extends FutureViewModel {
  final _api = locator.get<ApiService>();
  final _storage = locator.get<StorageService>();
  final _database = locator.get<DatabaseService>();
  final _camera = locator.get<CameraService>();

  final List<PhotoType> _peoplePhotos = [];

  List<PhotoType> get peoplePhotos => _peoplePhotos;

  bool? _userFound;

  bool? get userFound => _userFound;

  bool isAnalyzing = false;

  final ValueNotifier<bool> _recognizeEnabled = ValueNotifier<bool>(true);

  ValueNotifier<bool> get recognizeEnabled => _recognizeEnabled;

  bool _isTakingPicture = false;

  bool get isTakingPicture => _isTakingPicture;

  int _countDown = 0;

  int get countDown => _countDown;

  bool _optionsVisible = false;

  bool get optionsVisible => _optionsVisible;

  int _cameraCount = 0;

  int get cameraCount => _cameraCount;

  bool get hasCameraFeatures => _camera.hasFeatures();

  String? recognizedName;
  Uint8List? _recognizedPath;

  Uint8List? get recognizedPath => _recognizedPath;

  Timer? _debounceTimer;
  bool _canScan = true;

  final BuildContext context;

  ScreenRecognizeViewModel({required this.context}) {
    debugPrint('ScreenRecognizeViewModel constructor called');
  }

  @override
  Future<void> futureToRun() async {
    await populatePeoplePhotos();
    _cameraCount = await _camera.getCameraCount();
  }

  Future<void> analyzeImageMacOS(List<Rect> faces, InputImage inputImage) async {
    if (!_recognizeEnabled.value ||
        !context.mounted ||
        _optionsVisible ||
        !_canScan ||
        isAnalyzing) {
      return;
    }

    try {
      if (_canScan && !isAnalyzing) {
        _canScan = false;

        if (faces.isNotEmpty) {
          // DEBUG
          // final Directory dir = await FileSystemUtils.getMediaDirectory();
          // final imagePath = '${dir.path}/face_reco.jpg';
          //
          // bool res = await ImageUtils.convertInputImageToFile(
          //   inputImage: inputImage,
          //   imageSavePath: imagePath,
          // );

          Uint8List? bytes = ImageUtils.convertInputImageToBytes(inputImage);

          if (bytes != null) {
            await recognize(bytes);

            _debounceTimer = Timer(const Duration(seconds: 2), () {
              _canScan = true;
            });

            notifyListeners();
          }
        }
      }
    } catch (error) {
      debugPrint('...sending image resulted error $error');
    }
  }

  Future<void> analyzeImage(InputImage inputImage) async {
    if (!_recognizeEnabled.value ||
        !context.mounted ||
        _optionsVisible ||
        !_canScan ||
        isAnalyzing) {
      return;
    }
    if (_canScan && !isAnalyzing) {
      _canScan = false;

      try {
        // DEBUG
        // final Directory dir = await FileSystemUtils.getMediaDirectory();
        // final imagePath = '${dir.path}/face_reco.jpg';
        //
        // bool res = await ImageUtils.convertInputImageToFile(
        //   inputImage: inputImage,
        //   imageSavePath: imagePath,
        // );

        Uint8List? bytes = ImageUtils.convertInputImageToBytes(inputImage);
        if (bytes != null) {
          await recognize(bytes);

          _debounceTimer = Timer(const Duration(seconds: 2), () {
            _canScan = true;
          });

          notifyListeners();
        }
      } catch (error) {
        debugPrint('...sending image resulted error $error');
      }
    }
  }

  Future<void> recognize(Uint8List inputImageBytes) async {
    recognizedName = null;
    _recognizedPath = null;
    _userFound = null;

    setAnalyzing(true);

    debugPrint('Saving image for sending');

    // The image comes from mobile or web, we need to convert it to a file,
    // scale, and convert to bytes for sending
    // if (inputImage != null) {
    //   // final Directory dir = await FileSystemUtils.getMediaDirectory();
    //   // final imagePath = '${dir.path}/face_reco.jpg';
    //   //
    //   // bool res = await ImageUtils.convertInputImageToFile(
    //   //   inputImage: inputImage,
    //   //   imageSavePath: imagePath,
    //   // );
    //   //
    //   // if (!res) {
    //   //   setAnalyzing(false);
    //   //   return;
    //   // }
    //   //
    //   // final imageFile = File(imagePath);
    //   // Uint8List bytes = await imageFile.readAsBytes();
    //   //
    //   // debugPrint('Sending image for recognition');
    //
    //   Uint8List? bytes = ImageUtils.convertInputImageToBytes(inputImage: inputImage);
    //
    //   if (bytes != null) {
    //     recognizedName = await sendImageForRecognition(bytes);
    //   }
    // } else {
    //   recognizedName = await sendImageForRecognition(inputImageBytes!);
    // }

    recognizedName = await sendImageForRecognition(inputImageBytes);

    if (context.mounted &&
        Provider.of<SettingsProvider>(context, listen: false).getThemeName() == kThemeDefault) {
      await Future.delayed(const Duration(seconds: 2));
    }

    _userFound = recognizedName != null;

    // If the user was recognized then get the image stored, if any
    if (recognizedName != null) {
      if (_storage.getExtApiURL().isNotEmpty) {
        unawaited(_api.callExternalApi());
      }
      String? encodedImage = await _database.getItemByKey(
        DatabaseService.usersStoreName,
        recognizedName!,
      );
      if (encodedImage != null) {
        _recognizedPath = base64Decode(encodedImage);
      }
    }

    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    setAnalyzing(false);
  }

  Future<String?> sendImageForRecognition(Uint8List bytes) async {
    ApiResponse response = await _api.recognize(bytes);

    if (response.hasData) {
      RecognizeResponseModel recognized = response.data as RecognizeResponseModel;

      if (recognized.result.first.subjects.isNotEmpty) {
        if (context.mounted) {
          double similarity = recognized.result.first.subjects.first.similarity;
          double threshold = _storage.getSimilarity();

          if (similarity < threshold) {
            debugPrint(
              'Similarity check not satisfied! ($similarity < $threshold)',
            );
            return null;
          }
          debugPrint('Found 1 result');
          return recognized.result.first.subjects.first.subject;
        }
      } else {
        debugPrint('No result found');
        return null;
      }
    } else {
      if (context.mounted && response.error!.isNotEmpty) {
        WidgetUtils.showSnackBar(context, response.error!);
      }
      debugPrint('Error in response after recognize');
    }
    return null;
  }

  Future<void> populatePeoplePhotos() async {
    List<String> peopleAssets = await AssetsUtils.getImagePaths('assets/images/people/');

    for (String path in peopleAssets) {
      _peoplePhotos.add(PhotoType(path: path, type: MediaType.asset));
    }
  }

  Future<void> takePictureAndAnalyze() async {
    //await startCountdown(from: 3);
    setTakingPicture(true);
    XFile? picture = await _camera.takePicture();

    if (picture != null) {
      Uint8List? bytes = kIsWeb
          ? await ImageUtils.convertImageURLToBytes(picture.path)
          : await picture.readAsBytes();
      setTakingPicture(false);

      if (bytes != null) {
        await recognize(bytes);
      }
      setTakingPicture(false);
    } else {
      setTakingPicture(false);
    }
  }

  Future<void> startCountdown({int? from}) async {
    _countDown = from ?? 5;
    notifyListeners();

    for (int i = _countDown; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      _countDown--;
      notifyListeners();
    }
  }

  Future<void> takePictureForAddFace(String personName) async {
    setTakingPicture(true);

    await startCountdown();

    setBusy(true);

    XFile? picture = await _camera.takePicture();

    if (picture != null) {
      Uint8List? bytes = kIsWeb
          ? await ImageUtils.convertImageURLToBytes(picture.path)
          : await picture.readAsBytes();
      await sendFace(personName, bytes!);
    } else {
      setBusy(false);
      if (context.mounted) {
        WidgetUtils.showSnackBar(
          context,
          context.l10n.error_taking_picture,
          fromTop: true,
        );
      }
    }

    setTakingPicture(false);
  }

  Future<void> sendFace(String personName, Uint8List fileBytes) async {
    setBusy(true);
    ApiResponse response = await _api.addFace(personName, fileBytes);

    if (response.hasData) {
      if (context.mounted) {
        WidgetUtils.showSnackBar(
          context,
          CommonUtils.getLocalizedString(context, context.l10n.face_added),
          fromTop: true,
        );
      }
    } else {
      if (context.mounted) {
        debugPrint(response.error!);
        WidgetUtils.showSnackBar(context, response.error!, fromTop: true);
      }
    }
    setBusy(false);
  }

  Future<void> navigateToSettings() async {
    if (!context.mounted) {
      return;
    }

    _api.cancelOngoingRequests();
    String storedPassword = _storage.getMasterPassword();
    if (storedPassword.isEmpty) {
      await context.push(Routes.settings);
      return;
    }

    setBottomSheetVisible(true);
    bool passwordOk = await WidgetUtils.askPassword(context);

    if (passwordOk && context.mounted) {
      await context.push(Routes.settings);
    }

    setBottomSheetVisible(false);

    // Used for Mac to avoid black screen
    notifyListeners();
  }

  Future<void> showSettingsBottomSheet({String? defaultPerson, bool skipPassword = false}) async {
    if (isAnalyzing) {
      return;
    }

    if (!skipPassword) {
      setBottomSheetVisible(true);
      bool res = await WidgetUtils.askPassword(context);

      if (!res) {
        setBottomSheetVisible(false);
        return;
      }
    }

    if (context.mounted) {
      SheetOperation result = await WidgetUtils.showSettingsBottomSheet(
        context: context,
        defaultPerson: defaultPerson,
      );

      if (result.type == SheetOperationType.takePhoto) {
        await takePictureForAddFace(result.user!);
        await showSettingsBottomSheet(
          defaultPerson: result.user!,
          skipPassword: true,
        );
      }

      setBottomSheetVisible(false);
    }
  }

  Future<void> showCameraSettingsBottomSheet() async {
    if (isAnalyzing) {
      return;
    }

    setBottomSheetVisible(true);
    bool res = await WidgetUtils.askPassword(context);

    if (!res) {
      setBottomSheetVisible(false);
      return;
    }

    if (context.mounted) {
      await WidgetUtils.showCameraSettingsBottomSheet(context: context);
      setBottomSheetVisible(false);
    }
  }

  void cancelRecognizeApiRequest() {
    setAnalyzing(false);
    _api.cancelOngoingRequests();
  }

  void setAnalyzing(bool value) {
    isAnalyzing = value;
    notifyListeners();
  }

  void setTakingPicture(bool value) {
    _isTakingPicture = value;
    notifyListeners();
  }

  void setBottomSheetVisible(bool value) {
    _optionsVisible = value;
    notifyListeners();
  }

  void toggleRecognizeEnabled() {
    _recognizeEnabled.value = !_recognizeEnabled.value;
    notifyListeners();
  }

  void enableRecognize() {
    _recognizeEnabled.value = true;
    notifyListeners();
  }

  void disableRecognize() {
    _recognizeEnabled.value = false;
    notifyListeners();
  }

  Future<void> test() async {
    recognizedName = null;
    _recognizedPath = null;

    _userFound = null;
    setAnalyzing(true);
    await Future.delayed(const Duration(seconds: 2));

    // simulate recognition FOUND
    _userFound = true;
    recognizedName = 'Piero';

    String? encodedImage = await _database.getItemByKey(
      DatabaseService.usersStoreName,
      recognizedName!,
    );
    if (encodedImage != null) {
      _recognizedPath = base64Decode(encodedImage);
    }

    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    setAnalyzing(false);
    _userFound = null;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
