import 'package:face_detector/config/app_colors.dart';
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
import 'package:face_detector/widgets/custom_painters/custom_painter_hud_box.dart';
import 'package:face_detector/widgets/custom_painters/scanline_painter.dart';
import 'package:face_detector/widgets/hud/widget_circles_view.dart';
import 'package:face_detector/widgets/hud/widget_mixer_view.dart';
import 'package:face_detector/widgets/hud/widget_wall_text_view.dart';
import 'package:face_detector/widgets/square_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class RecognizeDefaultThemeView extends StatelessWidget {
  final Widget cameraView;
  final ScreenRecognizeViewModel screenRecognizeModel;

  const RecognizeDefaultThemeView({
    super.key,
    required this.screenRecognizeModel,
    required this.cameraView,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = DeviceUtils.isSmallScreen(context) ? 1 : 1.3;
    final double iconSize = 30 * scale;
    final double space = 16 * scale;

    bool showTapToRecognize =
        !Provider.of<SettingsProvider>(context, listen: false).getAutodetectFace();

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

    Widget tapToRecognize = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
      child: GestureDetector(
        onTap: () => screenRecognizeModel.takePictureAndAnalyze(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_open_sharp,
              size: DeviceUtils.isPortrait(context) ? 200 : 250,
              color: ThemeUtils.getDropdownItemColor(context).withOpacity(0.2),
            ),
            Text(
              CommonUtils.getLocalizedString(
                context,
                context.l10n.tap_to_recognize,
              ),
              style: DeviceUtils.isPortrait(context)
                  ? AppText.font25Bold.copyWith(color: Colors.white.withOpacity(0.5))
                  : AppText.font35Bold.copyWith(color: Colors.white.withOpacity(0.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (!DeviceUtils.isSmallScreen(context) || DeviceUtils.isLandscape(context)) {
      return LandscapeConfiguration(
        cameraView: cameraView,
        scale: scale,
        screenRecognizeModel: screenRecognizeModel,
        buttons: buttons,
        showTapToRecognize: showTapToRecognize,
        tapToRecognizeView: tapToRecognize,
      );
    }
    return PortraitConfiguration(
      cameraView: cameraView,
      scale: scale,
      screenRecognizeModel: screenRecognizeModel,
      buttons: buttons,
      showTapToRecognize: showTapToRecognize,
      tapToRecognizeView: tapToRecognize,
    );
  }
}

class PortraitConfiguration extends StatelessWidget {
  final Widget cameraView;
  final double scale;
  final ScreenRecognizeViewModel screenRecognizeModel;
  final List<Widget> buttons;
  final bool showTapToRecognize;
  final Widget tapToRecognizeView;

  const PortraitConfiguration({
    super.key,
    required this.cameraView,
    required this.scale,
    required this.screenRecognizeModel,
    required this.buttons,
    required this.showTapToRecognize,
    required this.tapToRecognizeView,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        cameraView,
        const IgnorePointer(
          ignoring: true,
          child: CustomPaint(
            size: Size.infinite,
            painter: ScanlinePainter(),
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Padding(
            padding: DeviceUtils.isIOS() ? const EdgeInsets.fromLTRB(4, 16, 2, 0) : EdgeInsets.zero,
            child: SvgPicture.asset(
              Assets.imageHudRecognizeRoundedSvg,
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.fill,
            ),
            // child: Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(Assets.imageHudRecognizeRounded),
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            // ),
          ),
        ),
        if (!screenRecognizeModel.isTakingPicture)
          Positioned(
            bottom: 30 + (DeviceUtils.isMobile() ? MediaQuery.paddingOf(context).bottom : 40),
            child: CustomPaint(
              painter: const CustomPainterHudBox(
                corner: Corner.topRight,
                cutLength: 10,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: buttons),
              ),
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
        if (screenRecognizeModel.isAnalyzing)
          GestureDetector(
            onTap: () => screenRecognizeModel.cancelRecognizeApiRequest(),
            child: DialogRecognizeView(
              imageData: screenRecognizeModel.recognizedPath,
              photos: screenRecognizeModel.peoplePhotos,
              found: screenRecognizeModel.userFound,
            ),
          ),
        if (screenRecognizeModel.countDown > 0)
          Text(
            screenRecognizeModel.countDown.toString(),
            style: AppText.font150Regular.copyWith(color: ThemeUtils.getDropdownItemColor(context)),
          ),
        if ((kIsWeb || showTapToRecognize) &&
            screenRecognizeModel.countDown == 0 &&
            !screenRecognizeModel.isTakingPicture &&
            !screenRecognizeModel.isAnalyzing)
          tapToRecognizeView,
      ],
    );
  }
}

class LandscapeConfiguration extends StatelessWidget {
  final Widget cameraView;
  final double scale;
  final Widget tapToRecognizeView;
  final bool showTapToRecognize;
  final ScreenRecognizeViewModel screenRecognizeModel;
  final List<Widget> buttons;

  const LandscapeConfiguration({
    super.key,
    required this.cameraView,
    required this.scale,
    required this.showTapToRecognize,
    required this.tapToRecognizeView,
    required this.screenRecognizeModel,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    double padding = ThemeUtils.getDefaultThemePadding(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        cameraView,
        const IgnorePointer(
          child: IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              size: Size.infinite,
              painter: ScanlinePainter(),
            ),
          ),
        ),
        IgnorePointer(
          child: SvgPicture.asset(
            Assets.imageHudRecognizeRoundedSvg,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.fill,
          ),
        ),
        // IgnorePointer(
        //   ignoring: true,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage(Assets.imageHudRecognizeRounded),
        //         fit: BoxFit.fill,
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          left: padding,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('V.A.R.S.', style: AppText.font15Bold),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('DATA', style: AppText.font15Bold),
                ),
                Expanded(
                  child: SizedBox(
                    width: 90,
                    child: CustomPaint(
                      painter: const CustomPainterHudBox(
                        corner: Corner.topRight,
                        cutLength: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListView.builder(
                                itemCount: 18,
                                itemBuilder: (_, __) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: WidgetMixerRowView(
                                      barWidth: 12,
                                      barSegments: 17,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('M.M.X.', style: AppText.font15Bold),
                ),
                const SizedBox(
                  height: 70,
                  child: WidgetCirclesView(numCircles: 2),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Positioned(
          right: padding,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.9,
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('POSITION', style: AppText.font15Bold),
                const SizedBox(height: 4),
                const Expanded(child: WidgetWallTextView()),
                CustomPaint(
                  painter: const CustomPainterHudBox(
                    corner: Corner.topLeft,
                    cutLength: 10,
                  ),
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: [
                        AppColors.defaultThemeHudCyan.withOpacity(0.5),
                        AppColors.defaultThemeHudCyanDark.withOpacity(0.5),
                      ],
                      durations: [5000, 4000],
                      heightPercentages: [0.65, 0.66],
                    ),
                    size: const Size(double.infinity, 80),
                    waveAmplitude: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!screenRecognizeModel.isTakingPicture)
          Positioned(
            bottom: padding / 2 * scale,
            child: CustomPaint(
              painter: const CustomPainterHudBox(
                corner: Corner.topLeft,
                cutLength: 10,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: buttons),
              ),
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
        if (screenRecognizeModel.isAnalyzing)
          GestureDetector(
            onTap: () => screenRecognizeModel.cancelRecognizeApiRequest(),
            child: DialogRecognizeView(
              imageData: screenRecognizeModel.recognizedPath,
              photos: screenRecognizeModel.peoplePhotos,
              found: screenRecognizeModel.userFound,
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
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              child: tapToRecognizeView,
            ),
          ),
      ],
    );
  }
}
