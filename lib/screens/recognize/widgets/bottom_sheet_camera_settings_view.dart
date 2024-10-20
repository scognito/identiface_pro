import 'package:face_detector/config/assets.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_camera_settings_viewmodel.dart';
import 'package:face_detector/screens/settings/widgets/form_button_row.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BottomSheetCameraSettingsView extends StatelessWidget {
  const BottomSheetCameraSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomSheetCameraSettingsViewmodel>.reactive(
      viewModelBuilder: () => BottomSheetCameraSettingsViewmodel(context: context),
      builder: (builderContext, model, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            model.closeBottomSheet();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: model.isBusy
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (model.cameraCount > 1)
                              FormButtonRow(
                                label: CommonUtils.getLocalizedString(
                                  builderContext,
                                  builderContext.l10n.change_camera,
                                ),
                                btn: SquareButton(
                                  onTap: () => model.changeCamera(),
                                  asset: Assets.switchCameraIcon,
                                  iconSize: 30,
                                ),
                              ),
                            if (model.hasFeature(CameraFeature.rotate))
                              FormButtonRow(
                                label: CommonUtils.getLocalizedString(
                                  builderContext,
                                  builderContext.l10n.change_orientation,
                                ),
                                btn: SquareButton(
                                  onTap: () => model.changeOrientation(),
                                  asset: Assets.switchCameraIcon,
                                  iconSize: 30,
                                ),
                              ),
                            if (model.hasFeature(CameraFeature.lock))
                              FormButtonRow(
                                label: model.isCameraLocked()
                                    ? CommonUtils.getLocalizedString(
                                        builderContext,
                                        builderContext.l10n.unlock_orientation,
                                      )
                                    : CommonUtils.getLocalizedString(
                                        builderContext,
                                        builderContext.l10n.lock_orientation,
                                      ),
                                btn: SquareButton(
                                  onTap: () => model.toggleLockCamera(),
                                  asset: Assets.switchCameraIcon,
                                  iconSize: 30,
                                ),
                              ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => model.closeBottomSheet(),
                  child: Text(CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.button_close,
                  )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
