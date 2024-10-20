import 'package:face_detector/config/constants.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/widgets/dialog_warning/dialog_warning_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DialogWarningView extends StatelessWidget {
  const DialogWarningView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DialogWarningViewmodel>.reactive(
      viewModelBuilder: () => DialogWarningViewmodel(context: context),
      builder: (builderContext, model, child) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CommonUtils.getLocalizedString(builderContext, builderContext.l10n.warning),
                style: TextStyle(
                  color: Theme.of(builderContext).colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                onPressed: () => model.closeAlert(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(CommonUtils.getLocalizedString(
                  builderContext,
                  builderContext.l10n.compreface_warning,
                )),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () => model.openURL(kComprefaceURL),
                child: Text(
                  CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.more_info,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () => model.openURL(kTutorialURL),
                child: Text(
                  CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.tutorial,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
