import 'package:crop_image/crop_image.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/screens/crop_image/screen_crop_viewmodel.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ScreenCropView extends StatelessWidget {
  final String imagePath;

  const ScreenCropView({required this.imagePath, super.key = const ValueKey(Routes.crop)});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ViewModelBuilder<ScreenCropViewModel>.reactive(
        viewModelBuilder: () => ScreenCropViewModel(context: context, imagePath: imagePath),
        builder: (builderContext, model, child) {
          if (model.isBusy) {
            return const Center(child: CircularProgressIndicator());
          } else if (model.image == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(CommonUtils.getLocalizedString(
                    context,
                    context.l10n.an_error_occurred,
                  )),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => model.onCancelButtonPressed(),
                    child: Text(
                      CommonUtils.getLocalizedString(
                        context,
                        context.l10n.button_close,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CropImage(
                  controller: model.cropController,
                  image: model.image!,
                  paddingSize: 25.0,
                  alwaysMove: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => model.onCancelButtonPressed(),
                    child: Text(CommonUtils.getLocalizedString(
                      context,
                      context.l10n.button_cancel,
                    )),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => model.onDoneButtonPressed(),
                    child: Text(CommonUtils.getLocalizedString(
                      context,
                      context.l10n.button_confirm,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
