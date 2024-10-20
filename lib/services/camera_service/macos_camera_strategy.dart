import 'package:camera/camera.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/camera_service/icamera_strategy.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter/material.dart';

class MacOSCameraStrategy implements ICameraStrategy {
  final _storage = locator.get<StorageService>();

  CameraMacOSController? _cameraController;

  int _cameraIndex = -1;
  CameraOrientation _cameraOrientation = CameraOrientation.orientation0deg;
  bool _changingCameraLens = false;

  MacOSCameraStrategy() {
    _cameraIndex = _storage.getCameraIndex();
    _cameraOrientation = parseOrientation(_storage.getCameraOrientation());
  }

  @override
  Future<void> setupCameraController() async {
    try {
      var value = await CameraMacOSPlatform.instance.initialize(
        deviceId:
            _cameraIndex == -1 ? null : (await getCameraList()).elementAt(_cameraIndex).deviceId,
        audioDeviceId: null,
        cameraMacOSMode: CameraMacOSMode.video,
        enableAudio: false,
        resolution: PictureResolution.medium,
        pictureFormat: PictureFormat.jpg,
        orientation: _cameraOrientation,
      );
      _cameraController = CameraMacOSController(value!);
    } on CameraException catch (_) {
      debugPrint('error setup camera macos');
    }
  }

  @override
  dynamic getCameraController() => _cameraController;

  @override
  CameraDescription getCameraDevice() => throw UnimplementedError();

  @override
  Future<XFile?> takePicture() async {
    XFile? picture;
    try {
      CameraMacOSFile? file = await _cameraController?.takePicture();
      if (file != null) {
        picture = XFile.fromData(file.bytes!, path: file.url);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return picture;
  }

  Future<List<CameraMacOSDevice>> getCameraList() async {
    List<CameraMacOSDevice> cameraList =
        await CameraMacOS.instance.listDevices(deviceType: CameraMacOSDeviceType.video);
    return cameraList;
  }

  @override
  Future<int> getCameraCount() async {
    return (await getCameraList()).length;
  }

  @override
  Future<void> changeCamera() async {

    int cameraCount = await getCameraCount();

    if (cameraCount > 1) {
      _changingCameraLens = true;
      _cameraIndex = (_cameraIndex + 1) % cameraCount;

      debugPrint('Using camera index: $_cameraIndex, of $cameraCount cameras');

      await setupCameraController();
      _storage.setCameraIndex(_cameraIndex);
      _changingCameraLens = false;
    }
  }

  CameraOrientation parseOrientation(int orientation) {
    switch (orientation) {
      case 90:
        return CameraOrientation.orientation90deg;
      case 180:
        return CameraOrientation.orientation180deg;
      case 270:
        return CameraOrientation.orientation270deg;
      case 0:
      default:
        return CameraOrientation.orientation0deg;
    }
  }

  @override
  int getCameraOrientation() {
    switch (_cameraOrientation) {
      case CameraOrientation.orientation90deg:
        return 90;
      case CameraOrientation.orientation180deg:
        return 180;
      case CameraOrientation.orientation270deg:
        return 270;
      case CameraOrientation.orientation0deg:
      default:
        return 0;
    }
  }

  @override
  Future<void> setCameraOrientation(int orientation) async {
    _cameraOrientation = parseOrientation(orientation);
    await setupCameraController();
  }

  @override
  Future<void> changeOrientation() async {
    switch (_cameraOrientation) {
      case CameraOrientation.orientation90deg:
        _cameraOrientation = CameraOrientation.orientation180deg;
      case CameraOrientation.orientation180deg:
        _cameraOrientation = CameraOrientation.orientation270deg;
      case CameraOrientation.orientation270deg:
        _cameraOrientation = CameraOrientation.orientation0deg;
      case CameraOrientation.orientation0deg:
        _cameraOrientation = CameraOrientation.orientation90deg;
    }

    await setupCameraController();
  }

  @override
  bool isCameraLocked() {
    return false;
  }

  @override
  Future<void> setCameraLocked(bool lock) async {
    debugPrint('Not implemented');
  }

  @override
  bool hasFeature(CameraFeature feature) {
    switch (feature) {
      case CameraFeature.lock:
        return false;
      case CameraFeature.rotate:
        return true;
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
  Future<void> startCameraStream(Function(CameraImageData?) onImage) async {
    if (_cameraController == null || isStreaming()) {
      return;
    }

    await _cameraController!.startImageStream(onImage);
  }

  @override
  Future<void> startCameraStreamSafe(Function(CameraImageData?) onImage) async {
    if (isStreaming()) {
      await stopCameraStream();
    }

    await startCameraStream(onImage);
  }

  @override
  Future<void> stopCameraStream() async {
    if (!isStreaming()) {
      return;
    }

    await _cameraController?.stopImageStream();
  }

  @override
  isStreaming() {
    return _cameraController?.isStreamingImageData ?? false;
  }
}
