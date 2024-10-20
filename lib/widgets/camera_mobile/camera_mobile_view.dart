import 'package:camera/camera.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/widgets/camera_mobile/camera_mobile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CameraMobileView extends StatelessWidget {
  static GlobalKey cameraMobileWidgetKey = GlobalKey();

  final Function(InputImage inputImage)? onImage;

  const CameraMobileView({super.key, this.onImage});

  @override
  Widget build(BuildContext context) {
    bool shouldShowFaceFrame = Provider.of<SettingsProvider>(context).getAutodetectFace();

    return ViewModelBuilder<CameraMobileViewModel>.reactive(
      viewModelBuilder: () => CameraMobileViewModel(
        context: context,
        onImage: onImage,
      ),
      builder: (builderContext, model, child) {
        if (model.isChangingCamera ||
            model.cameraController == null ||
            !model.cameraController!.value.isInitialized) {
          return Center(
            child: Text(
              CommonUtils.getLocalizedString(
                builderContext,
                model.isChangingCamera
                    ? builderContext.l10n.no_camera_found
                    : builderContext.l10n.changing_camera,
              ),
            ),
          );
        }

        //final size = MediaQuery.of(context).size;
        //final scale = DeviceUtils.getPreviewScale(context, model.cameraController!);

        // Render the preview from the camera full screen
        // For unscaled camera, return only the CameraPreview widget
        // return CameraPreview(
        //   model.cameraController!,
        //   child: model.customPaint,
        // );

        // As of camera version 0.11.0 the front camera on android is mirrored
        // so we need to flip the preview horizontally
        return CameraPreviewFlipFull(
          model: model,
          shouldShowFaceFrame: shouldShowFaceFrame,
        );
      },
    );
  }
}

class CameraPreviewFlipFull extends StatelessWidget {
  final CameraMobileViewModel model;
  final bool shouldShowFaceFrame;

  const CameraPreviewFlipFull({
    super.key,
    required this.model,
    required this.shouldShowFaceFrame,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scale = DeviceUtils.getPreviewScale(context, model.cameraController);

    if (DeviceUtils.isAndroid() &&
        model.cameraController!.description.lensDirection == CameraLensDirection.front) {
      return Stack(
        children: [
          Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: size.width / scale,
                  height: size.height,
                  child: Stack(
                    children: [
                      Center(
                        child: Transform.flip(
                          flipX: true,
                          child: CameraPreview(model.cameraController!),
                        ),
                      ),
                      if (shouldShowFaceFrame)
                        Positioned.fill(
                          child: model.customPaint ?? const SizedBox.shrink(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: size.width / scale,
                height: size.height,
                child: CameraPreview(
                  model.cameraController!,
                  child: shouldShowFaceFrame ? model.customPaint : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CameraPreviewFlip extends StatelessWidget {
  final CameraMobileViewModel model;
  final bool shouldShowFaceFrame;

  const CameraPreviewFlip({
    super.key,
    required this.model,
    required this.shouldShowFaceFrame,
  });

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid() &&
        model.cameraController!.description.lensDirection == CameraLensDirection.front) {
      return Stack(
        children: [
          Center(
            child: Transform.flip(
              flipX: true,
              child: CameraPreview(model.cameraController!),
            ),
          ),
          if (shouldShowFaceFrame)
            Positioned.fill(child: model.customPaint ?? const SizedBox.shrink()),
        ],
      );
    }
    return Stack(
      children: [
        Center(
          child: CameraPreview(
            model.cameraController!,
            child: shouldShowFaceFrame ? model.customPaint : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
