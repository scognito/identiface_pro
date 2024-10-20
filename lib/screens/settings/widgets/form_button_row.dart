import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class FormButtonRow extends StatelessWidget {
  final String label;
  final String? buttonLabel;
  final Widget? btn;
  final Function()? onButtonTap;

  const FormButtonRow({
    required this.label,
    this.buttonLabel,
    this.btn,
    this.onButtonTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textLabel = Text(
      label,
      style: AppText.font18Regular.copyWith(color: ThemeUtils.getSettingsLabelColor(context)),
    );

    final button = buttonLabel != null
        ? ElevatedButton(
            onPressed: () {
              if (onButtonTap != null) {
                onButtonTap!();
              }
            },
            child: Text(buttonLabel!),
          )
        : btn ?? const Icon(Icons.question_mark);

    if (DeviceUtils.isLandscape(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textLabel,
            const SizedBox(width: 16),
            Expanded(
              child: Align(alignment: Alignment.centerRight, child: button),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: textLabel),
          const SizedBox(width: 16),
          button,
        ],
      ),
    );
  }
}
