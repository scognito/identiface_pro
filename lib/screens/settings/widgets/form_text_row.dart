import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class FormTextRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? child;
  final Function(String?)? customValidator;

  const FormTextRow({
    super.key,
    required this.label,
    required this.controller,
    this.child,
    this.customValidator,
  });

  @override
  Widget build(BuildContext context) {
    final textLabel = Text(
      CommonUtils.getLocalizedString(context, label),
      style: AppText.font18Regular.copyWith(color: ThemeUtils.getSettingsLabelColor(context)),
    );

    final inputField = TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 18),
      validator: (value) {
        if (customValidator != null) {
          return customValidator!(value);
        }

        if (value == null || value.isEmpty) {
          return CommonUtils.getLocalizedString(
            context,
            context.l10n.error_mandatory_field,
          );
        }
        return null;
      },
    );

    if (DeviceUtils.isLandscape(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 1, child: textLabel),
            const SizedBox(width: 16),
            Flexible(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: inputField),
                  if (child != null) ...[const SizedBox(width: 16), child!],
                ],
              ),
            ),
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
            children: [
              Expanded(child: inputField),
              if (child != null) ...[const SizedBox(width: 16), child!],
            ],
          ),
        ],
      ),
    );
  }
}
