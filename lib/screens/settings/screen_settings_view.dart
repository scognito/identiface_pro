import 'package:face_detector/app_router.dart';
import 'package:face_detector/screens/settings/screen_settings_viewmodel.dart';
import 'package:face_detector/screens/settings/widgets/form_checkbox_row.dart';
import 'package:face_detector/screens/settings/widgets/form_dropdown_row.dart';
import 'package:face_detector/screens/settings/widgets/form_password_row.dart';
import 'package:face_detector/screens/settings/widgets/form_slider_row.dart';
import 'package:face_detector/screens/settings/widgets/form_tab_row.dart';
import 'package:face_detector/screens/settings/widgets/form_text_row.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/widgets/app_scaffold.dart';
import 'package:face_detector/widgets/loading_button/loading_button_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ScreenSettingsView extends StatelessWidget {
  const ScreenSettingsView({super.key = const ValueKey(Routes.settings)});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ViewModelBuilder<ScreenSettingsViewModel>.reactive(
        viewModelBuilder: () => ScreenSettingsViewModel(context: context),
        builder: (builderContext, model, child) {
          return SafeArea(
            child: Scrollbar(
              controller: model.scrollController,
              thumbVisibility: true,
              child: Form(
                key: model.formKey,
                child: SingleChildScrollView(
                  controller: model.scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FormPasswordRow(
                          controller: model.masterPasswordController,
                        ),
                        FormTextRow(
                          label: builderContext.l10n.base_url,
                          controller: model.baseURLController,
                          customValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.error_mandatory_field,
                              );
                            }
                            if (!value.startsWith('http://') && !value.startsWith('https://')) {
                              return CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.error_url_scheme,
                              );
                            }
                            if (CommonUtils.getValidBaseUrl(value).isEmpty) {
                              return CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.error_invalid_url,
                              );
                            }
                            return null;
                          },
                          child: LoadingButtonView(
                            label: 'TEST',
                            onPressed: () async => await model.testConnection(),
                          ),
                        ),
                        FormTextRow(
                          label: builderContext.l10n.api_key,
                          controller: model.apiKeyController,
                        ),
                        FormSliderRow(
                          label: builderContext.l10n.similarity_threshold,
                          model: model,
                        ),
                        FormTabRow(
                          label: builderContext.l10n.external_api_call,
                          description: builderContext.l10n.popup_external_api_call,
                          model: model,
                        ),
                        FormDropdownRow(
                          label: builderContext.l10n.theme,
                          options: kThemes,
                          selectedOption: model.theme,
                          onMenuItemTap: (theme) => model.setTheme(theme),
                        ),
                        FormCheckboxRow(
                          label: builderContext.l10n.show_faces_in_recognize,
                          description: builderContext.l10n.popup_show_faces,
                          currentValue: model.fastRecognize,
                          onChanged: (value) => model.setFastRecognize(value!),
                        ),
                        if (DeviceUtils.isDesktop())
                          FormCheckboxRow(
                            label: builderContext.l10n.fullscreen,
                            currentValue: model.fullScreen,
                            onChanged: (value) => model.setFullScreen(value!),
                          ),
                        if (DeviceUtils.isMacOS() || DeviceUtils.isMobile())
                          FormCheckboxRow(
                            label: builderContext.l10n.auto_detect_face,
                            description: builderContext.l10n.popup_autodetect,
                            currentValue: model.autodetectFace,
                            onChanged: (value) => model.setAutodetectFace(value!),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if (kIsDebugLocal)
                            //   ElevatedButton(
                            //     onPressed: () async => await model.resetSettings(),
                            //     child: const Text('RESET'),
                            //   ),
                            // ElevatedButton(
                            //   onPressed: () => model.goBack(),
                            //   child: Text(
                            //     CommonUtils.getLocalizedString(
                            //       context,
                            //       context.l10n.button_close,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () => model.saveSettings(exit: true),
                              child: Text(CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.button_save,
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
