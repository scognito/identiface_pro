import 'package:face_detector/screens/recognize/widgets/dialog_recognize_viewmodel.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final DialogRecognizeViewModel model;

  final bool isLeftWidget;
  final Widget? foundWidget;

  const AvatarWidget({
    required this.model,
    required this.isLeftWidget,
    this.foundWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PhotoType currentPhoto = isLeftWidget ? model.currentPhoto() : model.currentShiftedPhoto();

    return Column(
      children: [
        Expanded(
          child: foundWidget ??
              (currentPhoto.type == MediaType.asset
                  ? Image.asset(currentPhoto.path, semanticLabel: 'current photo')
                  : const SizedBox.shrink()),
        ),
        //if (foundWidget == null) Text(model.getNameFromAsset(currentPhoto.path)),
      ],
    );
  }
}
