// ignore_for_file: avoid-missing-image-alt, avoid-unsafe-collection-methods

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/filesystem_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  // Code from: https://github.com/flutter-ml/google_ml_kit_flutter/blob/develop/packages/example/lib/vision_detector_views/camera_view.dart
  static InputImage? convertCameraImageToInputImage(CameraImage image) {
    final camera = locator.get<CameraService>();
    if (camera.getCameraController() == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart

    final cameraDec = (camera.getCameraController() as CameraController).description;
    final sensorOrientation = cameraDec.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (DeviceUtils.isIOS()) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (DeviceUtils.isAndroid()) {
      var rotationCompensation =
          _orientations[camera.getCameraController()?.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (cameraDec.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (DeviceUtils.isAndroid() &&
            (format != InputImageFormat.nv21 && format != InputImageFormat.yuv_420_888)) ||
        (DeviceUtils.isIOS() && format != InputImageFormat.bgra8888)) return null;

    if (DeviceUtils.isAndroid() && format == InputImageFormat.yuv_420_888) {
      Uint8List nv21Data = ImageUtils.convertYUV420ToNV21(image);

      return InputImage.fromBytes(
        bytes: nv21Data,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.width,
        ),
      );
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  // We need to convert InputImage to bytes in order to send the data to the API for recognition
  static Uint8List? convertInputImageToBytes(InputImage inputImage) {
    img.Image? decodedImage;

    try {
      debugPrint('Image format is ${inputImage.metadata?.format ?? 'not recognized'}');

      switch (inputImage.metadata?.format) {
        case InputImageFormat.yuv_420_888: // Android
          decodedImage = ImageUtils.decodeYUV420SP(inputImage);
          break;
        case InputImageFormat.nv21: // Android (but not used anymore from cameraX ?)
          decodedImage = ImageUtils.decodeNV21(inputImage);
          break;
        case InputImageFormat.bgra8888: // Apple
          decodedImage = ImageUtils.decodeBGRA8888(inputImage);
          break;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error decoding image: $e');
      return null;
    }

    img.Image resizedImage = img.copyResize(decodedImage, width: 512);

    final Uint8List bytes = Uint8List.fromList(img.encodeJpg(resizedImage));

    return bytes;
  }

  // Android stuff
  static img.Image decodeYUV420SP(InputImage image) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    final yuv420sp = image.bytes!;
    // The math for converting YUV to RGB below assumes you're
    // putting the RGB into a uint32. To simplify and keep the
    // code as it is, make a 4-channel Image, get the image data bytes,
    // and view it at a Uint32List. This is the equivalent to the image
    // data of the 3.x version of the Image library. It does waste some
    // memory, the alpha channel isn't used, but it simplifies the math.
    final outImg = img.Image(width: width, height: height, numChannels: 4);
    final outBytes = outImg.getBytes();
    // View the image data as a Uint32List.
    final rgba = Uint32List.view(outBytes.buffer);

    final frameSize = width * height;

    for (var j = 0, yp = 0; j < height; j++) {
      var uvp = frameSize + (j >> 1) * width;
      var u = 0;
      var v = 0;
      for (int i = 0; i < width; i++, yp++) {
        var y = (0xff & (yuv420sp[yp])) - 16;
        if (y < 0) {
          y = 0;
        }
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }

        final y1192 = 1192 * y;
        var r = (y1192 + 1634 * v);
        var g = (y1192 - 833 * v - 400 * u);
        var b = (y1192 + 2066 * u);

        if (r < 0) {
          r = 0;
        } else if (r > 262143) {
          r = 262143;
        }
        if (g < 0) {
          g = 0;
        } else if (g > 262143) {
          g = 262143;
        }
        if (b < 0) {
          b = 0;
        } else if (b > 262143) {
          b = 262143;
        }

        // Write directly into the image data
        rgba[yp] = 0xff000000 | ((b << 6) & 0xff0000) | ((g >> 2) & 0xff00) | ((r >> 10) & 0xff);
      }
    }

    switch (image.metadata!.rotation) {
      case InputImageRotation.rotation0deg:
        return img.copyRotate(outImg, angle: 0);
      case InputImageRotation.rotation90deg:
        return img.copyRotate(outImg, angle: 90);
      case InputImageRotation.rotation180deg:
        return img.copyRotate(outImg, angle: 180);
      case InputImageRotation.rotation270deg:
        return img.copyRotate(outImg, angle: 270);
    }
  }

  // Android stuff (unused?)
  static img.Image decodeNV21(InputImage image) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    final nv21 = image.bytes!;
    final outImg = img.Image(width: width, height: height, numChannels: 4);
    final outBytes = outImg.getBytes();
    final rgba = Uint32List.view(outBytes.buffer);

    final frameSize = width * height;

    for (var j = 0, yp = 0; j < height; j++) {
      var uvp = frameSize + (j >> 1) * width;
      var u = 0;
      var v = 0;
      for (int i = 0; i < width; i++, yp++) {
        var y = (0xff & (nv21[yp])) - 16;
        if (y < 0) y = 0;

        if ((i & 1) == 0) {
          v = (0xff & nv21[uvp++]) - 128;
          u = (0xff & nv21[uvp++]) - 128;
        }

        final y1192 = 1192 * y;
        var r = (y1192 + 1634 * v);
        var g = (y1192 - 833 * v - 400 * u);
        var b = (y1192 + 2066 * u);

        if (r < 0) {
          r = 0;
        } else if (r > 262143) {
          r = 262143;
        }
        if (g < 0) {
          g = 0;
        } else if (g > 262143) {
          g = 262143;
        }
        if (b < 0) {
          b = 0;
        } else if (b > 262143) {
          b = 262143;
        }

        rgba[yp] = 0xff000000 | ((b << 6) & 0xff0000) | ((g >> 2) & 0xff00) | ((r >> 10) & 0xff);
      }
    }

    switch (image.metadata!.rotation) {
      case InputImageRotation.rotation0deg:
        return img.copyRotate(outImg, angle: 0);
      case InputImageRotation.rotation90deg:
        return img.copyRotate(outImg, angle: 90);
      case InputImageRotation.rotation180deg:
        return img.copyRotate(outImg, angle: 180);
      case InputImageRotation.rotation270deg:
        return img.copyRotate(outImg, angle: 270);
    }
  }

  // Apple stuff
  static img.Image decodeBGRA8888(InputImage image) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    final Uint8List bgra8888 = image.bytes!;
    final Uint8List rgba8888 = Uint8List(width * height * 4);

    // Correcting the byte channel mapping otherwise the image has blue tint
    if (DeviceUtils.isIOS()) {
      for (int i = 0, j = 0; i < bgra8888.length; i += 4, j += 4) {
        rgba8888[j] = bgra8888[i + 2]; // R <- B
        rgba8888[j + 1] = bgra8888[i + 1]; // G <- G
        rgba8888[j + 2] = bgra8888[i]; // B <- R
        rgba8888[j + 3] = bgra8888[i + 3]; // A <- A
      }
    } else {
      for (int i = 0, j = 0; i < bgra8888.length; i += 4, j += 4) {
        rgba8888[j] = bgra8888[i + 1]; // R
        rgba8888[j + 1] = bgra8888[i + 2]; // G
        rgba8888[j + 2] = bgra8888[i + 3]; // B
        rgba8888[j + 3] = bgra8888[i + 0]; // A
      }
    }

    img.Image outImg = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: rgba8888.buffer,
      order: img.ChannelOrder.rgba,
    );

    return outImg;

    // switch (image.metadata!.rotation) {
    //   case InputImageRotation.rotation0deg:
    //     return img.copyRotate(outImg, angle: 0);
    //   case InputImageRotation.rotation90deg:
    //     return img.copyRotate(outImg, angle: 90);
    //   case InputImageRotation.rotation180deg:
    //     return img.copyRotate(outImg, angle: 180);
    //   case InputImageRotation.rotation270deg:
    //     return img.copyRotate(outImg, angle: 270);
    //   default:
    //     return outImg; // Default case to return the image without rotation
    // }
  }

  // Function used to convert YUV420 to NV21 because from version 0.11.0 of camera plugin
  // the image returned from camera is in yuv420 format instead of nv21 (which is needed by InputImage constructor)
  static Uint8List convertYUV420ToNV21(CameraImage image) {
    final width = image.width;
    final height = image.height;

    // Planes from CameraImage
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    // Buffers from Y, U, and V planes
    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    // Total number of pixels in NV21 format
    final numPixels = width * height + (width * height ~/ 2);
    final nv21 = Uint8List(numPixels);

    // Y (Luma) plane metadata
    int idY = 0;
    int idUV = width * height; // Start UV after Y plane
    final uvWidth = width ~/ 2;
    final uvHeight = height ~/ 2;

    // Strides and pixel strides for Y and UV planes
    final yRowStride = yPlane.bytesPerRow;
    final yPixelStride = yPlane.bytesPerPixel ?? 1;
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 2;

    // Copy Y (Luma) channel
    for (int y = 0; y < height; ++y) {
      final yOffset = y * yRowStride;
      for (int x = 0; x < width; ++x) {
        nv21[idY++] = yBuffer[yOffset + x * yPixelStride];
      }
    }

    // Copy UV (Chroma) channels in NV21 format (YYYYVU interleaved)
    for (int y = 0; y < uvHeight; ++y) {
      final uvOffset = y * uvRowStride;
      for (int x = 0; x < uvWidth; ++x) {
        final bufferIndex = uvOffset + (x * uvPixelStride);
        nv21[idUV++] = vBuffer[bufferIndex]; // V channel
        nv21[idUV++] = uBuffer[bufferIndex]; // U channel
      }
    }

    return nv21;
  }

  static Uint8List? resizeBinaryImage({
    required Uint8List imageData,
    int? maxWidth,
    int? maxHeight,
  }) {
    if (maxWidth == null && maxHeight == null) {
      return null;
    }

    img.Image? originalImage = img.decodeImage(imageData);

    if (originalImage == null) {
      debugPrint('Could not decode image');
      return null;
    }

    double aspectRatio = originalImage.width / originalImage.height;
    int newWidth;
    int newHeight;

    if (maxWidth != null && maxHeight == null) {
      newWidth = maxWidth;
      newHeight = (maxWidth / aspectRatio).round();
    } else if (maxWidth == null && maxHeight != null) {
      newHeight = maxHeight;
      newWidth = (maxHeight * aspectRatio).round();
    } else {
      newWidth = maxWidth!;
      newHeight = maxHeight!;
    }

    img.Image resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.average,
    );

    return img.encodeJpg(resizedImage);
  }

  // used for blobs on Flutter Web
  static Future<Uint8List?> convertImageURLToBytes(String imageURL) async {
    try {
      Dio dio = Dio();

      // Fetch the image data from the URL
      final response = await dio.get(imageURL, options: Options(responseType: ResponseType.bytes));

      if (response.statusCode == 200) {
        // If the request is successful, return the body as a Uint8List
        return response.data;
      }
      debugPrint('Failed to load image: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String?> convertImageToBase64(Image image) async {
    try {
      // Step 1: Convert the image to an ImageProvider (assuming AssetImage or NetworkImage)
      final ImageProvider imageProvider = image.image;

      // Step 2: Resolve the image and obtain a ImageStream
      final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
      final Completer<ui.Image> completer = Completer<ui.Image>();

      // Step 3: Add a listener to get the image once it is available
      stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }));

      // Step 4: Wait for the image to be loaded
      final ui.Image loadedImage = await completer.future;

      // Step 5: Convert the ui.Image to byte data
      final ByteData? byteData = await loadedImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        // Step 6: Convert the byte data to Uint8List
        final Uint8List uint8List = byteData.buffer.asUint8List();

        // Step 7: Convert the Uint8List to Base64 string
        String base64String = base64Encode(uint8List);

        return base64String;
      }
    } catch (e) {
      debugPrint('Error converting image to base64: $e');
    }
    return null;
  }

  static Future<Uint8List?> convertImageToBytes(Image image) async {
    // Create a Completer to handle asynchronous image loading
    final Completer<ui.Image> completer = Completer<ui.Image>();

    // Start loading the image
    final ImageStream imageStream = image.image.resolve(const ImageConfiguration());

    // Attach a one-time listener to the imageStream
    imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        // Complete the Completer with the loaded image
        completer.complete(info.image);
      }),
    );

    // Wait for the image to be fully loaded
    final ui.Image uiImage = await completer.future;

    final ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to convert image to byte data');
    }

    final Uint8List bytes = byteData.buffer.asUint8List();

    return bytes;
  }

  static Future<bool> convertInputImageToFile({
    required InputImage inputImage,
    String? imageSavePath,
  }) async {
    if (imageSavePath == null) {
      final Directory dir = await FileSystemUtils.getMediaDirectory();
      imageSavePath = '${dir.path}/face_reco.jpg';
    }

    img.Image? decodedImage;
    try {
      debugPrint('Image format is ${inputImage.metadata?.format ?? 'not recognized'}');

      switch (inputImage.metadata?.format) {
        case InputImageFormat.yuv_420_888:
          decodedImage = ImageUtils.decodeYUV420SP(inputImage);
          break;
        case InputImageFormat.bgra8888:
          decodedImage = ImageUtils.decodeBGRA8888(inputImage);
          break;
        case InputImageFormat.nv21:
          decodedImage = ImageUtils.decodeNV21(inputImage);
          break;
        default:
          return false;
      }
    } catch (e) {
      debugPrint('Error decoding image: $e');
      return false;
    }

    img.Image resizedImage = img.copyResize(decodedImage, width: 512);
    final bool saved = await img.encodeJpgFile(imageSavePath, resizedImage);

    debugPrint('Image saved: $saved with path: $imageSavePath');

    return saved;
  }

  static Future<String?> resizeImageFile({
    required String imagePath,
    int? maxWidth,
    int? maxHeight,
  }) async {
    if (maxWidth == null && maxHeight == null) {
      return null;
    }

    Uint8List imageBytes = await File(imagePath).readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      debugPrint('Could not decode image');
      return null;
    }

    double aspectRatio = originalImage.width / originalImage.height;
    int newWidth;
    int newHeight;

    if (maxWidth != null && maxHeight == null) {
      newWidth = maxWidth;
      newHeight = (maxWidth / aspectRatio).round();
    } else if (maxWidth == null && maxHeight != null) {
      newHeight = maxHeight;
      newWidth = (maxHeight * aspectRatio).round();
    } else {
      newWidth = maxWidth!;
      newHeight = maxHeight!;
    }

    img.Image resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.average,
    );

    final tempDir = await getTemporaryDirectory();
    final targetPath = join(tempDir.path, 'resized_avatar.jpg');

    File resizedFile = File(targetPath);
    resizedFile.writeAsBytes(img.encodeJpg(resizedImage));
    return resizedFile.path;
  }

  static Future<File> saveImageToTemporaryFile(Image image) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/temp_image.png';

    await FileSystemUtils.deleteFile(tempPath);

    final File tempFile = File(tempPath);

    final Uint8List? bytes = await convertImageToBytes(image);
    await tempFile.writeAsBytes(bytes!);

    return tempFile;
  }
}

final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};
