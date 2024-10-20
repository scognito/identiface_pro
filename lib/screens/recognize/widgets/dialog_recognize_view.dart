import 'dart:typed_data';

import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/config/assets.dart';
import 'package:face_detector/screens/recognize/widgets/avatar_widget.dart';
import 'package:face_detector/screens/recognize/widgets/dialog_recognize_viewmodel.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stacked/stacked.dart';

class DialogRecognizeView extends StatelessWidget {
  final List<PhotoType> photos;
  final Uint8List? imageData;
  final bool? found;

  const DialogRecognizeView({
    this.imageData,
    required this.photos,
    required this.found,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = ThemeUtils.getRecognizeDialogHeight(context);

    return ViewModelBuilder<DialogRecognizeViewModel>.reactive(
      viewModelBuilder: () => DialogRecognizeViewModel(
        context: context,
        photos: photos,
        found: found,
      ),
      builder: (builderContext, model, child) {
        if (model.showRollingFaces()) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: height * 1.5,
              height: height,
              decoration: model.getThemeDecoration(),
              child: found == null
                  ? RollingFacesView(
                      model: model,
                      isRolling: true,
                      found: found,
                      key: const ValueKey(true),
                    )
                  : RollingFacesView(
                      model: model,
                      isRolling: false,
                      found: found,
                      key: const ValueKey(false),
                      foundWidget: imageData == null || found! == false
                          ? Image.asset(Assets.imageCyborg, semanticLabel: 'cyborg')
                          : Image.memory(imageData!, semanticLabel: 'user'),
                    ),
            ),
          );
        }
        return Container(
          decoration: ThemeUtils.getBorderTheme(builderContext).copyWith(
            color: Theme.of(builderContext).colorScheme.surface,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(model.getLoadingMessage(found)),
              if (found == null)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class RollingFacesView extends StatelessWidget {
  final DialogRecognizeViewModel model;

  final bool isRolling;
  final bool? found;
  final Widget? foundWidget;

  const RollingFacesView({
    required this.model,
    required this.isRolling,
    this.found,
    this.foundWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double space = 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (builderContext, constraints) {
                  double avatarWidth = constraints.maxWidth;
                  return AvatarWidget(
                    key: ValueKey(model.currentPhoto().path),
                    model: model,
                    isLeftWidget: true,
                    foundWidget: foundWidget,
                  ).animate(effects: [
                    MoveEffect(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      begin: Offset.zero,
                      end: isRolling ? Offset.zero : Offset((avatarWidth / 2) + space / 2, 0),
                    ),
                  ]);
                }),
              ),
              const SizedBox(width: space),
              Expanded(
                child: LayoutBuilder(builder: (builderContext, constraints) {
                  double avatarWidth = constraints.maxWidth;
                  return AvatarWidget(
                    key: ValueKey(model.currentShiftedPhoto().path),
                    model: model,
                    isLeftWidget: false,
                    foundWidget: foundWidget,
                  ).animate(effects: [
                    MoveEffect(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      begin: Offset.zero,
                      end: isRolling ? Offset.zero : Offset((-avatarWidth / 2) - space / 2, 0),
                    ),
                  ]);
                }),
              ),
            ],
          ),
          if (!isRolling && found != null)
            Container(
              color: Colors.black45,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  found! ? '[ MATCH ]' : '[ NO MATCH ]',
                  textAlign: TextAlign.center,
                  style: DeviceUtils.isSmallScreen(context)
                      ? AppText.font25Bold.copyWith(
                          color: found! ? Colors.green : Colors.red,
                        )
                      : AppText.font35Bold.copyWith(
                          color: found! ? Colors.green : Colors.red,
                        ),
                ),
              ),
            ).animate(effects: [const FadeEffect(), const ScaleEffect()]),
        ],
      ),
    );
  }
}
