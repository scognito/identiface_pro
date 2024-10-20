import 'package:camera/camera.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/services/camera_service/icamera_strategy.dart';
import 'package:face_detector/services/camera_service/macos_camera_strategy.dart';
import 'package:face_detector/services/camera_service/mobile_camera_strategy.dart';
import 'package:face_detector/utils/device_utils.dart';

class CameraService {
  late ICameraStrategy _cameraStrategy;

  CameraService() {
    if (DeviceUtils.isMacOS()) {
      _cameraStrategy = MacOSCameraStrategy();
    } else {
      _cameraStrategy = MobileCameraStrategy();
    }
  }

  Future<void> setupCameraController() async {
    if (kUseDummyCamera) return;
    await _cameraStrategy.setupCameraController();
  }

  dynamic getCameraController() => _cameraStrategy.getCameraController();

  CameraDescription getCameraDevice() => _cameraStrategy.getCameraController().description;

  Future<XFile?> takePicture() async => await _cameraStrategy.takePicture();

  Future<int> getCameraCount() async => await _cameraStrategy.getCameraCount();

  Future<void> changeCamera() async => await _cameraStrategy.changeCamera();

  int getCameraOrientation() => _cameraStrategy.getCameraOrientation();

  Future<void> setCameraOrientation(int orientation) async =>
      await _cameraStrategy.setCameraOrientation(orientation);

  Future<void> changeOrientation() async => await _cameraStrategy.changeOrientation();

  bool isCameraLocked() => _cameraStrategy.isCameraLocked();

  Future<void> setCameraLocked(bool lock) async => await _cameraStrategy.setCameraLocked(lock);

  bool hasFeature(CameraFeature feature) => _cameraStrategy.hasFeature(feature);

  bool hasFeatures() => _cameraStrategy.hasFeatures();

  bool isChangingCameraLens() => _cameraStrategy.isChangingCameraLens();

  Future<void> startCameraStream(Function(dynamic) onImage) async =>
      await _cameraStrategy.startCameraStream(onImage);

  Future<void> stopCameraStream() async => await _cameraStrategy.stopCameraStream();

  Future<void> startCameraStreamSafe(Function(dynamic) onImage) async =>
      await _cameraStrategy.startCameraStreamSafe(onImage);

  bool isStreaming() => _cameraStrategy.isStreaming();
}

enum CameraFeature { lock, rotate }
