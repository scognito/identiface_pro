import 'dart:async';

import 'package:face_detector/locator.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CameraLinuxViewModel extends FutureViewModel {
  final _camera = locator.get<CameraService>();

  String imageData = '';

  @override
  Future<void> futureToRun() async {
    debugPrint('Stating capturing frames');
    unawaited(streamFrames());
  }

  Future<void> streamFrames() async {
    while (true) {
      imageData = await _camera.getCameraController().captureImage();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }
}
