import 'package:camera/camera.dart';
import 'package:camera_linux/camera_linux.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/camera_service/icamera_strategy.dart';
import 'package:flutter/foundation.dart';

/*

  Almost dummy as Linux Camera is very basic and doesn't even have a controller
  We mock controller returning the plugin itself

 */
class LinuxCameraStrategy implements ICameraStrategy {
  late CameraLinux _cameraLinuxPlugin;

  @override
  Future<void> setupCameraController() async {
    _cameraLinuxPlugin = CameraLinux();
    await _cameraLinuxPlugin.initializeCamera();
  }

  @override
  dynamic getCameraController() => _cameraLinuxPlugin;

  @override
  CameraDescription getCameraDevice() => const CameraDescription(
        name: 'Linux',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      );

  @override
  Future<XFile?> takePicture() async {
    XFile? picture = await _cameraLinuxPlugin.takePicture();
    return picture;
  }

  @override
  Future<int> getCameraCount() async {
    return 1;
  }

  @override
  Future<void> changeCamera() async {
    debugPrint('Not implemented');
  }

  @override
  int getCameraOrientation() {
    debugPrint('Not implemented');
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
    debugPrint('Not implemented');
    return true;
  }

  @override
  Future<void> setCameraLocked(bool lock) async {
    debugPrint('Not implemented');
  }

  @override
  bool hasFeature(CameraFeature feature) {
    switch (feature) {
      case CameraFeature.lock:
      case CameraFeature.rotate:
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
  bool isChangingCameraLens() => false;

  @override
  Future<void> startCameraStream(Function(CameraImage) onImage) async {
    debugPrint('Not implemented');
  }

  @override
  Future<void> stopCameraStream() async {
    debugPrint('Not implemented');
  }

  @override
  Future<void> startCameraStreamSafe(Function(CameraImage) onImage) async {
    debugPrint('Not implemented');
  }

  @override
  isStreaming() {
    debugPrint('Not implemented');
    return false;
  }
}
