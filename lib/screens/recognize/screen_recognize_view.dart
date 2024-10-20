import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/screens/recognize/screen_recognize_viewmodel.dart';
import 'package:face_detector/screens/recognize/theme/recognize_default_theme_view.dart';
import 'package:face_detector/screens/recognize/theme/recognize_material_theme_view.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/widgets/app_scaffold.dart';
import 'package:face_detector/widgets/camera_mac/camera_mac_view.dart';
import 'package:face_detector/widgets/camera_mobile/camera_mobile_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ScreenRecognizeView extends StatelessWidget {
  const ScreenRecognizeView({super.key = const ValueKey(Routes.recognize)});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.black,
      child: ViewModelBuilder<ScreenRecognizeViewModel>.reactive(
        viewModelBuilder: () => ScreenRecognizeViewModel(context: context),
        builder: (builderContext, model, child) {
          String theme = Provider.of<SettingsProvider>(builderContext).getThemeName();

          late Widget cameraView;

          if (kUseDummyCamera || CommonUtils.isRunningInTest()) {
            cameraView = const SizedBox();
          } else {
            if (DeviceUtils.isMacOS()) {
              cameraView = CameraMacView(
                key: CameraMacView.cameraMacWidgetKey,
                enableRecognize: model.recognizeEnabled,
                onFacesDetected: (List<Rect> faces, InputImage img) =>
                    model.analyzeImageMacOS(faces, img),
              );
            } else if (kIsWeb || DeviceUtils.isMobile() || DeviceUtils.isWindows()) {
              cameraView = CameraMobileView(
                key: CameraMobileView.cameraMobileWidgetKey,
                onImage: (InputImage img) => model.analyzeImage(img),
              );
            }
            // else if ( DeviceUtils.isLinux()) {
            //   cameraView = CameraLinuxView(
            //     key: CameraLinuxView.cameraLinuxWidgetKey,
            //   );
            // }
            else {
              cameraView = const SizedBox(
                child: Text('Platform not supported'),
              );
            }
          }

          if (model.isBusy) {
            return const Center(child: CircularProgressIndicator());
          }

          switch (theme) {
            case kThemeMaterial:
              return RecognizeMaterialThemeView(
                screenRecognizeModel: model,
                cameraView: cameraView,
              );
            default:
              return RecognizeDefaultThemeView(
                screenRecognizeModel: model,
                cameraView: cameraView,
              );
          }
        },
      ),
    );
  }
}
