import 'package:camera/camera.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/camera_service/icamera_strategy.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:flutter/foundation.dart';

class MobileCameraStrategy implements ICameraStrategy {
  final _storage = locator.get<StorageService>();

  CameraController? _cameraController;

  int _cameraIndex = -1;
  bool _lockOrientation = false;
  bool _changingCameraLens = false;

  MobileCameraStrategy() {
    _cameraIndex = _storage.getCameraIndex();
    _lockOrientation = _storage.getLockOrientation();
  }

  late CameraDescription _cameraDevice;

  @override
  Future<void> setupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    if (_cameraIndex == -1) {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == CameraLensDirection.front) {
          _cameraIndex = i;
          break;
        }
      }
    }

    if (_cameraIndex == -1) {
      _cameraIndex = 0;
    }

    _cameraDevice = cameras[_cameraIndex];

    _cameraController = CameraController(
      cameras[_cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: DeviceUtils.isAndroid() ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();
  }

  @override
  dynamic getCameraController() => _cameraController;

  @override
  CameraDescription getCameraDevice() => _cameraDevice;

  @override
  Future<XFile?> takePicture() async {
    XFile? picture;

    if (_cameraController == null) {
      return null;
    }
    try {
      picture = await _cameraController!.takePicture();
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }

    return picture;
  }

  @override
  Future<int> getCameraCount() async {
    return (await availableCameras()).length;
  }

  @override
  Future<void> changeCamera() async {
    int cameraCount = await getCameraCount();

    if (cameraCount > 1) {
      _changingCameraLens = true;
      _cameraIndex = (_cameraIndex + 1) % cameraCount;

      debugPrint('Using camera index: $_cameraIndex, of $cameraCount cameras');

      CameraController? oldController = _cameraController;

      if (oldController != null) {
        await oldController.dispose();
      }

      await setupCameraController();

      _storage.setCameraIndex(_cameraIndex);

      _changingCameraLens = false;
    }
  }

  @override
  int getCameraOrientation() {
    return 0;
  }

  @override
  Future<void> setCameraOrientation(int orientation) async {
    debugPrint('Not implemented');
  }

  @override
  Future<void> changeOrientation() async {
    debugPrint('Not implemented');
  }

  @override
  bool isCameraLocked() {
    return _lockOrientation;
    //return _cameraController!.value.isCaptureOrientationLocked;
  }

  @override
  Future<void> setCameraLocked(bool lock) async {
    if (!lock) {
      await _cameraController?.unlockCaptureOrientation();
    }

    await _cameraController?.lockCaptureOrientation();

    _lockOrientation = lock;
  }

  @override
  bool hasFeature(CameraFeature feature) {
    switch (feature) {
      case CameraFeature.rotate:
      case CameraFeature.lock:
        return false;
    }
  }

  @override
  bool hasFeatures() {
    for (var feature in CameraFeature.values) {
      if(hasFeature(feature)){
        return true;
      }
    }
    return false;
  }

  @override
  bool isChangingCameraLens() => _changingCameraLens;

  @override
  Future<void> startCameraStream(Function(CameraImage) onImage) async {
    if (kIsWeb) {
      return;
    }
    if (_cameraController == null || !_cameraController!.value.isInitialized || isStreaming()) {
      return;
    }
    await _cameraController!.startImageStream(onImage);
  }

  @override
  Future<void> stopCameraStream() async {
    if (kIsWeb) {
      return;
    }
    if (!isStreaming()) {
      return;
    }
    await _cameraController?.stopImageStream();
  }

  @override
  Future<void> startCameraStreamSafe(Function(CameraImage) onImage) async {
    if (kIsWeb) {
      return;
    }
    if (isStreaming()) {
      await stopCameraStream();
    }

    await startCameraStream(onImage);
  }

  @override
  isStreaming() {
    return _cameraController?.value.isStreamingImages ?? false;
  }
}
