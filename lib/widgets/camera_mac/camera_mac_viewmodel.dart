import 'dart:async';

import 'package:apple_vision_face_detection/apple_vision_face_detection.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:stacked/stacked.dart';

class CameraMacViewModel extends FutureViewModel {
  final _camera = locator.get<CameraService>();
  final _storage = locator.get<StorageService>();
  final _bus = locator.get<EventBus>();

  AppleVisionFaceDetectionController visionController = AppleVisionFaceDetectionController();
  Size pictureSize = const Size(640, 640 * 9 / 16);

  bool loading = true;

  bool isReady = false;

  int cameraSides = 0;
  int cameraRotation = 0;

  bool isChangingCamera = false;

  int get cameraOrientation => _camera.getCameraOrientation();
  List<Rect>? faceData;

  late StreamSubscription<EventBusEvent> _cameraEventbusSubscription;

  final BuildContext context;
  final Function(List<Rect> faces, InputImage inputImage)? onFacesDetected;

  CameraMacOSController? get cameraController =>
      _camera.getCameraController() as CameraMacOSController?;
  final ValueNotifier<bool> enableRecognizeNotifier;

  CameraMacViewModel({
    required this.context,
    this.onFacesDetected,
    required this.enableRecognizeNotifier,
  }) {
    enableRecognizeNotifier.addListener(notifyListeners);
  }

  @override
  Future<void> futureToRun() async {
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
        case EventBusEvent.stopCameraStream:
          _camera.stopCameraStream().then((_) {
            faceData = [];
            notifyListeners();
          });
        default:
          break;
      }
    });

    if (_storage.getAutodetectFace() == true) {
      await _camera.startCameraStreamSafe(_processCameraImage);
    }
  }

  Future<void> _processCameraImage(dynamic cameraImageData) async {
    // we don't want to detect faces if autodetect is off
    // if (!Provider.of<SettingsProvider>(context, listen: false).getAutodetectFace()) {
    //   return;
    // }

    CameraImageData image = cameraImageData as CameraImageData;

    pictureSize = Size(image.width.toDouble(), image.height.toDouble());
    InputImage i = InputImage.fromBytes(
      bytes: image.bytes,
      metadata: InputImageMetadata(
        size: pictureSize,
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.bgra8888,
        bytesPerRow: 0,
      ),
    );

    if (i.metadata?.size != null) {
      pictureSize = i.metadata!.size;
    }

    if (context.mounted && enableRecognizeNotifier.value) {
      List<Rect>? faces = await visionController.processImage(
        image.bytes,
        Size(image.width.toDouble(), image.height.toDouble()),
      );
      if (faces != null && faces.isNotEmpty) {
        if (onFacesDetected != null) {
          onFacesDetected!(faces, i);
        }
        faceData = faces;
        notifyListeners();
      } else {
        faceData = [];
      }
    }
  }

  // not tested
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

  double getCameraAspectRatio() {
    int orientation = _camera.getCameraOrientation();

    Size cameraSize = _camera.getCameraController().args.size;

    double ratio = (orientation == 0 || orientation == 180)
        ? cameraSize.width / cameraSize.height
        : cameraSize.height / cameraSize.width;

    return ratio;
  }

  @override
  void dispose() async {
    await _cameraEventbusSubscription.cancel();

    // controller?.dispose();
    //cameraController?.destroy();
    //camera.dispose();
    enableRecognizeNotifier.removeListener(notifyListeners);
    super.dispose();
  }
}
