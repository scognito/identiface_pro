import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/config/assets.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/screens/recognize/screen_recognize_viewmodel.dart';
import 'package:face_detector/screens/recognize/widgets/dialog_recognize_view.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/widgets/square_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecognizeMaterialThemeView extends StatelessWidget {
  final Widget cameraView;
  final ScreenRecognizeViewModel screenRecognizeModel;

  const RecognizeMaterialThemeView({
    super.key,
    required this.screenRecognizeModel,
    required this.cameraView,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = DeviceUtils.isSmallScreen(context) ? 1 : 1.3;
    final double iconSize = 30 * scale;
    final double space = 16 * scale;

    List<Widget> buttons = [
      SquareButton(
        onTap: () => screenRecognizeModel.navigateToSettings(),
        asset: Assets.iconSettings,
        iconSize: iconSize,
      ),
      if (kIsDebugLocal) ...[
        SizedBox(width: space, height: space),
        SquareButton(
          onTap: () => screenRecognizeModel.toggleRecognizeEnabled(),
          asset: screenRecognizeModel.recognizeEnabled.value ? Assets.iconEyeOn : Assets.iconEyeOff,
          iconSize: iconSize,
        ),
      ],
      SizedBox(width: space, height: space),
      SquareButton(
        onTap: () => screenRecognizeModel.showSettingsBottomSheet(),
        asset: Assets.iconAddUser,
        iconSize: iconSize,
      ),
      if (screenRecognizeModel.cameraCount > 1 || screenRecognizeModel.hasCameraFeatures) ...[
        SizedBox(width: space, height: space),
        SquareButton(
          onTap: () => screenRecognizeModel.showCameraSettingsBottomSheet(),
          asset: Assets.cameraIcon,
          iconSize: iconSize,
        ),
      ],
    ];

    bool showTapToRecognize =
        !Provider.of<SettingsProvider>(context, listen: false).getAutodetectFace();

    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(child: cameraView),
          if (screenRecognizeModel.isAnalyzing)
            GestureDetector(
              onTap: () => screenRecognizeModel.cancelRecognizeApiRequest(),
              child: DialogRecognizeView(
                imageData: screenRecognizeModel.recognizedPath,
                photos: screenRecognizeModel.peoplePhotos,
                found: screenRecognizeModel.userFound,
              ),
            ),
          if (!screenRecognizeModel.isTakingPicture)
            Positioned(
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: buttons,
              ),
            ),
          if (kIsDebugLocal)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => screenRecognizeModel.test(),
                child: const Icon(Icons.camera),
              ),
            ),
          if (screenRecognizeModel.countDown > 0)
            Text(
              screenRecognizeModel.countDown.toString(),
              style:
                  AppText.font150Regular.copyWith(color: ThemeUtils.getSettingsLabelColor(context)),
            ),
          if ((kIsWeb || showTapToRecognize) &&
              screenRecognizeModel.countDown == 0 &&
              !screenRecognizeModel.isTakingPicture &&
              !screenRecognizeModel.isAnalyzing)
            Positioned(
              bottom: DeviceUtils.isIOS() ? MediaQuery.paddingOf(context).bottom : 20 * scale,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: GestureDetector(
                  onTap: () => screenRecognizeModel.takePictureAndAnalyze(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_open_sharp,
                            size: DeviceUtils.isPortrait(context) ? 20 : 40,
                            color: ThemeUtils.getDropdownItemColor(context),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            CommonUtils.getLocalizedString(
                              context,
                              context.l10n.tap_here_recognize,
                            ),
                            style: DeviceUtils.isMobile()
                                ? AppText.font18Regular.copyWith(
                                    color: ThemeUtils.getSettingsLabelColor(context),
                                  )
                                : AppText.font25Regular.copyWith(
                                    color: ThemeUtils.getSettingsLabelColor(context),
                                  ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
