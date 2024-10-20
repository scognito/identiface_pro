import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/screens/settings/screen_settings_viewmodel.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class FormSliderRow extends StatelessWidget {
  final String label;
  final ScreenSettingsViewModel model;

  const FormSliderRow({super.key, required this.label, required this.model});

  @override
  Widget build(BuildContext context) {
    final textLabel = Text(
      CommonUtils.getLocalizedString(context, label),
      style: AppText.font18Regular.copyWith(color: ThemeUtils.getSettingsLabelColor(context)),
    );

    final slider = Slider(
      value: model.similarityThreshold,
      min: 0,
      max: 1,
      label: (model.similarityThreshold * 100).toStringAsFixed(0),
      onChanged: (double value) {
        model.setSimilarity(value);
      },
    );

    if (DeviceUtils.isLandscape(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 1, child: textLabel),
            const SizedBox(width: 16),
            Flexible(flex: 2, child: slider),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textLabel,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Expanded(child: slider)],
          ),
        ],
      ),
    );
  }
}
