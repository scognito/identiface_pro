import 'package:face_detector/config/app_colors.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/widgets/camera_mac/camera_mac_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CameraMacView extends StatelessWidget {
  static GlobalKey cameraMacWidgetKey = GlobalKey();

  final Function(List<Rect> faces, InputImage inputImage)? onFacesDetected;
  final ValueNotifier<bool> enableRecognize;

  const CameraMacView({
    this.onFacesDetected,
    required this.enableRecognize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraMacViewModel>.reactive(
      viewModelBuilder: () => CameraMacViewModel(
        context: context,
        onFacesDetected: onFacesDetected,
        enableRecognizeNotifier: enableRecognize,
      ),
      builder: (builderContext, model, child) {
        if (model.isBusy) {
          return const Center(child: CircularProgressIndicator());
        }

        String debug = '';

        Size? widgetSize;
        if (cameraMacWidgetKey.currentContext?.findRenderObject() != null) {
          RenderBox renderBox = cameraMacWidgetKey.currentContext!.findRenderObject() as RenderBox;

          debug +=
              'RenderBox width: ${renderBox.size.width.toStringAsFixed(3)} x ${renderBox.size.height.toStringAsFixed(3)}\n';
          widgetSize = Size(renderBox.size.width, renderBox.size.height);
        }

        widgetSize ??= Size(model.pictureSize.width, model.pictureSize.height);

        if (model.faceData != null && model.faceData!.isNotEmpty) {
          Rect rect = model.faceData!.first;
          debug += 'Width: ${rect.width.toStringAsFixed(3)}';
          debug += '\nHeight: ${rect.height.toStringAsFixed(3)}';
          debug += '\nQuery width: ${MediaQuery.sizeOf(builderContext).width.toStringAsFixed(3)}';
          debug += '\nQuery height: ${MediaQuery.sizeOf(builderContext).height.toStringAsFixed(3)}';
          debug += '\nCamera width: ${model.cameraController!.args.size.width.toStringAsFixed(3)}';
          debug +=
              '\nCamera height: ${model.cameraController!.args.size.height.toStringAsFixed(3)}';
          debug += '\nImage Width: ${model.pictureSize.width.toStringAsFixed(3)}';
          debug += '\nImage Height: ${model.pictureSize.height.toStringAsFixed(3)}';
        }

        //double aspectRatio = model.cameraController!.args.size.width / model.cameraController!.args.size.height;
        if (debug.isNotEmpty && kIsDebugLocal) {
          debugPrint(debug);
        }

        bool shouldShowFaceFrame = Provider.of<SettingsProvider>(builderContext).getAutodetectFace();

        return AspectRatio(
          aspectRatio: model.getCameraAspectRatio(),
          child: Stack(
            children: [
              Texture(textureId: model.cameraController!.args.textureId!),
              if (shouldShowFaceFrame &&
                  model.faceData != null &&
                  model.faceData!.isNotEmpty &&
                  enableRecognize.value)
                for (int i = 0; i < model.faceData!.length; i++)
                  FaceFrame(
                    model: model,
                    i: i,
                    parentSize: widgetSize,
                    cameraOrientation: model.cameraOrientation,
                  ),
              // if (model.faceData != null && model.faceData!.isNotEmpty)
              //   Positioned(
              //     top: 20,
              //     left: 20,
              //     right: 20,
              //     child: Center(
              //       child: Text(
              //         debug,
              //         style: AppText.font15Regular.copyWith(color: Colors.white),
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }
}

class FaceFrame extends StatelessWidget {
  final CameraMacViewModel model;
  final Size parentSize;
  final int i;
  final int cameraOrientation;

  const FaceFrame({
    required this.model,
    required this.i,
    required this.parentSize,
    required this.cameraOrientation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double widthScale = parentSize.width / model.pictureSize.width;
    final double heightScale = parentSize.height / model.pictureSize.height;

    double? calculatedWidth;
    double? calculatedHeight;

    if (cameraOrientation == 0 || cameraOrientation == 180) {
      calculatedWidth = model.faceData![i].width * model.pictureSize.width * widthScale;
      calculatedHeight = model.faceData![i].height * model.pictureSize.height * heightScale;
    } else {
      calculatedWidth = model.faceData![i].height * model.pictureSize.width * widthScale;
      calculatedHeight = model.faceData![i].width * model.pictureSize.height * heightScale;
    }

    return Positioned(
      top: model.faceData![i].top * heightScale,
      left: model.faceData![i].left * widthScale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: calculatedWidth,
            height: calculatedHeight,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 2, color: AppColors.defaultThemeHudCyan),
            ),
          ),
          //Text('W: ${constraints.maxWidth}\nH: ${constraints.maxHeight}', style: AppText.font15Regular.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
