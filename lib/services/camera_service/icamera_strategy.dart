import 'package:camera/camera.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';

abstract class ICameraStrategy {
  Future<void> setupCameraController();

  dynamic getCameraController();

  CameraDescription getCameraDevice();

  Future<XFile?> takePicture();

  Future<int> getCameraCount();

  Future<void> changeCamera();

  int getCameraOrientation();

  Future<void> setCameraOrientation(int orientation);

  Future<void> changeOrientation();

  bool isCameraLocked();

  Future<void> setCameraLocked(bool lock);

  bool hasFeature(CameraFeature feature);

  bool hasFeatures();

  bool isChangingCameraLens();

  Future<void> startCameraStream(Function(dynamic) onImage);

  Future<void> stopCameraStream();

  Future<void> startCameraStreamSafe(Function(dynamic) onImage);

  bool isStreaming();
}
