import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/screens/menu/screen_menu_viewmodel.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ScreenMenuView extends StatelessWidget {
  const ScreenMenuView({super.key = const ValueKey(Routes.menu)});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ViewModelBuilder<ScreenMenuViewModel>.reactive(
        viewModelBuilder: () => ScreenMenuViewModel(context: context),
        builder: (builderContext, model, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'IdentiFace PRO',
                      style: AppText.font80Regular.copyWith(
                        color: ThemeUtils.getSettingsLabelColor(builderContext),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (kIsDebugLocal)
                  ElevatedButton(
                    onPressed: () => model.navigateToRecognize(),
                    child: const Text('RECOGNIZE'),
                  ),
                ElevatedButton(
                  onPressed: () => model.navigateToSettings(),
                  child: Text(CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.settings,
                  )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
