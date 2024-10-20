import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/config/assets.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/widgets/square_button.dart';
import 'package:flutter/material.dart';

class FormPasswordRow extends StatefulWidget {
  final TextEditingController controller;

  const FormPasswordRow({super.key, required this.controller});

  @override
  State<FormPasswordRow> createState() => _FormPasswordRowState();
}

class _FormPasswordRowState extends State<FormPasswordRow> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final textLabel = Text(
      CommonUtils.getLocalizedString(context, context.l10n.password),
      style: AppText.font18Regular.copyWith(color: ThemeUtils.getSettingsLabelColor(context)),
    );

    final inputField = TextFormField(
      obscureText: !passwordVisible,
      obscuringCharacter: '*',
      controller: widget.controller,
      style: const TextStyle(fontSize: 18),
      validator: (value) {
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
          children: [
            Flexible(flex: 1, child: textLabel),
            const SizedBox(width: 16),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: inputField),
                  const SizedBox(width: 16),
                  SquareButton(
                    asset: passwordVisible ? Assets.iconEyeOn : Assets.iconEyeOff,
                    onTap: () => setState(() {
                      passwordVisible = !passwordVisible;
                    }),
                  ),
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
              const SizedBox(width: 16),
              SquareButton(
                asset: passwordVisible ? Assets.iconEyeOn : Assets.iconEyeOff,
                onTap: () => setState(() {
                  passwordVisible = !passwordVisible;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
