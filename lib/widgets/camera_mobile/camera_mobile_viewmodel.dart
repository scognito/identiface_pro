import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/image_utils.dart';
import 'package:face_detector/widgets/custom_painters/face_detector_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:stacked/stacked.dart';

class CameraMobileViewModel extends BaseViewModel {
  final _camera = locator.get<CameraService>();
  final _storage = locator.get<StorageService>();
  final _bus = locator.get<EventBus>();

  late StreamSubscription<EventBusEvent> _cameraEventbusSubscription;

  CameraController? get cameraController => _camera.getCameraController() as CameraController?;
  bool isChangingCamera = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  CustomPaint? get customPaint => _customPaint;

  late final FaceDetector _faceDetector;

  FaceDetectorPainter? _painter;

  BuildContext context;
  final Function(InputImage inputImage)? onImage;

  CameraMobileViewModel({required this.context, this.onImage}) {
    setupCamera();
  }

  Future<void> setupCamera() async {
    _cameraEventbusSubscription = _bus.on().listen((event) {
      switch (event) {
        case EventBusEvent.cameraSwitch:
          changeCamera();
          break;
        case EventBusEvent.startCameraStream:
          _camera.startCameraStreamSafe(_processCameraImage);
          break;
        case EventBusEvent.stopCameraStream:
          _camera.stopCameraStream().then((_) {
            _painter = null;
            _customPaint = CustomPaint(painter: _painter);
            notifyListeners();
          });
          break;
        default:
          break;
      }
    });

    // There is no face detector for web
    if (!kIsWeb) {
      _faceDetector = FaceDetector(options: FaceDetectorOptions());

      if (_storage.getAutodetectFace() == true) {
        await _camera.startCameraStreamSafe(_processCameraImage);
      }
    }
  }

  Future<void> changeCamera() async {
    isChangingCamera = true;
    notifyListeners();
    try {
      await _camera.changeCamera();
      if (_storage.getAutodetectFace() == true) {
        _camera.startCameraStreamSafe(_processCameraImage);
      }
    } catch (e) {
      debugPrint('Error switching camera: $e');
    } finally {
      isChangingCamera = false;
      notifyListeners();
    }
  }

  Future<void> _processCameraImage(dynamic image) async {
    // we don't want to detect faces if autodetect is off
    // if (!Provider.of<SettingsProvider>(context, listen: false).getAutodetectFace()) {
    //   _customPaint = null;
    //   return;
    // }

    final inputImage = ImageUtils.convertCameraImageToInputImage(image as CameraImage);
    if (inputImage == null) return;

    // pass image to detector and draw rectangles on faces
    if (await findFaces(inputImage) > 0) {
      if (onImage != null) {
        // if there are faces, pass the image to the parent widget
        // so it can be passed to the server for recognize faces
        onImage!(inputImage);
      }
    }
  }

  Future<int> findFaces(InputImage inputImage) async {
    if (_isBusy) return 0;
    _isBusy = true;

    notifyListeners();

    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      _painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _camera.getCameraDevice().lensDirection,
      );

      _customPaint = CustomPaint(painter: _painter);
    } else {
      _customPaint = null;
    }

    _isBusy = false;

    // serve?
    // if (context.mounted) {
    //   notifyListeners();
    // }

    return faces.length;
  }

  @override
  void dispose() async {
    await _cameraEventbusSubscription.cancel();
    if (!kIsWeb) {
      await _faceDetector.close();
    }
    super.dispose();
  }
}
