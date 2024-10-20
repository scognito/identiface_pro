import 'dart:convert';

import 'package:face_detector/widgets/camera_linux/camera_linux_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CameraLinuxView extends StatelessWidget {
  static GlobalKey cameraLinuxWidgetKey = GlobalKey();

  const CameraLinuxView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraLinuxViewModel>.reactive(
      viewModelBuilder: () => CameraLinuxViewModel(),
      builder: (builderContext, model, child) {
        if (model.isBusy || model.imageData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Image.memory(
          base64Decode(model.imageData),
          semanticLabel: 'frame',
        );
      },
    );
  }
}
