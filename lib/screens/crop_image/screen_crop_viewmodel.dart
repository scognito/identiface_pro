// ignore_for_file: avoid-missing-image-alt

import 'dart:io';

import 'package:crop_image/crop_image.dart';
import 'package:face_detector/utils/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class ScreenCropViewModel extends FutureViewModel {
  final BuildContext context;
  final String imagePath;

  Image? _image;

  Image? get image => _image;

  ScreenCropViewModel({required this.context, required this.imagePath});

  @override
  Future futureToRun() async {
    await createImageToCrop();
  }

  final _cropController = CropController(
    aspectRatio: 12 / 16,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  CropController get cropController => _cropController;

  Future<void> createImageToCrop() async {
    if (!kIsWeb) {
      _image = Image.file(File(imagePath));
    } else {
      Uint8List? imageBytes = await ImageUtils.convertImageURLToBytes(imagePath);
      if (imageBytes != null) {
        // String base64String = base64Encode(imageBytes);
        // debugPrint('prima della modifica: ${base64String.length}');
        _image = Image.memory(imageBytes);
      }
    }
  }

  void onCancelButtonPressed() {
    context.pop();
  }

  Future<void> onDoneButtonPressed() async {
    Image imageCropped = await _cropController.croppedImage(quality: FilterQuality.medium);

    String? base64String = await ImageUtils.convertImageToBase64(imageCropped);

    debugPrint('dopo modifica: ${base64String?.length}');

    if (context.mounted) {
      context.pop(imageCropped);
    }
  }

  @override
  void dispose() {
    _cropController.dispose();
    super.dispose();
  }
}
