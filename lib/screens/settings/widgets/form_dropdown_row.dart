import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class FormDropdownRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selectedOption;
  final Function(String option) onMenuItemTap;

  const FormDropdownRow({
    required this.label,
    required this.options,
    required this.selectedOption,
    required this.onMenuItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textLabel = Text(
      CommonUtils.getLocalizedString(context, label),
      style: AppText.font18Regular.copyWith(color: ThemeUtils.getSettingsLabelColor(context)),
    );

    final dropdown = Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        child: DropdownButtonFormField<String>(
          value: selectedOption,
          isExpanded: true,
          items: options.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Text(
                CommonUtils.getLocalizedString(context, name.capitalizeFirst()),
                style:
                    AppText.font18Regular.copyWith(color: ThemeUtils.getDropdownItemColor(context)),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            onMenuItemTap(newValue!);
          },
        ),
      ),
    );

    if (DeviceUtils.isLandscape(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 1, child: textLabel),
            const SizedBox(width: 16),
            Flexible(flex: 2, child: dropdown),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: textLabel), Expanded(child: dropdown)],
      ),
    );
  }
}
