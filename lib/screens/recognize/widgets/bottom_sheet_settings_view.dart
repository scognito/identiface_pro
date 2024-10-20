import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/config/assets.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_settings_viewmodel.dart';
import 'package:face_detector/screens/settings/widgets/form_button_row.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BottomSheetSettingsView extends StatelessWidget {
  final String? defaultPerson;

  const BottomSheetSettingsView({super.key, this.defaultPerson});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomSheetSettingsViewmodel>.reactive(
      viewModelBuilder: () => BottomSheetSettingsViewmodel(
        context: context,
        defaultPerson: defaultPerson,
      ),
      builder: (builderContext, model, child) {
        Widget body = const SizedBox();
        if (model.isBusy) {
          body = SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: CircularProgressIndicator(),
                ),
                ElevatedButton(
                  onPressed: () => model.closeBottomSheet(),
                  child: Text(
                    CommonUtils.getLocalizedString(
                      builderContext,
                      builderContext.l10n.button_close,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (model.hasError) {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(model.error.toString()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.an_error_occurred,
                  ),
                ),
              ), //an_error_occurred
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => model.initialise(),
                    child: Text(CommonUtils.getLocalizedString(
                      builderContext,
                      builderContext.l10n.button_retry,
                    )), // button_retry
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => model.closeBottomSheet(),
                    child: Text(CommonUtils.getLocalizedString(
                      builderContext,
                      builderContext.l10n.button_close,
                    )),
                  ),
                ],
              ),
            ],
          );
        } else {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        CommonUtils.getLocalizedString(builderContext, builderContext.l10n.user),
                        style: AppText.font18Regular
                            .copyWith(color: ThemeUtils.getSettingsLabelColor(builderContext)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: model.currentPerson,
                          hint: Text(
                            CommonUtils.getLocalizedString(
                              builderContext,
                              builderContext.l10n.empty_list,
                            ),
                          ),
                          isExpanded: true,
                          items: model.personList.map((String name) {
                            return DropdownMenuItem<String>(value: name, child: Text(name));
                          }).toList(),
                          onChanged: (String? newValue) {
                            model.setCurrentPerson(newValue!);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.error_mandatory_field,
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!model.isBusy && model.currentPerson != null)
                    FormButtonRow(
                      label: CommonUtils.getLocalizedString(
                        builderContext,
                        builderContext.l10n.edit_user,
                      ),
                      btn: SquareButton(
                        onTap: () => model.editPerson(),
                        asset: Assets.iconEditPerson,
                        iconSize: 30,
                      ),
                    ),
                  if (!model.isBusy && model.currentPerson != null)
                    FormButtonRow(
                      label: CommonUtils.getLocalizedString(
                        builderContext,
                        builderContext.l10n.add_image_for_name(model.currentPerson!),
                      ),
                      btn: SquareButton(
                        onTap: () => model.takePicture(),
                        asset: Assets.iconAddUserImage,
                        iconSize: 30,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => model.closeBottomSheet(),
                    child: Text(CommonUtils.getLocalizedString(
                      builderContext,
                      builderContext.l10n.button_close,
                    )),
                  ),
                  if (!model.isBusy)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ElevatedButton(
                        onPressed: () => model.addPerson(),
                        child: Text(CommonUtils.getLocalizedString(
                          builderContext,
                          builderContext.l10n.button_create_user,
                        )),
                      ),
                    ),
                ],
              ),
            ],
          );
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            model.closeBottomSheet();
          },
          child: Padding(padding: const EdgeInsets.all(16.0), child: body),
        );
      },
    );
  }
}
