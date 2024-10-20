import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class FormCheckboxRow extends StatelessWidget {
  final String label;
  final Function(bool? value) onChanged;
  final bool currentValue;
  final String? description;

  const FormCheckboxRow({
    required this.label,
    required this.onChanged,
    required this.currentValue,
    this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final infoIcon = description != null
        ? Icon(
            Icons.info_outline,
            size: 16,
            color: ThemeUtils.getSettingsLabelColor(context),
          )
        : const SizedBox.shrink();

    final text = RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 18,
              color: ThemeUtils.getSettingsLabelColor(context),
            ),
        children: [
          TextSpan(text: CommonUtils.getLocalizedString(context, label)),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 3.0),
              child: infoIcon,
            ),
          ),
        ],
      ),
    );

    final checkbox = Checkbox(
      value: currentValue,
      onChanged: (bool? value) {
        onChanged(value);
      },
    );

    if (DeviceUtils.isLandscape(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () => description != null
                    ? WidgetUtils.showAlertDialog(
                        context: context,
                        title: CommonUtils.getLocalizedString(context, label),
                        message: CommonUtils.getLocalizedString(context, description!),
                      )
                    : null,
                child: text,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(flex: 2, child: checkbox),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: () => description != null
            ? WidgetUtils.showAlertDialog(
                context: context,
                title: CommonUtils.getLocalizedString(context, label),
                message: CommonUtils.getLocalizedString(context, description!),
              )
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Expanded(child: text), checkbox],
        ),
      ),
    );
  }
}
